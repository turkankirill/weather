
import SwiftUI

struct DataListView: View {
    @Binding var currentWeather: CurrentDataModel?

    var body: some View {
        VStack {
            HStack{
                if let currentWeather {
                    let items = [
                        DataModel(title: "Humidity", value: currentWeather.main?.humidity != nil ? String(Int(round(Double(currentWeather.main?.humidity ?? 0)))) + " g/m^3" : "-"),
                        DataModel( title: "hPa", value: currentWeather.main?.pressure != nil ? String(Int(round(Double(currentWeather.main?.pressure ?? 0)))) + " hPa" : "-"),
                        DataModel(title: "Wind", value: currentWeather.wind?.speed != nil ? String(Int(round(currentWeather.wind?.speed ?? 0))) + " km/h" : "-"),
                    ]
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(items, id: \.self) { item in
                            DataListRowView(model: item)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(Color.gray.opacity(0.2)))
                }
            }
            .padding(.horizontal, 24)
            if let sunrise = currentWeather?.sys?.sunrise, let sunset = currentWeather?.sys?.sunset {
                if let weather = currentWeather?.weather.first,
                   let iconCode = weather?.icon {
                    
                    DayNightGraphView(sunrise: sunrise, sunset: sunset, currentTime: Date(), image: iconCode)
                        .frame(height: 200)
                }
            }
        }
    }
}
#Preview {
    AppTabBarView()
}

