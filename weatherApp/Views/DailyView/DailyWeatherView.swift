import SwiftUI

struct DailyWeatherView: View {
    let items: [ForecastStruct?]
    var body: some View {
        HStack() {
            Text(formatDate(dtStr: items[0]?.dtTxt ?? "").dayNameOrToday)
                .opacity(0.5)
            
            HStack(spacing: 16) {
                if var image = items[0]?.weather[0]?.icon {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                
                Text("\(Int(round(maxTempMax())))°")
                    .frame(width: 30)

                Text("\(Int(round(minTempMin())))°")
                    .opacity(0.5)
                    .frame(width: 30)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
        .listRowBackground(Color.clear)
        .padding(.vertical)
    }
}
extension DailyWeatherView {
    private func formatDate(dtStr: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dtStr) ?? Date()
    }

    private func minTempMin() -> Float {
        guard let firstTempMin = items[0]?.main?.tempMin else { return 0.0 }
        let minTemp = items.compactMap { $0?.main?.tempMin }.min() ?? firstTempMin
        return min(firstTempMin, minTemp)
    }

    private func maxTempMax() -> Float {
        guard let firstTempMax = items[0]?.main?.tempMax else { return 0.0 }
        let maxTemp = items.compactMap { $0?.main?.tempMin }.max() ?? firstTempMax
        return max(firstTempMax, maxTemp)
    }
}
#Preview {
    AppTabBarView()
}
