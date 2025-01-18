import LiveKitKrispNoiseFilterShared
import KrispNoiseFilterBVC

public final class LiveKitKrispNoiseFilter: LiveKitKrispNoiseFilterShared.LiveKitKrispNoiseFilter {
    public override init(modelType: LiveKitKrispModelType) {
        if modelType != .BVC {
            print("KrispNoiseFilterBVC only type is required for this class")
        }

        self.krisp = KrispNoiseFilter()

        if !KrispNoiseFilter.krispGlobalInit(.BVC) {
            print("KrispNoiseFilterBVC GlobalInit Failed")
        }

        super.init()
    }
}

