import Foundation

enum AppBannerAds: String {
    case testBanner = "test_banner"

    var unitId: String {
    #if DEV
        return "ca-app-pub-3940256099942544/2934735716"
    #elseif PRD
        return "ca-app-pub-3940256099942544/2934735716"
    #endif
    }
}
