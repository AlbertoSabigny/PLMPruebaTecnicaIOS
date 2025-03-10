import Foundation
import Combine


protocol GetDrugsUseCase {
    func execute(code: UserCode, drugName: String) -> AnyPublisher<[Drug], Error>
}


class GetDrugsUseCaseImpl: GetDrugsUseCase {
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func execute(code: UserCode, drugName: String) -> AnyPublisher<[Drug], Error> {
     
        return searchRepository.getDrugs(code: code, drugName: drugName)
    }
}
