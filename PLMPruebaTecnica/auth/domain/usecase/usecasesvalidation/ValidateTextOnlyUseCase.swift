protocol ValidateTextOnlyUseCase {
    func execute(text: String) -> Bool
}

class ValidateTextOnlyUseCaseImpl: ValidateTextOnlyUseCase {
    func execute(text: String) -> Bool {
        return !text.isEmpty && text.allSatisfy { $0.isLetter || $0.isWhitespace }
    }
}
