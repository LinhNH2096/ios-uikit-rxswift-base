import UIKit
import Lottie

class LoadingIndicatorView: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private weak var massageLabel: UILabel!
    @IBOutlet private weak var animationView: LottieAnimationView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now()+0.33) {
            self.animationView.loopMode = .loop
            self.animationView.play()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        self.massageLabel.text = "We prepare the image, it will not take much time"
    }

    func hide() {
        self.dismiss(animated: false)
    }
}
