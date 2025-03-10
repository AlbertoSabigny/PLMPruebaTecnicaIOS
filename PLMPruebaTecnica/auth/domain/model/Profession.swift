struct Profession: Identifiable {
    let id: Int
    let name: String
    let englishName: String
    let parentId: Int?
    let requiresLicense: Bool
    let active: Bool
}
