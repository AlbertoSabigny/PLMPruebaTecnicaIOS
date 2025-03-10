import SwiftUI

struct DeveloperScreen: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
          
                    Spacer()
                        .frame(height: max(0, (geometry.size.height - 500) / 2))
                    
                 
                    DeveloperCard(
                        name: "Alberto Tovar Ramirez",
                        email: "Alberto.tovar.dev@gmail.com",
                        phone: "+52 55 1764 3861",
                        role: "Desarrollador Móvil",
                        location: "CDMX, México"
                    )
                    
                   
                    Spacer()
                        .frame(height: max(0, (geometry.size.height - 500) / 2))
                }
                .frame(minHeight: geometry.size.height)
                .padding(16)
            }
        }
        .navigationTitle("Desarrollador")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeveloperScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeveloperScreen()
        }
    }
}
