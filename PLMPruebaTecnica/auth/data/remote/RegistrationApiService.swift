import Foundation
import Combine

protocol RegistrationApiService {
    func getCountries() -> AnyPublisher<CountryResponse, Error>
    func getStatesByCountry(countryId: Int) -> AnyPublisher<StateResponse, Error>
    func getProfessions() -> AnyPublisher<ProfessionResponse, Error>
    func registerUser(userData: UserRegistrationRequest) -> AnyPublisher<UserRegistrationResponse, Error>
}

class RegistrationApiServiceImpl: RegistrationApiService {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        
        // Configurar el decoder
        self.decoder = JSONDecoder()
        // Puedes configurar opciones adicionales según sea necesario
        // self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getCountries() -> AnyPublisher<CountryResponse, Error> {
        let endpoint = baseURL.appendingPathComponent("getCountries")
        
        return makeRequest(url: endpoint)
    }
    
    func getStatesByCountry(countryId: Int) -> AnyPublisher<StateResponse, Error> {
        let endpoint = baseURL.appendingPathComponent("getStateByCountry")
        
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "countryId", value: "\(countryId)")]
        
        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return makeRequest(url: url)
    }
    
    func getProfessions() -> AnyPublisher<ProfessionResponse, Error> {
        let endpoint = baseURL.appendingPathComponent("getProfessions")
        
        return makeRequest(url: endpoint)
    }
    
    func registerUser(userData: UserRegistrationRequest) -> AnyPublisher<UserRegistrationResponse, Error> {
        let endpoint = baseURL.appendingPathComponent("saveMobileLocationAppClient")
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(userData)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return makeRequest(request: request)
    }
    
    private func makeRequest<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        let request = URLRequest(url: url)
        return makeRequest(request: request)
    }
    
    private func makeRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, Error> {
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                // Para debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Respuesta JSON recibida: \(jsonString)")
                }
            })
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
