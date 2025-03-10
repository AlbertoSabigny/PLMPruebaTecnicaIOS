import Foundation

protocol ValidateEmailUseCase {
    func execute(email: String) -> Bool
}

class ValidateEmailUseCaseImpl: ValidateEmailUseCase {
    private let emailMatcher: EmailMatcher
    
    init(emailMatcher: EmailMatcher) {
        self.emailMatcher = emailMatcher
    }
    
    func execute(email: String) -> Bool {
        return !email.isEmpty && emailMatcher.isValid(email: email)
    }
}
