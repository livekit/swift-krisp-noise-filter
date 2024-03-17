/*
 * Copyright 2024 LiveKit
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import KrispNoiseFilter
import LiveKit

enum LiveKitKrispNoiseFilterError: Error {
    case resourceNotFound
}

public class LiveKitKrispNoiseFilter: AudioCustomProcessingDelegate {
    let krisp: KrispNoiseFilter

    public init() throws {
        guard let resourceURL = Bundle.module.url(forResource: "c6.f.s.ced125", withExtension: "kw") else {
            throw LiveKitKrispNoiseFilterError.resourceNotFound
        }
        let model = try Data(contentsOf: resourceURL)
        krisp = KrispNoiseFilter(modelBlob: model)
    }

    public func audioProcessingInitialize(sampleRate sampleRateHz: Int, channels: Int) {
        krisp.initialize(Int32(sampleRateHz), numChannels: Int32(channels))
    }

    public func audioProcessingProcess(audioBuffer: LiveKit.LKAudioBuffer) {
        krisp.process(Int32(audioBuffer.bands),
                      numFrames: Int32(audioBuffer.frames),
                      bufferSize: Int32(audioBuffer.framesPerBand),
                      buffer: audioBuffer.rawBuffer(forChannel: 0))
    }

    public func audioProcessingRelease() {
        //
    }

    // New

    public func audioProcessingRoomDidConnect(withUrl url: String, token: String) {
        krisp.isEnabled(url, withToken: token)
    }

    public func audioProcessingName() -> String {
        krisp.getName()
    }
}
