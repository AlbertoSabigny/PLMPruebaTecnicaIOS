protocol IsUserLoggedInUseCase {
    func execute() -> Bool
}

class IsUserLoggedInUseCaseImpl: IsUserLoggedInUseCase {
    private let userSessionManager: UserSessionManager
    
    init(userSessionManager: UserSessionManager) {
        self.userSessionManager = userSessionManager
    }
    
    func execute() -> Bool {
        return userSessionManager.isUserLoggedIn()
    }
}
