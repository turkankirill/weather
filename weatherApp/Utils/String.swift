import Foundation

extension String {
    var convertToDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self) ?? Date()
    }
}
