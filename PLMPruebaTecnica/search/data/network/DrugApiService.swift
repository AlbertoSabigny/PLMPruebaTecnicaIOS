import Foundation
import Combine


protocol DrugApiService {
    func getDrugs(
        code: UserCode,
        countryId: String,
        editionId: Int,
        drug: String,
        searchAddressIP: String?,
        searchLatitude: String?,
        searchLongitude: String?
    ) -> AnyPublisher<[DrugResponse], Error>
}


class DrugApiServiceImpl: DrugApiService {

    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL = URL(string: "https://dev.plmconnection.com/plmservices/RestPLMPharmaSearchEngine/RestPharmaSearchEngine.svc/")!, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    
    func getDrugs(
        code: UserCode,
        countryId: String,
        editionId: Int,
        drug: String,
        searchAddressIP: String? = "",
        searchLatitude: String? = "",
        searchLongitude: String? = ""
    ) -> AnyPublisher<[DrugResponse], Error> {
        
     
        let endpoint = baseURL.appendingPathComponent("GetDrugs")
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
        
        components.queryItems = [
            URLQueryItem(name: "code", value: code.id),
            URLQueryItem(name: "countryId", value: countryId),
            URLQueryItem(name: "editionId", value: String(editionId)),
            URLQueryItem(name: "drug", value: drug)
        ]
        
    
        if let searchAddressIP = searchAddressIP, !searchAddressIP.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "searchAddressIP", value: searchAddressIP))
        }
        
        if let searchLatitude = searchLatitude, !searchLatitude.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "searchLatitude", value: searchLatitude))
        }
        
        if let searchLongitude = searchLongitude, !searchLongitude.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "searchLongitude", value: searchLongitude))
        }
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
     
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print("Request URL: \(url)")
        
        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { output in
           
                if let httpResponse = output.response as? HTTPURLResponse {
                    print("Código de respuesta HTTP: \(httpResponse.statusCode)")
                    print("Encabezados de respuesta: \(httpResponse.allHeaderFields)")
                }
                
              
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("Respuesta recibida: \(jsonString.prefix(500))")
                }
            })
            .tryMap { output -> Data in
                
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
              
                guard (200...299).contains(httpResponse.statusCode) else {
                    if httpResponse.statusCode == 503 {
                        throw URLError(.cannotConnectToHost)
                    } else if httpResponse.statusCode == 404 {
                       
                        let customError = NSError(
                            domain: URLError.errorDomain,
                            code: URLError.resourceUnavailable.rawValue,
                            userInfo: [NSLocalizedDescriptionKey: "Endpoint no encontrado. Verifica la URL del API."]
                        )
                        throw customError
                    } else {
                        throw URLError(.badServerResponse)
                    }
                }
                
               
                let dataString = String(data: output.data, encoding: .utf8) ?? ""
                if dataString.hasPrefix("<?xml") || dataString.hasPrefix("<html") {
                    print("Recibido HTML/XML en lugar de JSON. Devolviendo array vacío.")
                    return "[]".data(using: .utf8)!
                }
                
                return output.data
            }
            .decode(type: [DrugResponse].self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<[DrugResponse], Error> in
                print("Error procesando respuesta: \(error)")
                
             
                if error is DecodingError {
                    print("Error de decodificación. Devolviendo array vacío.")
                    return Just([])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
