import UIKit

class ProgressBarView: UIView {
    private var gradientLayer: CAGradientLayer!

    var progress: CGFloat = 0.0 {
        didSet {
            updateProgressBar()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressBar()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProgressBar()
    }

    private func setupProgressBar() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "0A8BFF").cgColor, UIColor(hex: "7799FF").cgColor, UIColor(hex: "E3A6FF").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.addSublayer(gradientLayer)
        layer.cornerRadius = bounds.height / 2.0
        updateProgressBar()
    }

    private func updateProgressBar() {
        let progressWidth = bounds.width * progress
        gradientLayer.frame = CGRect(x: 0, y: 0, width: progressWidth, height: bounds.height)
    }
}
