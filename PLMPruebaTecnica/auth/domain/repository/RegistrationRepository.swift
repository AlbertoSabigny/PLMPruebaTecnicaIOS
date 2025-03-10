import Combine

protocol RegistrationRepository {
    func getCountries() -> AnyPublisher<Result<[Country]>, Never>
    func getStatesByCountry(countryId: Int) -> AnyPublisher<Result<[StateModel]>, Never>
    func getProfessions() -> AnyPublisher<Result<[Profession]>, Never>
    func registerUser(userInfo: UserRegistrationInfo) -> AnyPublisher<Result<UserCode>, Never>
}
