struct UserRegistrationRequest: Codable {
    let codePrefix: String
    let country: Int
    let email: String
    let firstName: String
    let lastName: String
    let phone: String?
    let profession: Int
    let professionLicense: String?
    let slastName: String?
    let source: Int
    let state: String
    let targetOutput: Int
    
    init(email: String, firstName: String, lastName: String, phone: String?,
         profession: Int, professionLicense: String?, slastName: String?, state: String) {
        self.codePrefix = "TESTPLM"
        self.country = 1
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.profession = profession
        self.professionLicense = professionLicense
        self.slastName = slastName
        self.source = 27
        self.state = state
        self.targetOutput = 5
    }
}
