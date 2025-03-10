import SwiftUI

struct MainApp: View {
    @StateObject private var viewModel = MainAppViewModel()
    @State private var selectedTab: TabItem = .search
    
    var body: some View {
        NavigationView {
            if viewModel.isLoggedIn {
                MainContentView(selectedTab: $selectedTab)
                    .environmentObject(viewModel)
            } else {
                RegistrationView(onRegistrationComplete: {
                    viewModel.checkUserSession()
                })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
