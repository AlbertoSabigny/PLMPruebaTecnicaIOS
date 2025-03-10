protocol ValidatePhoneUseCase {
    func execute(phone: String) -> Bool
}

class ValidatePhoneUseCaseImpl: ValidatePhoneUseCase {
    func execute(phone: String) -> Bool {
        return !phone.isEmpty && phone.allSatisfy { $0.isNumber } && phone.count <= 10
    }
}
