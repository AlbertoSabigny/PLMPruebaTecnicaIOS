import Foundation

class DependencyInjection {
    static let shared = DependencyInjection()
    
    private let baseURL = URL(string: "https://dev.plmconnection.com/plmservices/RestPLMClientsEngine/RestPLMClientsEngine.svc/")!
    
    // MARK: - API Service
    
    lazy var registrationApiService: RegistrationApiService = {
        return RegistrationApiServiceImpl(baseURL: baseURL)
    }()
    
    lazy var drugApiService: DrugApiService = {
            let drugApiBaseURL = URL(string: "https://dev.plmconnection.com/plmservices/RestPLMPharmaSearchEngine/RestPharmaSearchEngine.svc/")!
            return DrugApiServiceImpl(baseURL: drugApiBaseURL)
        }()
      
    // MARK: - Repositories
    
    lazy var registrationRepository: RegistrationRepository = {
        return RegistrationRepositoryImpl(apiService: registrationApiService)
    }()
    lazy var searchRepository: SearchRepository = {
           return SearchRepositoryImpl(apiService: drugApiService)
       }()
    // MARK: - Session Manager
    
    lazy var userSessionManager: UserSessionManager = {
        return UserSessionManagerImpl()
    }()
    
    // MARK: - Registration Use Cases
    
    lazy var getCountriesUseCase: GetCountriesUseCase = {
        return GetCountriesUseCaseImpl(repository: registrationRepository)
    }()
    
    lazy var getProfessionsUseCase: GetProfessionsUseCase = {
        return GetProfessionsUseCaseImpl(repository: registrationRepository)
    }()
    
    lazy var getStatesByCountryUseCase: GetStatesByCountryUseCase = {
        return GetStatesByCountryUseCaseImpl(repository: registrationRepository)
    }()
    
    lazy var registerUserUseCase: RegisterUserUseCase = {
        return RegisterUserUseCaseImpl(repository: registrationRepository)
    }()
    
    // MARK: - User Session Use Cases
    
    lazy var saveUserCodeUseCase: SaveUserCodeUseCase = {
        return SaveUserCodeUseCaseImpl(userSessionManager: userSessionManager)
    }()
    
    lazy var getUserCodeUseCase: GetUserCodeUseCase = {
        return GetUserCodeUseCaseImpl(userSessionManager: userSessionManager)
    }()
    
    lazy var isUserLoggedInUseCase: IsUserLoggedInUseCase = {
        return IsUserLoggedInUseCaseImpl(userSessionManager: userSessionManager)
    }()
    
    // MARK: - Validation Dependencies
    
    lazy var emailMatcher: EmailMatcher = {
        return EmailMatcherImpl()
    }()
    
    // MARK: - Validation Use Cases
    
    lazy var validateEmailUseCase: ValidateEmailUseCase = {
        return ValidateEmailUseCaseImpl(emailMatcher: emailMatcher)
    }()
    
    lazy var validateTextOnlyUseCase: ValidateTextOnlyUseCase = {
        return ValidateTextOnlyUseCaseImpl()
    }()
    
    lazy var validatePhoneUseCase: ValidatePhoneUseCase = {
        return ValidatePhoneUseCaseImpl()
    }()
    
    lazy var validateProfessionUseCase: ValidateProfessionUseCase = {
        return ValidateProfessionUseCaseImpl()
    }()
    
    lazy var validateProfessionalIdUseCase: ValidateProfessionalIdUseCase = {
        return ValidateProfessionalIdUseCaseImpl()
    }()
    
    lazy var validateCountryUseCase: ValidateCountryUseCase = {
        return ValidateCountryUseCaseImpl()
    }()
    
    lazy var validateStateUseCase: ValidateStateUseCase = {
        return ValidateStateUseCaseImpl()
    }()
    lazy var getDrugsUseCase: GetDrugsUseCase = {
           return GetDrugsUseCaseImpl(searchRepository: searchRepository)
       }()
       
      
    // MARK: - Agrupación de Validation Use Cases
    
    lazy var registrationValidationUseCases: RegisterValidationUseCases = {
        return RegisterValidationUseCases(
            validateEmailUseCase: validateEmailUseCase,
            validateTextOnlyUseCase: validateTextOnlyUseCase,
            validatePhoneUseCase: validatePhoneUseCase,
            validateProfessionUseCase: validateProfessionUseCase,
            validateProfessionalIdUseCase: validateProfessionalIdUseCase,
            validateCountryUseCase: validateCountryUseCase,
            validateStateUseCase: validateStateUseCase
        )
    }()
    
    private init() {}
}
