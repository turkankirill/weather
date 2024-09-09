
import SwiftUI

struct NoResultsView: View {
    @Binding var searchText: String

    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            Text("No Results")
                .font(.title2)
            Text("No results found for \"\(searchText)\"")
                .foregroundColor(.gray)
                .font(.title3)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}


