import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationView {
                TabView(selection: $selectedIndex) {
                    SirenView(user: user)
                        .tabItem {
                            Image(systemName: "cube")
                            Text("Siren")
                        }
                        .tag(0)
                    ConversationsView()
                        .tabItem {
                            Image(systemName: "bubble.left")
                            Text("Chats")
                        }
                        .tag(1)
                    
                    ChannelsView()
                        .tabItem {
                            Image(systemName: "bubble.left.and.bubble.right")
                            Text("Channels")
                        }
                        .tag(2)
                    
                    SettingsView(user: user)
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(3)
                }
                .navigationTitle(tabTitle)
            }
        } else {
            Text("Cannot be viewed.")
        }
    }
    
    var tabTitle: String {
        switch selectedIndex {
        case 0: return "Siren"
        case 1: return "Chats"
        case 2: return "Channels"
        case 3: return "Settings"
        default: return ""
        }
    }
}
