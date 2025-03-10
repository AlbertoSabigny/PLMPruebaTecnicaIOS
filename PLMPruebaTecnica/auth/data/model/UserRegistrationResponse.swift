struct UserRegistrationResponse: Codable {
    let saveMobileLocationAppClientResult: String
    
    func toDomain() -> UserCode {
        return UserCode(id: saveMobileLocationAppClientResult)
    }
}
