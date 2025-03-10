import Foundation
import Combine

class RegistrationViewModel: ObservableObject {

    @Published private(set) var state = RegistrationState()
    

    private let getCountriesUseCase: GetCountriesUseCase
    private let getStatesByCountryUseCase: GetStatesByCountryUseCase
    private let getProfessionsUseCase: GetProfessionsUseCase
    private let registerUserUseCase: RegisterUserUseCase
    private let saveUserCodeUseCase: SaveUserCodeUseCase
    private let validationUseCases: RegisterValidationUseCases
    

    private var cancellables = Set<AnyCancellable>()
    

    init(
        getCountriesUseCase: GetCountriesUseCase = DependencyInjection.shared.getCountriesUseCase,
        getStatesByCountryUseCase: GetStatesByCountryUseCase = DependencyInjection.shared.getStatesByCountryUseCase,
        getProfessionsUseCase: GetProfessionsUseCase = DependencyInjection.shared.getProfessionsUseCase,
        registerUserUseCase: RegisterUserUseCase = DependencyInjection.shared.registerUserUseCase,
        saveUserCodeUseCase: SaveUserCodeUseCase = DependencyInjection.shared.saveUserCodeUseCase,
        validationUseCases: RegisterValidationUseCases = DependencyInjection.shared.registrationValidationUseCases
    ) {
        self.getCountriesUseCase = getCountriesUseCase
        self.getStatesByCountryUseCase = getStatesByCountryUseCase
        self.getProfessionsUseCase = getProfessionsUseCase
        self.registerUserUseCase = registerUserUseCase
        self.saveUserCodeUseCase = saveUserCodeUseCase
        self.validationUseCases = validationUseCases
        

        loadInitialData()
    }
    

    func onEvent(_ event: RegistrationEvent) {
        switch event {
        case .emailChanged(let email):
            state.email = email
            state.emailError = nil
            
        case .firstNameChanged(let firstName):
            state.firstName = firstName
            state.firstNameError = nil
            
        case .lastNameChanged(let lastName):
            state.lastName = lastName
            state.lastNameError = nil
            
        case .maternalLastNameChanged(let maternalLastName):
            state.maternalLastName = maternalLastName
            state.maternalLastNameError = nil
            
        case .phoneChanged(let phone):
            state.phone = phone
            state.phoneError = nil
            
        case .professionalLicenseChanged(let license):
            state.professionalLicense = license
            state.professionalLicenseError = nil
            
        case .professionSelected(let profession):
            state.selectedProfession = profession
            state.professionError = nil
            state.isProfessionalLicenseRequired = profession?.requiresLicense ?? false
            
        case .countrySelected(let country):
            print("DEBUG: País seleccionado: \(country?.name ?? "nil")")
            state.selectedCountry = country
            state.countryError = nil
            state.selectedState = nil
            state.states = []
            state.stateError = nil
            
            if let countryId = country?.id {
                print("DEBUG: Iniciando carga de estados para país ID: \(countryId)")
                loadStatesByCountry(countryId: countryId)
            } else {
                print("DEBUG: No se puede cargar estados porque el ID del país es nil")
            }
            
        case .stateSelected(let selectedState):
            state.selectedState = selectedState
            state.stateError = nil
            
        case .submitRegistration:
            registerUser()
            
        case .dismissError:
            state.error = nil
        }
        
      
        objectWillChange.send()
    }
    

    
    private func loadInitialData() {
        loadCountries()
        loadProfessions()
    }
    
    private func loadCountries() {
        state.isLoadingCountries = true
        state.error = nil
        

      
        getCountriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                self.state.isLoadingCountries = false
                
                switch result {
                case .success(let countries):
                    self.state.countries = countries
                case .failure(let error):
                    self.state.error = "Error al cargar países: \(error.localizedDescription)"
                   
                }
                
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func loadStatesByCountry(countryId: Int) {
        state.isLoadingStates = true
        state.error = nil
        
     

    
        getStatesByCountryUseCase.execute(countryId: countryId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                self.state.isLoadingStates = false
                
                switch result {
                case .success(let states):
                    self.state.states = states
                    print("DEBUG: Estados cargados con éxito. Cantidad: \(states.count)")
                    print("DEBUG: Estados: \(states)")
                case .failure(let error):
                    self.state.error = "Error al cargar estados: \(error.localizedDescription)"
                    print("DEBUG: Error al cargar estados: \(error)")
                }
                
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func loadProfessions() {
        state.isLoadingProfessions = true
        state.error = nil
        
        getProfessionsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                self.state.isLoadingProfessions = false
                
                switch result {
                case .success(let professions):
                    self.state.professions = professions
                case .failure(let error):
                    self.state.error = "Error al cargar profesiones: \(error.localizedDescription)"
                }
                
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func registerUser() {
    
        state.emailError = nil
        state.firstNameError = nil
        state.lastNameError = nil
        state.maternalLastNameError = nil
        state.phoneError = nil
        state.professionError = nil
        state.professionalLicenseError = nil
        state.countryError = nil
        state.stateError = nil
        state.error = nil
        
       
        let validationErrors: [String: String?] = [
         
               "emailError": state.email.isEmpty ?
                   "El email es obligatorio" :
                   !validationUseCases.validateEmailUseCase.execute(email: state.email) ?
                   "El email no es válido" : nil,
               
          
               "firstNameError": state.firstName.isEmpty ?
                   "El nombre es obligatorio" :
                   !validationUseCases.validateTextOnlyUseCase.execute(text: state.firstName) ?
                   "El nombre solo debe contener letras" : nil,
               
     
               "lastNameError": state.lastName.isEmpty ?
                   "El apellido paterno es obligatorio" :
                   !validationUseCases.validateTextOnlyUseCase.execute(text: state.lastName) ?
                   "El apellido paterno solo debe contener letras" : nil,
               
              
               "maternalLastNameError": state.maternalLastName.isEmpty ?
                   "El apellido materno es obligatorio" :
                   !validationUseCases.validateTextOnlyUseCase.execute(text: state.maternalLastName) ?
                   "El apellido materno solo debe contener letras" : nil,
               
              
               "phoneError": state.phone.isEmpty ?
                   "El teléfono es obligatorio" :
                   !validationUseCases.validatePhoneUseCase.execute(phone: state.phone) ?
                   "El teléfono debe ser numérico y máximo 10 dígitos" : nil,
               
        
               "professionError": state.selectedProfession == nil ?
                   "Selecciona una profesión" :
                   !validationUseCases.validateProfessionUseCase.execute(
                       professionId: state.selectedProfession?.id ?? -1,
                       availableProfessions: state.professions) ?
                   "Selecciona una profesión válida" : nil,
               
            
               "professionalLicenseError": state.isProfessionalLicenseRequired ?
                   (state.professionalLicense.isEmpty ?
                       "La cédula profesional es obligatoria" :
                       !validationUseCases.validateProfessionalIdUseCase.execute(
                           professionalId: state.professionalLicense,
                           isRequired: state.isProfessionalLicenseRequired) ?
                       "La cédula debe ser alfanumérica y máximo 10 caracteres" : nil) : nil,
               
             
               "countryError": state.selectedCountry == nil ?
                   "Selecciona un país" :
                   !validationUseCases.validateCountryUseCase.execute(
                       countryId: state.selectedCountry?.id ?? -1,
                       availableCountries: state.countries) ?
                   "Selecciona un país válido" : nil,
               
      
               "stateError": !state.states.isEmpty ?
                   (state.selectedState == nil ?
                       "Selecciona un estado" :
                       !validationUseCases.validateStateUseCase.execute(
                           stateShortName: state.selectedState?.shortName ?? "",
                           availableStates: state.states) ?
                       "Selecciona un estado válido" : nil) : nil
           ]
        

        state.emailError = validationErrors["emailError"] ?? nil
        state.firstNameError = validationErrors["firstNameError"] ?? nil
        state.lastNameError = validationErrors["lastNameError"] ?? nil
        state.maternalLastNameError = validationErrors["maternalLastNameError"] ?? nil
        state.phoneError = validationErrors["phoneError"] ?? nil
        state.professionError = validationErrors["professionError"] ?? nil
        state.professionalLicenseError = validationErrors["professionalLicenseError"] ?? nil
        state.countryError = validationErrors["countryError"] ?? nil
        state.stateError = validationErrors["stateError"] ?? nil
        
  
        let allFieldsValid = validationErrors.values.allSatisfy { $0 == nil }
        
        if allFieldsValid {
            state.isSubmitting = true
            
        
            let userInfo = UserRegistrationInfo(
                email: state.email,
                firstName: state.firstName,
                lastName: state.lastName,
                maternalLastName: state.maternalLastName.isEmpty ? nil : state.maternalLastName,
                phone: state.phone.isEmpty ? nil : state.phone,
                profession: state.selectedProfession?.id ?? -1,
                professionalLicense: state.professionalLicense.isEmpty ? nil : state.professionalLicense,
                stateShortName: state.selectedState?.shortName ?? ""
            )
            
 
            registerUserUseCase.execute(userInfo: userInfo)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    guard let self = self else { return }
                    
                    self.state.isSubmitting = false
                    
                    switch result {
                    case .success(let userCode):
                   
                        self.saveUserCodeUseCase.execute(userCode: userCode)
                        
                       
                        self.state.userCode = userCode
                        self.state.registrationCompleted = true
                        
                    case .failure(let error):
                        self.state.error = "Error en el registro: \(error.localizedDescription)"
                    }
                    
                    self.objectWillChange.send()
                }
                .store(in: &cancellables)
        } else {
            objectWillChange.send()
        }
    }
}
