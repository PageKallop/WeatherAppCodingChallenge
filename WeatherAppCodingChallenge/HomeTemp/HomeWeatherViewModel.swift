import Foundation
import CoreLocation
import UIKit

protocol WeatherManagerDelegate {
  func didUpdateWeather(weather: WeatherModel)
  func updateLocalWeather(weather: WeatherModel)
  func handleSearchedWeatherError()
  func handleLocalWeatherError()
}


class HomeWeatherViewModel {
  var delegate: WeatherManagerDelegate?
// api key in .gitignore file
  let localWeatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=\(WeatherConstants.shared.apiKey)&units=imperial&"
  
  let searchedWeather = "https://api.openweathermap.org/data/2.5/weather?&appid=\(WeatherConstants.shared.apiKey)&units=imperial&q="
  
  // creates url string with city
  func searchWeather(cityName: String) {
    let urlString = "\(searchedWeather)\(cityName)"
    getWeather(with: urlString)
  }
  
  // creates url string with users location
  func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(localWeatherURL)&lat=\(latitude)&lon=\(longitude)"
    getLocalWeather(with: urlString)
  }
  
  func getWeather(with urlString: String) {
    guard let url = URL(string: urlString) else { return }
    getTheWeather(urlString: url) { data in
      if let safeData = data {
        if let weather = self.parseJSON(safeData) {
          self.delegate?.didUpdateWeather(weather: weather)
        } else {
          self.delegate?.handleLocalWeatherError()
        }
      }
    }
  }

  func getLocalWeather(with urlString: String) {
    guard let url = URL(string: urlString) else { return }
    getTheWeather(urlString: url) { weatherData in
      guard let weatherData = weatherData else { return }
      if let weather = self.parseJSON(weatherData) {
        self.delegate?.updateLocalWeather(weather: weather)
      } else {
        self.delegate?.handleSearchedWeatherError()
      }
    }
  }
  
  func getTheWeather(urlString: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: urlString) { data, responce, error in
      if let error = error {
        print("ERROR GETTING LOCAL WEATHER \(error)")
        completionHandler(nil)
        return
      } else if let data = data {
        completionHandler(data)
      }
    }
    task.resume()
  }
  
  func parseJSON(_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodedData.weather[0].id
      let temp = decodedData.main.temp
      let name = decodedData.name
      let feelsLike = decodedData.main.feels_like
      let maxTemp = decodedData.main.temp_max
      let minTemp = decodedData.main.temp_min
      let returnedIcon = decodedData.weather[0].icon
      let iconUrl = "https://openweathermap.org/img/wn/\(returnedIcon).png"
      let weather = WeatherModel(conditionId: id,
                                 cityName: name,
                                 temperature: temp,
                                 feelsLike: feelsLike,
                                 maxTemp: maxTemp,
                                 minTemp: minTemp,
                                 iconUrl: iconUrl)
      return weather
      
    } catch {
      print("ERROR WITH PARSE DATA \(error)")
      return nil
    }
  }
  
  func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: url) else { return }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { (data, response, error) in
      if error != nil {
        print("Error DOWNLOADING IMAGE \(error!)")
        completion(nil)
        return
      }
      if let data = data, let image = UIImage(data: data) {
        // Successfully decoded the image data
        completion(image)
      } else {
        // Failed to decode image data or the data was empty
        completion(nil)
      }
    }
    task.resume()
  }
}

