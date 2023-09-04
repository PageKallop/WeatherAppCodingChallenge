import Foundation
import UIKit

struct WeatherModel {
  
  let conditionId: Int
  let cityName: String
  let temperature: Double
  let feelsLike: Double
  let maxTemp: Double
  let minTemp: Double
  let iconUrl: String
  
  // turn temp into a string
  var temperatureString: String {
    return String(format: "%.1f", temperature)
  }
  var feelsLikeString: String {
    return String(format: "%.1f", feelsLike)
  }
  var maxTempString: String {
    return String(format: "%.1f", maxTemp)
  }
  var minTempString: String {
    return String(format: "%.1f", minTemp)
  }
}
