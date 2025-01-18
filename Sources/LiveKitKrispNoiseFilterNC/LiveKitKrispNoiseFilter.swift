import LiveKitKrispNoiseFilterShared
import KrispNoiseFilterNC

public final class LiveKitKrispNoiseFilter: LiveKitKrispNoiseFilterShared.LiveKitKrispNoiseFilter {
    public override init(modelType: LiveKitKrispModelType) {
        if modelType != .NC {
            print("KrispNoiseFilterNC only supports NC model type")
        }

        self.krisp = KrispNoiseFilter()     

        if !KrispNoiseFilter.krispGlobalInit(.NC) {
            print("KrispNoiseFilterNC GlobalInit Failed")
        }   

        super.init()
    }
}
