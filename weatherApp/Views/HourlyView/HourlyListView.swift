import SwiftUI

struct HourlyListView: View {
    @Binding var forecastWeather: ForecastModelData?
    @Binding var currentWeather: CurrentDataModel?
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 28) {
                    if let forecastWeather {
                        let subArray = Array(forecastWeather.list.prefix(12))
                        ForEach(subArray, id: \.self){ item in
                            HourlyListColumnView(forecast: item)
                                .frame(width: 50, height: 159)
                                
                        }
                    }
                }
                .padding(.leading, 24)
            }
        }
    }
}
#Preview {
    AppTabBarView()
}
