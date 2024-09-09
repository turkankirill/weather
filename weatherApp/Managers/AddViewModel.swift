import MapKit

final class AddViewModel: NSObject, ObservableObject {
    @Published private(set) var results: Array<AddressResult> = []
    @Published var searchableText = ""
    @Published private(set) var annotationItems: [AnnotationItem] = []

    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    func searchAddress(_ searchableText: String) {
        guard searchableText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText
    }
}

extension AddViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            results = completer.results.map {
                AddressResult(title: $0.title)
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }

    func getPlace(from address: AddressResult) async {
        let request = MKLocalSearch.Request()
        let title = address.title
        
        request.naturalLanguageQuery = title
        
        do {
            let response = try await MKLocalSearch(request: request).start()
            Task {
                await MainActor.run {
                    self.annotationItems = response.mapItems.map {
                        AnnotationItem(
                            latitude: $0.placemark.coordinate.latitude,
                            longitude: $0.placemark.coordinate.longitude
                        )
                    }
                }
            }
        } catch {
            print("Search error: \(error.localizedDescription)")
        }
    }

}
