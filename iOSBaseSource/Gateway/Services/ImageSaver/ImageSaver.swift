import Foundation
import UIKit
import Photos

struct ImageSaver {
    private init() {}
    static var shared: ImageSaver = ImageSaver()

    func saveImageToLibrary(_ images: [UIImage], completion: @escaping (Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.saveImages(images, completion: completion)
                } else {
                    self.showPermissionDeniedAlert()
                }
            }
        }
    }

    private func saveImages(_ images: [UIImage], completion: @escaping (Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges {
            images.forEach { image in
                if let imageData = image.pngData() {
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.creationDate = Date()
                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
                }
            }
        } completionHandler: { success, error in
            if success {
                completion(nil)
            } else if let error = error {
                completion(error)
            }
        }
    }

    private func showPermissionDeniedAlert() {
        let alertController = UIAlertController(
            title: "Photo Library Access Denied",
            message: "To save images, please allow access to the photo library in Settings.",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present the alert
        guard let topViewController = UIApplication.topViewController() else {
            return
        }

        topViewController.present(alertController, animated: true, completion: nil)
    }
}
