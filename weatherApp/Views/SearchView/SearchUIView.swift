
import SwiftUI

struct SearchUIView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddViewModel
    @State var isLocationList: Bool = true
    var sendData: (LocationType, AnnotationItem) -> Void
    init(viewModel: AddViewModel, sendData: @escaping (LocationType, AnnotationItem) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.sendData = sendData
    }
    var body: some View {
        NavigationView {
            List {
                if !isLocationList {
                    ForEach(viewModel.results) { item in
                        TextView(title: item.title)
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded { _ in
                                        Task {
                                            await viewModel.getPlace(from: item)
                                            await MainActor.run {
                                                sendData(.add, viewModel.annotationItems.first ?? AnnotationItem(latitude: 1, longitude: 1))
                                            }
                                            dismiss()
                                        }
                                    }
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .searchable(text: $viewModel.searchableText, prompt: "Search for a city or airport")
            .onChange(of: viewModel.searchableText) { _, newValue in
                isLocationList = viewModel.searchableText.isEmpty
                viewModel.searchAddress(newValue)

            }
            .navigationTitle("Search")
        }
    }
}

