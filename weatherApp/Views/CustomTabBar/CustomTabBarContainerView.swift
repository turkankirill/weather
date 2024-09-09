import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {
    
    @Binding var selection: TabBarItem
    @Binding var tapToPluse: Bool
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, tapToPluse: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self._tapToPluse = tapToPluse
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection, tapToPluse: $tapToPluse)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })

    }
}
