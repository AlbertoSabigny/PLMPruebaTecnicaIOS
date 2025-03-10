import Foundation

protocol UserSessionManager {
    func saveUserCode(_ userCode: UserCode)
    func getUserCode() -> UserCode?
    func isUserLoggedIn() -> Bool
    func clearSession()
}

class UserSessionManagerImpl: UserSessionManager {
    private let userDefaults: UserDefaults
    

    private enum Keys {
        static let userCodeKey = "user_code"
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveUserCode(_ userCode: UserCode) {
        userDefaults.set(userCode.id, forKey: Keys.userCodeKey)
    }
    
    func getUserCode() -> UserCode? {
        guard let codeString = userDefaults.string(forKey: Keys.userCodeKey) else {
            return nil
        }
        
        return UserCode(id: codeString)
    }
    
    func isUserLoggedIn() -> Bool {
        return userDefaults.string(forKey: Keys.userCodeKey) != nil
    }
    
    func clearSession() {
        userDefaults.removeObject(forKey: Keys.userCodeKey)
    }
}
