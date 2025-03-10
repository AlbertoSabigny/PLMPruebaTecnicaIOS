import SwiftUI

struct SearchScreen: View {
    @StateObject private var viewModel = DrugSearchViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
        
            SearchBar(
                searchText: $searchText,
                onSearchTextChanged: { newText in
                    viewModel.onEvent(.searchQueryChanged(newText))
                },
                onSearchSubmitted: {
                    viewModel.onEvent(.search)
                }
            )
            
        
            statusMessageView
            
          
            resultContentView
        }
        .padding(16)
    }
    

    private var statusMessageView: some View {
        Group {
            switch viewModel.state {
            case .idle:
                messageView(message: "Ingrese un medicamento para buscar", isError: false)
                
            case .loading:
                messageView(message: "Buscando...", isError: false)
                
            case .success:
                EmptyView()
                
            case .empty:
                messageView(message: "No se encontraron medicamentos", isError: true)
                
            case .serverUnavailable:
                messageView(
                    message: "Error en los servidores. Intente más tarde. A continuación se muestra una lista de muestra.",
                    isError: true
                )
                
            case .error(let message):
                messageView(message: message ?? " Error desconocido", isError: true)
            }
        }
    }
    
  
    private var resultContentView: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                
            case .success(let drugs):
                DrugList(drugs: drugs)
                
            case .serverUnavailable:
              
                DrugList(drugs: getMockDrugs())
                
            default:
                Spacer()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
  
    private func messageView(message: String, isError: Bool) -> some View {
        Text(message)
            .font(isError ? .callout.bold() : .callout)
            .foregroundColor(isError ? .red : .primary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 8)
    }
    
   
    private func getMockDrugs() -> [Drug] {
        return [
            Drug(name: "Paracetamol", form: "Tableta"),
            Drug(name: "Ibuprofeno", form: "Cápsula"),
            Drug(name: "Aspirina", form: "Tableta"),
            Drug(name: "Omeprazol", form: "Cápsula")
        ]
    }
}


struct SearchBar: View {
    @Binding var searchText: String
    var onSearchTextChanged: (String) -> Void
    var onSearchSubmitted: () -> Void
    
    var body: some View {
        HStack {
            TextField("Buscar medicamento", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: searchText) { newValue in
                    onSearchTextChanged(newValue)
                }
                .onSubmit {
                    onSearchSubmitted()
                }
            
            Button(action: onSearchSubmitted) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
    }
}


struct DrugList: View {
    let drugs: [Drug]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(drugs, id: \.name) { drug in
                    DrugItemView(drug: drug)
                }
            }
        }
    }
}


struct DrugItemView: View {
    let drug: Drug
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(drug.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(drug.form)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}


struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
