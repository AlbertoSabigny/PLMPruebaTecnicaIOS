// Errores específicos del dominio de registro
enum RegistrationError: Error {
    case serverError
    case networkError
    case validationError(message: String)
    case unknownError
}
