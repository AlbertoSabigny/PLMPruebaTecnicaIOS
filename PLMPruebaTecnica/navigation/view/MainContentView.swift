import SwiftUI

struct MainContentView: View {
    @Binding var selectedTab: TabItem
    @State private var isMenuOpen = false
    
    var body: some View {
        ZStack(alignment: .leading) {
           
            VStack {
                switch selectedTab {
                case .search:
                    SearchScreen()
                case .developer:
                    DeveloperScreen()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(selectedTab.title)
            
     
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea(edges: .all)
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }
                    .transition(.opacity)
            }
            
          
            GeometryReader { geometry in
                let menuWidth = min(geometry.size.width * 0.7, 300)
                
                ZStack {
              
                    Rectangle()
                        .fill(Color(UIColor.systemBackground))
                        .frame(width: menuWidth)
                        .shadow(color: .black.opacity(0.3), radius: 5)
                    
                   
                    SideMenu(
                        currentTab: selectedTab,
                        onTabSelected: { newTab in
                            selectedTab = newTab
                            withAnimation {
                                isMenuOpen = false
                            }
                        },
                        width: menuWidth
                    )
                    .frame(width: menuWidth)
                }
                .offset(x: isMenuOpen ? 0 : -menuWidth - 20)
                .animation(.easeInOut(duration: 0.3), value: isMenuOpen)
            }
            .zIndex(1)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    withAnimation {
                        isMenuOpen.toggle()
                    }
                } label: {
                    Image(systemName: "line.horizontal.3")
                }
            }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            if isMenuOpen {
                
                withAnimation {
                    isMenuOpen = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            isMenuOpen = true
                        }
                    }
                }
            }
        }
    }
}
