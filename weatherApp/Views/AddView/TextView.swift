import SwiftUI

struct TextView: View {
    @Environment(\.dismissSearch) private var dismissSearch
    var title: String

    var body: some View {
        Text(title.capitalized)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                dismissSearch()
            }
    }
}
