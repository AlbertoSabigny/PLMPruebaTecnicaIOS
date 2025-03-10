struct DrugResponse: Codable {
    let brand: String?
    let pharmaForm: String?
    
    enum CodingKeys: String, CodingKey {
        case brand = "Brand"
        case pharmaForm = "PharmaForm"
    }
    
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys>
        
        do {
        
            container = try decoder.container(keyedBy: CodingKeys.self)
        } catch {
           
            print("Error al decodificar DrugResponse: \(error)")
            
            brand = nil
            pharmaForm = nil
            return
        }
        
       
        do {
            brand = try container.decodeIfPresent(String.self, forKey: .brand)
        } catch {
            print("Error decodificando 'Brand': \(error)")
            brand = nil
        }
        
        do {
            pharmaForm = try container.decodeIfPresent(String.self, forKey: .pharmaForm)
        } catch {
            print("Error decodificando 'PharmaForm': \(error)")
            pharmaForm = nil
        }
    }

    func toDomain() -> Drug? {
     
        guard let name = brand,
              let form = pharmaForm,
              !name.isEmpty
        else {
            return nil
        }
        
        return Drug(
            name: name,
            form: form
        )
    }
}


extension Array where Element == DrugResponse {
  
    func toDomain() -> [Drug] {
       
        return self.compactMap { $0.toDomain() }
    }
}

