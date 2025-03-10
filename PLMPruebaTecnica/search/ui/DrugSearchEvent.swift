import Foundation


enum DrugSearchEvent {

    case searchQueryChanged(String)
    case codeSelected(String)
    
  
    case search
    case clearSearch
    case retrySearch
    
  
    case dismissError
}
