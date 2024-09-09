import SwiftUI

struct DailyListView: View {
    @Binding var forecastWeather: ForecastModelData?
    var groupedItems: [[ForecastStruct?]] {
        guard let forecastWeather else { return [] }
        let groupedDictionary = Dictionary(grouping: forecastWeather.list) { item in
            formatDate(dtStr: item?.dtTxt ?? "")
        }
        return groupedDictionary.sorted { $0.key < $1.key }.map { $0.value }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                if let forecastWeather {
                    ForEach(groupedItems, id: \.self) { items in
                        DailyWeatherView(items: items)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
            } .listStyle(PlainListStyle())
        }
        .frame(height: CGFloat((groupedItems.count + 1)) * 49)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(11)
        .padding(24)
    }
}
extension DailyListView {
    private func formatDate(dtStr: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dtStr) ?? Date()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let string = formatter.string(from: date)
        return formatter.date(from: string) ?? Date()
    }
}
#Preview {
    AppTabBarView()
}
