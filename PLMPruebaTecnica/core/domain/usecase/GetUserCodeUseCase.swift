protocol GetUserCodeUseCase {
    func execute() -> UserCode?
}

class GetUserCodeUseCaseImpl: GetUserCodeUseCase {
    private let userSessionManager: UserSessionManager
    
    init(userSessionManager: UserSessionManager) {
        self.userSessionManager = userSessionManager
    }
    
    func execute() -> UserCode? {
        return userSessionManager.getUserCode()
    }
}
