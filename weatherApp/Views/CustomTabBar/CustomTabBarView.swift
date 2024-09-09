import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    @Binding var tapToPluse: Bool
    
    var body: some View {
        tabBarVersion1
            .onChange(of: selection, perform: { value in
                withAnimation(.easeInOut) {
                    localSelection = value
                }
            })
            .overlay(alignment: .center) {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 60, height: 60)
                    .overlay(alignment: .center) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .offset(y: -10)
                    .shadow(color: .gray.opacity(0.4), radius: 10, y: 5)
                    .onTapGesture {
                        tapToPluse.toggle()
                    }
            }
    }
}


extension CustomTabBarView {
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.title3)
        }
        .foregroundColor(localSelection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
    }
    
    private var tabBarVersion1: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges: .bottom)
            .shadow(color: .gray.opacity(0.4),radius: 10, y: -10))
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
    
}

