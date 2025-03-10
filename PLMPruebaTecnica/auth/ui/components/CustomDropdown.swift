import SwiftUI

struct CustomDropdown<T: Identifiable>: View {
    var options: [T]
    var selectedOption: T?
    var onOptionSelected: (T) -> Void
    var placeholder: String
    var displayText: (T) -> String
    var errorMessage: String?
    var isLoading: Bool
    

    class DropdownState: ObservableObject {
        @Published var isExpanded = false
    }
    
    @StateObject private var state = DropdownState()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                state.isExpanded.toggle()
            }) {
                HStack {
                    Text(selectedOption.map(displayText) ?? placeholder)
                        .foregroundColor(selectedOption == nil ? .gray : .primary)
                    
                    Spacer()
                    
                    if isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(state.isExpanded ? 180 : 0))
                    }
                }
                .padding(10)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(errorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
                )
            }
            .disabled(isLoading || options.isEmpty)
            
            if state.isExpanded {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(options) { option in
                            Button(action: {
                                onOptionSelected(option)
                                state.isExpanded = false
                            }) {
                                Text(displayText(option))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .background(
                                        selectedOption?.id == option.id ? Color.blue.opacity(0.1) : Color.clear
                                    )
                            }
                            .foregroundColor(.primary)
                            
                            Divider()
                        }
                    }
                }
                .frame(height: min(CGFloat(options.count * 44), 200))
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
            
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 4)
            }
        }
    }
}
