import SwiftUI

struct DeveloperCard: View {
    let name: String
    let email: String
    let phone: String
    let role: String
    let location: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let grayColor: Color = colorScheme == .dark ? Color(UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1.0)) : Color(UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0))
        
        let textColor: Color = colorScheme == .dark ? .white : .black
        
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(grayColor)
                .shadow(radius: 4)
            
            VStack(alignment: .center, spacing: 0) {
           
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Color.accentColor, lineWidth: 2)
                        )
                    
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                }
                
                Spacer()
                    .frame(height: 16)
                
      
                Text(name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(textColor)
                
              
                Text(role)
                    .font(.system(size: 18))
                    .foregroundColor(.accentColor)
                    .padding(.top, 4)
                
                Spacer()
                    .frame(height: 24)
                
             
                InfoRow(
                    systemImageName: "envelope",
                    text: email,
                    textColor: textColor
                )
                
                InfoRow(
                    systemImageName: "phone",
                    text: phone,
                    textColor: textColor
                )
                
                InfoRow(
                    systemImageName: "location",
                    text: location,
                    textColor: textColor
                )
                
                Spacer()
                    .frame(height: 16)
            }
            .padding(16)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
    }
}

struct DeveloperCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeveloperCard(
                name: "Alberto Sabigny",
                email: "alberto@example.com",
                phone: "+52 123 456 7890",
                role: "iOS Developer",
                location: "Ciudad de México, México"
            )
            .previewDisplayName("Light Mode")
            
            DeveloperCard(
                name: "Alberto Sabigny",
                email: "alberto@example.com",
                phone: "+52 123 456 7890",
                role: "iOS Developer",
                location: "Ciudad de México, México"
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
