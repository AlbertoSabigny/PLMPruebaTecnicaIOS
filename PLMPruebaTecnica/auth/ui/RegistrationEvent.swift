enum RegistrationEvent {
    case emailChanged(String)
    case firstNameChanged(String)
    case lastNameChanged(String)
    case maternalLastNameChanged(String)
    case phoneChanged(String)
    case professionalLicenseChanged(String)
    case professionSelected(Profession?)
    case countrySelected(Country?)
    case stateSelected(StateModel?)
    case submitRegistration
    case dismissError
}
