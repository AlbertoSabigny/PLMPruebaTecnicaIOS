import Foundation
import Combine

protocol SaveUserCodeUseCase {
    func execute(userCode: UserCode)
}

class SaveUserCodeUseCaseImpl: SaveUserCodeUseCase {
    private let userSessionManager: UserSessionManager
    
    init(userSessionManager: UserSessionManager) {
        self.userSessionManager = userSessionManager
    }
    
    func execute(userCode: UserCode) {
        userSessionManager.saveUserCode(userCode)
    }
}
