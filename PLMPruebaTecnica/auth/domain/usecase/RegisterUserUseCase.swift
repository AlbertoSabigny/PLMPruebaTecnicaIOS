import Foundation
import Combine

protocol RegisterUserUseCase {
    func execute(userInfo: UserRegistrationInfo) -> AnyPublisher<Result<UserCode>, Never>
}

class RegisterUserUseCaseImpl: RegisterUserUseCase {
    private let repository: RegistrationRepository
    
    init(repository: RegistrationRepository) {
        self.repository = repository
    }
    
    func execute(userInfo: UserRegistrationInfo) -> AnyPublisher<Result<UserCode>, Never> {
        return repository.registerUser(userInfo: userInfo)
    }
}
