import UIKit
import MapKit

struct AddressResult: Identifiable {
    let id = UUID()
    let title: String
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
}
