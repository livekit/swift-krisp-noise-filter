import Foundation
import KrispNoiseFilter
import LiveKit
import Combine

public enum LiveKitKrispModelType {
    case NC
    case BVC

    var krispModelType: KrispModelType {
        switch self {
        case .NC: return .NC
        case .BVC: return .BVC
        }
    }
}

enum LiveKitKrispNoiseFilterError: Error {
    case globalInitializationFailed
}

public class LiveKitKrispNoiseFilter {
    public var isEnabled: Bool {
        get { _state.isEnabled }
        set { _state.mutate { $0.isEnabled = newValue } }
    }

    private let krisp = KrispNoiseFilter()

    private struct State {
        var isEnabled: Bool = true
        var isInitializedWithRate: Int?
    }

    private let _state = StateSync(State())

    private let errorSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    public init(modelType: LiveKitKrispModelType = .NC) {
        // This should never fail
        if !KrispNoiseFilter.krispGlobalInit(modelType.krispModelType) {
            print("LiveKitKrispNoiseFilter GlobalInit Failed with \(modelType)")
        }

        // Throttle high-frequency errors to avoid spamming the console
        errorSubject
            .throttle(for: .seconds(60), scheduler: DispatchQueue.main, latest: true)
            .sink { message in
                print(message)
            }
            .store(in: &cancellables)
    }
}

extension LiveKitKrispNoiseFilter: AudioCustomProcessingDelegate {
    public var audioProcessingName: String { kLiveKitKrispAudioProcessorName }

    // This will be invoked anytime sample rate changes, for example switching Speaker <-> AirPods.
    public func audioProcessingInitialize(sampleRate sampleRateHz: Int, channels: Int) {
        let isFirstInitialize = _state.mutate {
            let result = $0.isInitializedWithRate == nil
            $0.isInitializedWithRate = sampleRateHz
            return result
        }

        if isFirstInitialize {
            krisp.initialize(Int32(sampleRateHz), numChannels: Int32(channels))
        } else {
            // Krisp already initialized, reset with new sample rate.
            krisp.reset(Int32(sampleRateHz))
        }
    }

     public func audioProcessingProcess(audioBuffer: LiveKit.LKAudioBuffer) {
        guard _state.isEnabled else { return }

        guard krisp.isAuthorized else {
            errorSubject.send("LiveKitKrispNoiseFilter disabled - This feature is supported only on LiveKit Cloud.")
            return
        }

        // For stereo input, we need to mix down to mono
        if audioBuffer.channels > 1 {
            // Create a temporary buffer for the mixed audio
            var mixedBuffer = [Float](repeating: 0, count: audioBuffer.framesPerBand)
            
            // Mix all channels
            for frame in 0..<audioBuffer.framesPerBand {
                var sum: Float = 0
                for channel in 0..<audioBuffer.channels {
                    sum += audioBuffer.rawBuffer(forChannel: channel)[frame]
                }
                // Average the sum to maintain consistent volume
                mixedBuffer[frame] = sum / Float(audioBuffer.channels)
            }
            
            // Process the mixed mono audio
            let result = mixedBuffer.withUnsafeMutableBufferPointer { ptr in
                krisp.process(withBands: Int32(audioBuffer.bands),
                             frames: Int32(audioBuffer.frames),
                             bufferSize: Int32(audioBuffer.framesPerBand),
                             buffer: ptr.baseAddress!)
            }
            
            if !result {
                errorSubject.send("LiveKitKrispNoiseFilter Process failed")
            }
            
            // Copy the processed audio back to all channels
            for channel in 0..<audioBuffer.channels {
                memcpy(audioBuffer.rawBuffer(forChannel: channel),
                       mixedBuffer,
                       audioBuffer.framesPerBand * MemoryLayout<Float>.size)
            }
        } else {
            // For mono input, process directly
            let result = audioBuffer.rawBuffer(forChannel: 0).withUnsafeMutableBufferPointer { ptr in
                krisp.process(withBands: Int32(audioBuffer.bands),
                             frames: Int32(audioBuffer.frames),
                             bufferSize: Int32(audioBuffer.framesPerBand),
                             buffer: ptr.baseAddress!)
            }
            if !result {
                errorSubject.send("LiveKitKrispNoiseFilter Process failed")
            }
        }
    }

    public func audioProcessingRelease() {
        print("LiveKitKrispNoiseFilter Release")
    }
}

extension LiveKitKrispNoiseFilter: RoomDelegate {
    public func room(_ room: Room, didUpdateConnectionState connectionState: ConnectionState, from oldConnectionState: ConnectionState) {
        krisp.update(room.toContext(connectionState))
    }
}

extension Room {
    func toContext(_ connectionState: ConnectionState) -> LiveKitRoomContext {
        LiveKitRoomContext(sid: sid?.stringValue,
                           name: name,
                           serverVersion: serverVersion,
                           serverRegion: serverRegion,
                           serverNodeId: serverNodeId,
                           connectionState: LiveKitConnectionState(rawValue: connectionState.rawValue) ?? .Disconnected,
                           url: url,
                           token: token)
    }
}
