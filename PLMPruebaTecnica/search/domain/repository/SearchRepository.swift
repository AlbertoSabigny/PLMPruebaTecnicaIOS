import Foundation
import Combine


protocol SearchRepository {
    func getDrugs(code: UserCode, drugName: String) -> AnyPublisher<[Drug], Error>
}
