import Foundation
import UIKit

struct ShareManager {
    private init() {}

    static var shared: ShareManager = ShareManager()

    func shareImageAndText(images: [UIImage], text: String = "AI Painter", viewController: UIViewController, completionHandler: ((Bool) -> Void)? = nil) {
        let items: [Any] = images + [text]

        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)

        activityViewController.completionWithItemsHandler = { _, completed, _, _ in
            completionHandler?(completed)
        }

        activityViewController.excludedActivityTypes = [
            .postToFacebook,
            .postToTwitter,
            .postToWeibo,
            .print,
            .copyToPasteboard,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .airDrop,
            .openInIBooks
        ]
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
