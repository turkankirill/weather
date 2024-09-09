import SwiftUI

struct DayNightGraphView: View {
    let sunrise: Date
    let sunset: Date
    let currentTime: Date
    var image: String
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let horizonY = height / 2
            let sunriseX = CGFloat(sunrise.hour * 3600 + sunrise.minute * 60) / (24 * 3600) * width
                       let sunsetX = CGFloat(sunset.hour * 3600 + sunset.minute * 60) / (24 * 3600) * width
                       let currentX = CGFloat(currentTime.hour * 3600 + currentTime.minute * 60) / (24 * 3600) * width


            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: horizonY))
                    path.addLine(to: CGPoint(x: width, y: horizonY))
                }
                .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, dash: [5, 5]))
                            .foregroundColor(.gray)

                Path { path in
                    path.move(to: CGPoint(x: 0, y: horizonY + 50))
                    path.addCurve(
                        to: CGPoint(x: width, y: horizonY + 50),
                        control1: CGPoint(x: sunriseX, y: horizonY - 100),
                        control2: CGPoint(x: sunsetX, y: horizonY - 100)
                    )
                    path.addLine(to: CGPoint(x: width, y: horizonY))
                    path.addLine(to: CGPoint(x: 0, y: horizonY))
                    path.closeSubpath()
                }
                .fill(Color.blue.opacity(0.3))

                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .position(x: currentX, y: getCurrentSunYPosition(currentX: currentX, sunriseX: sunriseX, sunsetX: sunsetX, horizonY: horizonY, width: width))

                Text("\(sunrise.formattedTime)").position(x: sunriseX - 20, y: horizonY + 15)
                Text("\(sunset.formattedTime)").position(x: sunsetX, y: horizonY + 15)
            }
        }
    }

    private func timeToFraction(_ date: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        let totalSecondsInDay = 24 * 60 * 60
        let timeInSeconds = (components.hour ?? 0) * 3600 + (components.minute ?? 0) * 60 + (components.second ?? 0)
        return Double(timeInSeconds) / Double(totalSecondsInDay)
    }
    
    private func getCurrentSunYPosition(currentX: CGFloat, sunriseX: CGFloat, sunsetX: CGFloat, horizonY: CGFloat, width: CGFloat) -> CGFloat {
        if currentX < sunriseX || currentX > sunsetX {
            return horizonY + 50
        }
        else {
            let middleX = (sunriseX + sunsetX) / 2
            if currentX < middleX {
                let progress = (currentX - sunriseX) / (middleX - sunriseX)
                return horizonY - 100 * progress
            } else {
                let progress = (currentX - middleX) / (sunsetX - middleX)
                return horizonY - 100 * (1 - progress)
            }
        }
    }
}
