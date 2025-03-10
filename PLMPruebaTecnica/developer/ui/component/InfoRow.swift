import SwiftUI

struct InfoRow: View {
   
    let systemImageName: String
    
    
    let text: String
    
   
    var textColor: Color = .secondary
    
    var body: some View {
      
        HStack(alignment: .center) {
           
            Image(systemName: systemImageName)
                .foregroundColor(.accentColor)
                .font(.system(size: 24))
                .frame(width: 24, height: 24)
            
            
            Spacer()
                .frame(width: 16)
            
    
            Text(text)
                .font(.body)
                .foregroundColor(textColor)
            
            Spacer()
        }
       
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)       
    }
}
