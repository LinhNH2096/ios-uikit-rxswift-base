import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {

//    @IBOutlet private weak var topMessageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    private func setupUI() {
        self.updateNavigationBar(title: language.getText(ofKey: "HOME_NAV_TITLE"),
                                 leftType: .refresh,
                                 rightType: .close)

    }

}
