import SwiftUI

struct SubView: View {
    @Binding var currentWeather: CurrentDataModel?

    var body: some View {
        
        ZStack {
            VStack(spacing: 21) {
                if let weather = currentWeather?.weather.first,
                   let iconCode = weather?.icon {
                    Image(iconCode)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160)
                }
                VStack {
                    Text(currentWeather?.weather.first??.main ?? "-")
                        .font(.system(size: 21, weight: .regular, design: .monospaced))
                    Text(currentWeather?.main?.temp != nil ? String(Int(round(currentWeather?.main?.temp ?? 0))) + "°" : "-")
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                }
            }
            }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text(currentWeather?.name ?? "-")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
            }
        }
    }
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}
#Preview {
    AppTabBarView()
}
