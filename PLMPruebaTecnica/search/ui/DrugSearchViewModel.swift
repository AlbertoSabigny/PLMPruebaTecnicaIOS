import Foundation
import Combine

class DrugSearchViewModel: ObservableObject {

    @Published private(set) var state: DrugSearchState = .idle
    

    @Published private(set) var searchQuery: String = ""
    

    private let getDrugsUseCase: GetDrugsUseCase
    private let getUserCodeUseCase: GetUserCodeUseCase
    

    private var userCode: UserCode? = nil
    
    
    private var cancellables = Set<AnyCancellable>()
    
   
    init(
        getDrugsUseCase: GetDrugsUseCase = DependencyInjection.shared.getDrugsUseCase,
        getUserCodeUseCase: GetUserCodeUseCase = DependencyInjection.shared.getUserCodeUseCase
    ) {
        self.getDrugsUseCase = getDrugsUseCase
        self.getUserCodeUseCase = getUserCodeUseCase
        
      
        loadUserCode()
    }
    
 
    func onEvent(_ event: DrugSearchEvent) {
        switch event {
        case .searchQueryChanged(let query):
            searchQuery = query
            
        case .search:
            searchDrugs()
            
        case .clearSearch:
            searchQuery = ""
            state = .idle
            
        case .retrySearch:
            if !searchQuery.isEmpty {
                searchDrugs()
            }
            
        case .dismissError:
            state = .idle
            
        case .codeSelected:
         
            break
        }
    }
    
    
    private func loadUserCode() {
        
        if let userCode = getUserCodeUseCase.execute() {
            self.userCode = userCode
        } else {
            print("No se pudo obtener el código de usuario")
        }
    }
    
    private func searchDrugs() {
     
        guard let userCode = userCode, !searchQuery.trim().isEmpty else {
            return
        }
        
     
        state = .loading
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
          
            self.getDrugsUseCase.execute(code: userCode, drugName: self.searchQuery.trim())
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard let self = self else { return }
                        
                        if case .failure(let error) = completion {
                            print("Error al buscar medicamentos: \(error.localizedDescription)")
                            
                         
                            
                            if let urlError = error as? URLError {
                                if urlError.code == .cannotConnectToHost ||
                                   urlError.code == .networkConnectionLost ||
                                   urlError.code == .notConnectedToInternet ||
                                   urlError.code == .timedOut {
                                    self.state = .serverUnavailable
                                } else {
                                    self.state = .error(message: error.localizedDescription)
                                }
                            } else {
                               
                                self.state = .error(message: error.localizedDescription)
                            }
                        }
                    },
                    receiveValue: { [weak self] drugs in
                        guard let self = self else { return }
                        
                        if drugs.isEmpty {
                            self.state = .empty
                        } else {
                            self.state = .success(drugs: drugs)
                        }
                        
                        print("Resultados obtenidos: \(drugs.count) medicamentos")
                    }
                )
                .store(in: &self.cancellables)
        }
    }
}


extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
