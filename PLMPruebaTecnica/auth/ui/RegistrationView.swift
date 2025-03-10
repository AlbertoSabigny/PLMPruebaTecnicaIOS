import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focusField: Field?
    
    enum Field: Hashable {
        case email
        case firstName
        case lastName
        case maternalLastName
        case phone
        case professionalLicense
    }
    
    let onRegistrationComplete: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
            
                
            
                formField(
                    label: "Email:",
                    value: viewModel.state.email,
                    placeholder: "Email",
                    keyboardType: .emailAddress,
                    errorMessage: viewModel.state.emailError,
                    focusField: .email,
                    onValueChange: { viewModel.onEvent(.emailChanged($0)) }
                )
                
       
                formField(
                    label: "Nombre:",
                    value: viewModel.state.firstName,
                    placeholder: "Nombre",
                    errorMessage: viewModel.state.firstNameError,
                    focusField: .firstName,
                    onValueChange: { viewModel.onEvent(.firstNameChanged($0)) }
                )
                
       
                formField(
                    label: "A. Paterno:",
                    value: viewModel.state.lastName,
                    placeholder: "Apellido Paterno",
                    errorMessage: viewModel.state.lastNameError,
                    focusField: .lastName,
                    onValueChange: { viewModel.onEvent(.lastNameChanged($0)) }
                )
                
       
                formField(
                    label: "A. Materno:",
                    value: viewModel.state.maternalLastName,
                    placeholder: "Apellido Materno",
                    errorMessage: viewModel.state.maternalLastNameError,
                    focusField: .maternalLastName,
                    onValueChange: { viewModel.onEvent(.maternalLastNameChanged($0)) }
                )
                
          
                formField(
                    label: "Teléfono:",
                    value: viewModel.state.phone,
                    placeholder: "Teléfono",
                    keyboardType: .numberPad,
                    errorMessage: viewModel.state.phoneError,
                    focusField: .phone,
                    onValueChange: { viewModel.onEvent(.phoneChanged($0)) }
                )
                
        
                dropdownField(
                    label: "Profesión:",
                    options: viewModel.state.professions,
                    selectedOption: viewModel.state.selectedProfession,
                    placeholder: "Seleccione profesión",
                    displayText: { $0.name },
                    errorMessage: viewModel.state.professionError,
                    isLoading: viewModel.state.isLoadingProfessions,
                    onOptionSelected: { viewModel.onEvent(.professionSelected($0)) }
                )
                
         
                if viewModel.state.isProfessionalLicenseRequired {
                    formField(
                        label: "Cédula:",
                        value: viewModel.state.professionalLicense,
                        placeholder: "Cédula profesional",
                        errorMessage: viewModel.state.professionalLicenseError,
                        focusField: .professionalLicense,
                        onValueChange: { viewModel.onEvent(.professionalLicenseChanged($0)) }
                    )
                }
                
               
                dropdownField(
                    label: "País:",
                    options: viewModel.state.countries,
                    selectedOption: viewModel.state.selectedCountry,
                    placeholder: "Seleccione país",
                    displayText: { $0.name },
                    errorMessage: viewModel.state.countryError,
                    isLoading: viewModel.state.isLoadingCountries,
                    onOptionSelected: { viewModel.onEvent(.countrySelected($0)) }
                )
                
                
                dropdownField(
                    label: "Estado:",
                    options: viewModel.state.states,
                    selectedOption: viewModel.state.selectedState,
                    placeholder: "Seleccione estado",
                    displayText: { $0.name },
                    errorMessage: viewModel.state.stateError,
                    isLoading: viewModel.state.isLoadingStates,
                    onOptionSelected: { viewModel.onEvent(.stateSelected($0)) }
                )
                
          
                Button(action: {
                    viewModel.onEvent(.submitRegistration)
                }) {
                    ZStack {
                        if viewModel.state.isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Registrarse")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 200)
                    .padding()
                    .background(viewModel.state.isSubmitting ? Color.blue.opacity(0.5) : Color(red: 0.2, green: 0.5, blue: 0.9))
                    .cornerRadius(10)
                }
                .disabled(viewModel.state.isSubmitting)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                
                // Mensaje de error
                if let error = viewModel.state.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Registro")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
        .onChange(of: viewModel.state.registrationCompleted) { completed in
            if completed {
                onRegistrationComplete()
            }
        }
    }
    

    private func formField(
        label: String,
        value: String,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        errorMessage: String?,
        focusField: Field,
        onValueChange: @escaping (String) -> Void
    ) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.body)
                .fontWeight(.bold)
                .frame(width: 100, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                TextField(placeholder, text: Binding(
                    get: { value },
                    set: { onValueChange($0) }
                ))
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .padding(10)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(errorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
                )
                .focused($focusField, equals: focusField)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 4)
                }
            }
        }
    }
    
    
    private func dropdownField<T: Identifiable>(
        label: String,
        options: [T],
        selectedOption: T?,
        placeholder: String,
        displayText: @escaping (T) -> String,
        errorMessage: String?,
        isLoading: Bool,
        onOptionSelected: @escaping (T) -> Void
    ) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.body)
                .fontWeight(.bold)
                .frame(width: 100, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                if isLoading {
                    HStack {
                        Text(placeholder)
                            .foregroundColor(.gray)
                        Spacer()
                        ProgressView()
                    }
                    .padding(10)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                } else {
                    Menu {
                        ForEach(options) { option in
                            Button(action: {
                                onOptionSelected(option)
                            }) {
                                Text(displayText(option))
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedOption.map(displayText) ?? placeholder)
                                .foregroundColor(selectedOption == nil ? .gray : .primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding(10)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(errorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
                        )
                    }
                    .disabled(options.isEmpty)
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
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegistrationView(onRegistrationComplete: {})
        }
    }
}
