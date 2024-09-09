import SwiftUI

struct DataListRowView: View {
    let model: DataModel
    var body: some View {
        VStack(spacing: 6) {
            Text(model.title)
                .foregroundColor(.gray.opacity(0.5))
                .font(.system(size: 12, weight: .medium, design: .monospaced))
            Text(model.value)
                .foregroundColor(.gray.opacity(0.8))
                .font(.system(size: 15, weight: .medium, design: .monospaced))
        }
        .padding(.vertical, 12)
    }
}
#Preview {
    AppTabBarView()
}
