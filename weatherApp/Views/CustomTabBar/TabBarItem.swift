
import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case home, location
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .location: return "location"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return Color.blue
        case .location: return Color.green
        }
    }
}
