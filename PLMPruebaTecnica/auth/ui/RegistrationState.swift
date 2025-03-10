import Foundation

struct RegistrationState {

    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var maternalLastName: String = ""
    var phone: String = ""
    var professionalLicense: String = ""
    

    var selectedProfession: Profession? = nil
    var selectedCountry: Country? = nil
    var selectedState: StateModel? = nil
    
  
    var countries: [Country] = []
    var states: [StateModel] = []
    var professions: [Profession] = []
    
    
    var emailError: String? = nil
    var firstNameError: String? = nil
    var lastNameError: String? = nil
    var maternalLastNameError: String? = nil
    var phoneError: String? = nil
    var professionError: String? = nil
    var professionalLicenseError: String? = nil
    var countryError: String? = nil
    var stateError: String? = nil
    
  
    var isLoadingCountries: Bool = false
    var isLoadingStates: Bool = false
    var isLoadingProfessions: Bool = false
    var isSubmitting: Bool = false
    
    var isProfessionalLicenseRequired: Bool = false
    
  
    var registrationCompleted: Bool = false
    var userCode: UserCode? = nil
    var error: String? = nil
    
   
    var isFormValid: Bool {
        return !email.isEmpty &&
               !firstName.isEmpty &&
               !lastName.isEmpty &&
               selectedCountry != nil &&
               selectedState != nil &&
               selectedProfession != nil &&
               (!isProfessionalLicenseRequired || !professionalLicense.isEmpty) &&
               emailError == nil &&
               firstNameError == nil &&
               lastNameError == nil &&
               phoneError == nil &&
               professionError == nil &&
               professionalLicenseError == nil &&
               countryError == nil &&
               stateError == nil
    }
}
