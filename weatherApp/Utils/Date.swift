import Foundation

extension Date {
    var nameOfTheDay: String {
        let date = self
        let identifier = DateFormatter.nameOfTheDayFormatter.string(from: date)
        return identifier
    }
    
    var sunriseAndSunsetValue: String {
        let data = self
        let identifier = DateFormatter.sunriseAndSunsetValueFormatter.string(from: data)
        return identifier
    }
    
    var numberOfTheDayAndMonth: String {
        let data = self
        let identifier = DateFormatter.numberOfTheDayAndMonthFormatter.string(from: data)
        return identifier
    }
    
    var dateUniqueIdentifier: String {
        let date = self
        let identifier =  DateFormatter.dateWeatherFormatter.string(from: date)
        return identifier
    }
    
    var hourUniqueIdentifier: String {
        let date = self
        let identifier =  DateFormatter.hourWeatherFormatter.string(from: date)
        return identifier
    }
    
    var fullDateUniqueIdentifier: String {
        return "\(self.dateUniqueIdentifier)_\(self.hourUniqueIdentifier)"
    }
    
    var dayNameOrToday: String {
        let today = Calendar.current.startOfDay(for: Date())
        let date = Calendar.current.startOfDay(for: self)
        if today == date {
            return "Today"
        } else {
            return DateFormatter.nameOfTheDayFormatter.string(from: date)
        }
    }
    
    var hourBasicIdentifier: String {
        let date = self
        let identifier = DateFormatter.hourBasicFormatter.string(from: date)
        return identifier
    }
    
    func hourAndMinuteIdentifier(timezone: Int) -> String {
        let date = self
        let identifier = DateFormatter.hourAndMinuteFormatter(timezone: timezone).string(from: date)
        return identifier
    }
        var hour: Int {
            Calendar.current.component(.hour, from: self)
        }
        
        var minute: Int {
            Calendar.current.component(.minute, from: self)
        }
        var formattedTime: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: self)
        }
}


extension DateFormatter {
    static let dateWeatherFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd_MM_yyyy"
        return dateFormatter
    }()
 
    static func hourAndMinuteFormatter(timezone: Int) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    static let hourBasicFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    
    static let hourWeatherFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "h a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter
    }()
    
    static let nameOfTheDayFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }()
    
    static let sunriseAndSunsetValueFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter
    }()
    
    static let numberOfTheDayAndMonthFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM"
        return dateFormatter
    }()
}
