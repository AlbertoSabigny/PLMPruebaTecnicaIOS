import SwiftUI

enum TabItem: String, Identifiable {
    case search, developer
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .search: return "Búsqueda"
        case .developer: return "Desarrollador"
        }
    }
    
    var icon: String {
        switch self {
        case .search: return "magnifyingglass"
        case .developer: return "hammer.fill"
        }
    }
}
