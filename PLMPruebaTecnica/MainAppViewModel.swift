import Foundation
import Combine

class MainAppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    private let sessionManager: UserSessionManager
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionManager: UserSessionManager = UserSessionManagerImpl()) {
        self.sessionManager = sessionManager
        checkUserSession()
    }
    
    func checkUserSession() {
     
        isLoggedIn = sessionManager.isUserLoggedIn()
    }
    
    func logout() {
        sessionManager.clearSession()
        isLoggedIn = false
    }
}
