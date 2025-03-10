import SwiftUI

struct SideMenu: View {
    var currentTab: TabItem
    var onTabSelected: (TabItem) -> Void
    var width: CGFloat
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 20) 
                
                Text("Menú")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 16)
                
                Divider()
                    .padding(.bottom, 16)
                
                MenuItem(
                    title: TabItem.search.title,
                    systemImageName: TabItem.search.icon,
                    isSelected: currentTab == .search,
                    action: { onTabSelected(.search) }
                )
                
                MenuItem(
                    title: TabItem.developer.title,
                    systemImageName: TabItem.developer.icon,
                    isSelected: currentTab == .developer,
                    action: { onTabSelected(.developer) }
                )
                
                Spacer()
            }
            .padding()
            .frame(width: width, alignment: .leading)
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.vertical)
        .safeAreaInset(edge: .top) {
            Color.clear
        }
    }
}
