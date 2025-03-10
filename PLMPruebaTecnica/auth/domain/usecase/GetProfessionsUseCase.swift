import Foundation
import Combine

protocol GetProfessionsUseCase {
    func execute() -> AnyPublisher<Result<[Profession]>, Never>
}

class GetProfessionsUseCaseImpl: GetProfessionsUseCase {
    private let repository: RegistrationRepository
    
    init(repository: RegistrationRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<Result<[Profession]>, Never> {
        return repository.getProfessions()
    }
}
