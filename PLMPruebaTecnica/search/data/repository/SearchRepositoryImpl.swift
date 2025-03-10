import Foundation
import Combine


class SearchRepositoryImpl: SearchRepository {
    private let apiService: DrugApiService
    
    init(apiService: DrugApiService) {
        self.apiService = apiService
    }
    
    func getDrugs(code: UserCode, drugName: String) -> AnyPublisher<[Drug], Error> {
        return apiService.getDrugs(
            code: code,
            countryId: "MEX",
            editionId: 211,
            drug: drugName,
            searchAddressIP: nil,
            searchLatitude: nil,
            searchLongitude: nil
        )
        .map { responses -> [Drug] in
        
            return responses.toDomain()
        }
        .eraseToAnyPublisher()
    }
}
