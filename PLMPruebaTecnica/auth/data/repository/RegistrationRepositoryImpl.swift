import Foundation
import Combine

class RegistrationRepositoryImpl: RegistrationRepository {
    private let apiService: RegistrationApiService
    
    init(apiService: RegistrationApiService) {
        self.apiService = apiService
    }
    
    func getCountries() -> AnyPublisher<Result<[Country]>, Never> {
        return apiService.getCountries()
            .map { response -> Result<[Country]> in
                let countries = response.getCountriesResult.compactMap { $0.toDomain() }
                return .success(countries)
            }
            .catch { error -> AnyPublisher<Result<[Country]>, Never> in
                let result: Result<[Country]> = .failure(self.mapError(error))
                return Just(result).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getStatesByCountry(countryId: Int) -> AnyPublisher<Result<[StateModel]>, Never> {
        return apiService.getStatesByCountry(countryId: countryId)
            .map { response -> Result<[StateModel]> in
                let states = response.getStateByCountryResult.compactMap { $0.toDomain() }
                return .success(states)
            }
            .catch { error -> AnyPublisher<Result<[StateModel]>, Never> in
                let result: Result<[StateModel]> = .failure(self.mapError(error))
                return Just(result).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getProfessions() -> AnyPublisher<Result<[Profession]>, Never> {
        return apiService.getProfessions()
            .map { response -> Result<[Profession]> in
                let professions = response.getProfessionsResult.compactMap { $0.toDomain() }
                return .success(professions)
            }
            .catch { error -> AnyPublisher<Result<[Profession]>, Never> in
                let result: Result<[Profession]> = .failure(self.mapError(error))
                return Just(result).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func registerUser(userInfo: UserRegistrationInfo) -> AnyPublisher<Result<UserCode>, Never> {
        // Convertir UserRegistrationInfo a UserRegistrationRequest
        let request = UserRegistrationRequest(
            email: userInfo.email,
            firstName: userInfo.firstName,
            lastName: userInfo.lastName,
            phone: userInfo.phone,
            profession: userInfo.profession,
            professionLicense: userInfo.professionalLicense,
            slastName: userInfo.maternalLastName,
            state: userInfo.stateShortName
        )
        
        return apiService.registerUser(userData: request)
            .map { response -> Result<UserCode> in
                let userCode = response.toDomain()
                return .success(userCode)
            }
            .catch { error -> AnyPublisher<Result<UserCode>, Never> in
                let result: Result<UserCode> = .failure(self.mapError(error))
                return Just(result).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func mapError(_ error: Error) -> Error {
        // Aquí puedes mapear errores específicos de red o decodificación a tus propios tipos de error de dominio
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return RegistrationError.networkError
            default:
                return RegistrationError.serverError
            }
        } else if error is DecodingError {
            return RegistrationError.validationError(message: "Error al procesar la respuesta del servidor")
        }
        
        return RegistrationError.unknownError
    }
}
