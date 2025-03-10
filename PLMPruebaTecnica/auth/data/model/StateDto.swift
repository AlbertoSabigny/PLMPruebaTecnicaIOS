struct StateDto: Codable {
    let Active: Bool?
    let CountryId: Int?
    let ShortName: String?
    let StateId: Int?
    let StateName: String?
    
    func toDomain() -> StateModel? {
        guard let id = StateId,
              let name = StateName,
              let shortName = ShortName,
              let countryId = CountryId,
              let active = Active else {
            return nil
        }
        
        return StateModel(
            id: id,
            name: name,
            shortName: shortName,
            countryId: countryId,
            active: active
        )
    }
}
