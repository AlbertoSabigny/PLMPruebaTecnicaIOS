struct ProfessionDto: Codable {
    let Active: Bool?
    let EnglishName: String?
    let ParentId: Int?
    let ProfessionId: Int?
    let ProfessionName: String?
    let ReqProfessionalLicense: Bool?
    
    func toDomain() -> Profession? {
        guard let id = ProfessionId,
              let name = ProfessionName,
              let englishName = EnglishName,
              let active = Active,
              let requiresLicense = ReqProfessionalLicense else {
            return nil
        }
        
        return Profession(
            id: id,
            name: name,
            englishName: englishName,
            parentId: ParentId,
            requiresLicense: requiresLicense,
            active: active
        )
    }
}
