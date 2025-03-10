import SwiftUI

struct CustomButton: View {
    var text: String
    var isLoading: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(text)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isLoading ? Color.blue.opacity(0.7) : Color.blue)
            .cornerRadius(10)
        }
        .disabled(isLoading)
    }
}
