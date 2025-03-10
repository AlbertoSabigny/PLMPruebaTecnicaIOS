import SwiftUI

struct MenuItem: View {
    var title: String
    var systemImageName: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImageName)
                    .imageScale(.large)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Text(title)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()
            }
        }
        .padding(.vertical, 12)
    }
}
