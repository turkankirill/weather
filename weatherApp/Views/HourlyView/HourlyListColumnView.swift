import SwiftUI

struct HourlyListColumnView: View {
    var forecast: ForecastStruct?
    @State var image: UIImage?
    var body: some View {
        VStack(alignment: .center) {
            Text(forecast?.dtTxt?.convertToDate.hourBasicIdentifier ?? "")
                .fontWeight(.medium)
            VStack {
                Image(forecast?.weather[0]?.icon ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            }
            .frame(height: 76)
            Text(forecast?.main?.temp != nil ? String(Int(round(forecast?.main?.temp ?? 0))) + "°" : "-")
                .fontWeight(.medium)
        }
    }
}
#Preview {
    AppTabBarView()
}
