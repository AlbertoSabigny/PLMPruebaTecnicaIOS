protocol ValidateProfessionalIdUseCase {
    func execute(professionalId: String, isRequired: Bool) -> Bool
}

class ValidateProfessionalIdUseCaseImpl: ValidateProfessionalIdUseCase {
    func execute(professionalId: String, isRequired: Bool) -> Bool {
        if isRequired {
            return !professionalId.isEmpty && professionalId.count <= 10 && professionalId.allSatisfy { $0.isLetter || $0.isNumber }
        } else {
            return professionalId.isEmpty || (professionalId.count <= 10 && professionalId.allSatisfy { $0.isLetter || $0.isNumber })
        }
    }
}
