import LiveKitKrispNoiseFilterShared
import KrispNoiseFilter

public final class LiveKitKrispNoiseFilter: LiveKitKrispNoiseFilterShared.LiveKitKrispNoiseFilter {
    public override init(modelType: LiveKitKrispModelType) {        // This should never fail
        self.krisp = KrispNoiseFilter()

        let krispModelType: KrispNoiseFilterModelType
        switch modelType {
        case .NC:
            krispModelType = .NC
        case .BVC:
            krispModelType = .BVC
        }
        
        if !KrispNoiseFilter.krispGlobalInit(krispModelType) {
            print("LiveKitKrispNoiseFilter GlobalInit Failed with \(krispModelType)")
        }

        super.init()
    }
}
