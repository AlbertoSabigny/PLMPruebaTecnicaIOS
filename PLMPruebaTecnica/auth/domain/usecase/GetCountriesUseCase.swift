import Foundation
import Combine

protocol GetCountriesUseCase {
    func execute() -> AnyPublisher<Result<[Country]>, Never>
}

class GetCountriesUseCaseImpl: GetCountriesUseCase {
    private let repository: RegistrationRepository
    
    init(repository: RegistrationRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<Result<[Country]>, Never> {
        return repository.getCountries()
    }
}
