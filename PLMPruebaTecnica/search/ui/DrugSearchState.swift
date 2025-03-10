import Foundation


enum DrugSearchState {
    case idle
    case loading
    case success(drugs: [Drug])
    case empty
    case serverUnavailable
    case error(message: String? = nil)     
}
