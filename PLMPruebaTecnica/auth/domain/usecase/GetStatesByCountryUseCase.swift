import Foundation
import Combine

protocol GetStatesByCountryUseCase {
    func execute(countryId: Int) -> AnyPublisher<Result<[StateModel]>, Never>
}

class GetStatesByCountryUseCaseImpl: GetStatesByCountryUseCase {
    private let repository: RegistrationRepository
    
    init(repository: RegistrationRepository) {
        self.repository = repository
    }
    
    func execute(countryId: Int) -> AnyPublisher<Result<[StateModel]>, Never> {
        return repository.getStatesByCountry(countryId: countryId)
    }
}
