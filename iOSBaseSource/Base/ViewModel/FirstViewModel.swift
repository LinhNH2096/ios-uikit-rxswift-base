import Foundation
import RxSwift
import RxCocoa

class FirstViewModel {
    private let authUseCase: AuthenUseCaseable!
    var disposeBag = DisposeBag()
    typealias Info = (username: String, password: String)
    init(useCase: AuthenUseCaseable = AuthenUsecaseImplement()) {
        self.authUseCase = useCase
    }
    func transform(input: Input) -> Output {
        let isValidate = input.info.map({ !$0.username.isEmpty && !$0.password.isEmpty })
        let isLogged = login(info: input.info,
                             submit: input.submit)
        isLogged
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] user in
              guard let self = self else { return }
//              self.push(to: SecondViewController.self, prepare: { (vc) in
//                vc.viewModel.onDidReceive(data: user)
//              })
            }).disposed(by: disposeBag)
        return Output(isValidate: isValidate)
    }
    
    private func login(info: Driver<Info>, submit: Driver<()>) -> PublishSubject<User?> {
        let complete = PublishSubject<User?>()
        submit
            .withLatestFrom(info)
            .asObservable()
            .flatMapLatest { [unowned self] (info) in
                self.authUseCase
                    .login(phone: info.username, password: info.password)
        }.subscribe(onNext: { (user) in
            complete.onNext(user)
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
        return complete
    }
}
extension FirstViewModel: ViewModelTransformable {
  struct Input {
    let info: Driver<Info>
    let submit: Driver<()>
  }
  struct Output {
    let isValidate: Driver<Bool>
  }
}
