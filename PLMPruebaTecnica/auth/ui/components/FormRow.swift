import SwiftUI

struct FormRow<Content: View>: View {
    let label: String
    let content: () -> Content
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(label)
                .font(.body)
                .fontWeight(.bold)
                .frame(width: 100, alignment: .leading)
            
            content()
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
}
