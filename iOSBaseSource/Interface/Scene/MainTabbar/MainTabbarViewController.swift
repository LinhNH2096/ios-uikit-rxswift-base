import UIKit
import GoogleMobileAds
import UserMessagingPlatform
import AdSupport
import SwiftEventBus

enum AppTabbarItem: Int, CaseIterable {
    case tab1 = 0
    case tab2
    case tab3
    case tab4

    var tabIndex: Int {
        return rawValue
    }

    var titleItem: String {
        switch self {
        case .tab1:
            return "Tab 1"
        case .tab2:
            return "Tab 2"
        case .tab3:
            return "Tab 3"
        case .tab4:
            return "Tab 4"
        }
    }

    var icon: UIImage? {
        switch self {
        case .tab1:
            return UIImage(named: "ic_tabbar1")
        case .tab2:
            return UIImage(named: "ic_tabbar2")
        case .tab3:
            return UIImage(named: "ic_tabbar3")
        case .tab4:
            return UIImage(named: "ic_tabbar4")
        }
    }

    var viewController: UIViewController {
        switch self {
        case .tab1:
            let remoteVC = BaseViewController()
            remoteVC.isTabViewController = true
            return remoteVC
        case .tab2:
            let controlVC = BaseViewController()
            controlVC.isTabViewController = true
            return controlVC
        case .tab3:
            let mirroringVC = BaseViewController()
            mirroringVC.isTabViewController = true
            return mirroringVC
        case .tab4:
            let settingsVC = BaseViewController()
            settingsVC.isTabViewController = true
            return settingsVC
        }
    }
}

class MainTabbarViewController: UITabBarController {

    private let selectedColor: UIColor = AppColor.selected ?? .blue
    private let normalColor: UIColor = .white
    private let itemImageSize: CGSize = CGSize(width: 24, height: 24)
    private var isMobileAdsStartCalled = false

    private let adsContainView = AdsBannerView()

    override func viewDidLoad() {
        super.viewDidLoad()


        self.setup()
        self.createTabbar()
        self.handleSwiftEventBus()

        //ServiceFacade.applicationService.appConfig.adsInfo.isAllowedAds
        self.checkUMPConsentInformation()
        self.setupAdsView()
    }

    private func setup() {
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.tintColor = selectedColor
        self.tabBar.unselectedItemTintColor = normalColor
    }

    private func createTabbar() {
        let tabbarViewControllers: [UIViewController] = AppTabbarItem.allCases.map { item -> UIViewController in
            let tabbarIcon = item.icon?.resize(to: itemImageSize)?.withRenderingMode(.alwaysOriginal)
            let tabbarItem = UITabBarItem(title: item.titleItem,
                                          image: tabbarIcon?.withTintColor(normalColor),
                                          selectedImage: tabbarIcon?.withTintColor(selectedColor))
            let viewController = item.viewController
            viewController.tabBarItem = tabbarItem
            return viewController
        }
        self.viewControllers = tabbarViewControllers
        self.tabBar.backgroundColor = AppColor.appBackground
    }

    private func setupAdsView() {
        self.view.addSubview(adsContainView)
        self.adsContainView.translatesAutoresizingMaskIntoConstraints = false
        self.adsContainView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            self.adsContainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.adsContainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.adsContainView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            self.adsContainView.heightAnchor.constraint(equalToConstant: Constant.tabbarAdsBannerHeight)
        ])
        self.adsContainView.setupAdsBannerView(rootViewController: self)
    }

    private func handleSwiftEventBus() {
        //        SwiftEventBus.onMainThread(self, name: NotificationEventBus.noteNotification) { [weak self] notification in
        //            guard let noteId = notification?.object as? String else { return }
        //            self?.handleOpenNote(noteId: noteId)
        //        }
    }
}

// MARK: Ads
extension MainTabbarViewController: GADBannerViewDelegate {

    private func checkUMPConsentInformation() {
        /* print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)") // Need requestTrackingAuthorization from ATTrackingManager
         /**
          <key>NSUserTrackingUsageDescription</key>
          <string>This identifier will be used to deliver personalized ads to you.</string>
          */ */

        /* // Debug mode parameter for function requestConsentInfoUpdate below
         let parameters = UMPRequestParameters()
         let debugSettings = UMPDebugSettings()
         debugSettings.testDeviceIdentifiers = ["25A3E698-FDF9-438D-AECA-0DF913DA70FA"]
         debugSettings.geography = .EEA
         parameters.debugSettings = debugSettings
         UMPConsentInformation.sharedInstance.reset() // Line for always show UMP when open app*/

        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: nil) {
            [weak self] requestConsentError in
            guard let self else { return }
            if let consentError = requestConsentError {
                return print("Error: \(consentError.localizedDescription)")
            }
            UMPConsentForm.loadAndPresentIfRequired(from: self) {
                [weak self] loadAndPresentError in
                guard let self else { return }
                if let consentError = loadAndPresentError {
                    return print("Error: \(consentError.localizedDescription)")
                }
                self.startGoogleMobileAdsSDK()
            }
        }
        self.startGoogleMobileAdsSDK()
    }

    private func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled, UMPConsentInformation.sharedInstance.canRequestAds else { return }
            self.isMobileAdsStartCalled = true
            GADMobileAds.sharedInstance().start()
        }
    }
}
