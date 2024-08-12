import UIKit
import GoogleMobileAds

class AdsBannerView: BaseView {
    @IBOutlet private weak var bannerView: GADBannerView!

    override func nibSetup() {
        super.nibSetup()

        self.setupAndBinding()
    }

    private func setupAndBinding() { }

    func setupAdsBannerView(rootViewController: UIViewController) {
        bannerView.adUnitID = AppBannerAds.testBanner.unitId
        bannerView.rootViewController = rootViewController
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
}

// MARK: Ads
extension AdsBannerView: GADBannerViewDelegate {

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
//        guard ServiceFacade.applicationService.appConfig.adsInfo.isAllowedAds else {
//            return
//        }
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.bannerView.alpha = 1
        })
    }
}
