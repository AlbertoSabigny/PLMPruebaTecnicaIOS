struct CountryDto: Codable {
    let Active: Bool?
    let CountryCode: String?
    let CountryId: Int?
    let CountryLada: String?
    let CountryName: String?
    let ID: String?
    
    func toDomain() -> Country? {
       
        guard let id = CountryId,
              let name = CountryName,
              let shortName = ID,
              let active = Active,
              active == true,
              id > 0
        else {
            return nil
        }
        
        // Usar valores predeterminados para campos opcionales
        return Country(
            id: id,
            name: name,
            code: CountryCode ?? "",
            lada: CountryLada ?? "",
            active: active
        )
    }
}
