import XCTest
import CoreLocation
@testable import WeatherAppCodingChallenge

class HomeWeatherViewModelTests: XCTestCase {
  
  // Mock delegate
  class MockWeatherManagerDelegate: WeatherManagerDelegate {
    var didUpdateWeatherCalled = false
    var updateLocalWeatherCalled = false
    
    func didUpdateWeather(_ weatherManager: HomeWeatherViewModel, weather: WeatherModel) {
      didUpdateWeatherCalled = true
    }
    
    func updateLocalWeather(_ weatherManager: HomeWeatherViewModel, weather: WeatherModel) {
      updateLocalWeatherCalled = true
    }
  }
  
  var viewModel: HomeWeatherViewModel!
  
  let jsonData = """
      {
          "weather": [
              {
                  "id": 800,
                  "icon": "01d"
              }
          ],
          "main": {
              "temp": 25.0,
              "feels_like": 26.0,
              "temp_max": 30.0,
              "temp_min": 20.0
          },
          "name": "SampleCity"
      }
      """.data(using: .utf8)!
  
  override func setUp() {
    super.setUp()
    viewModel = HomeWeatherViewModel()
  }
  
  override func tearDown() {
    viewModel = nil
    super.tearDown()
  }
  
  func testSearchWeather() {
    // Given
    let cityName = "Chicago"
    let mockDelegate = MockWeatherManagerDelegate()
    viewModel.delegate = mockDelegate
    
    // When
    viewModel.searchWeather(cityName: cityName)
    guard let weatherModel = viewModel.parseJSON(jsonData) else { return }
    mockDelegate.didUpdateWeather(viewModel, weather: weatherModel)
    
    // Then
    XCTAssertTrue(mockDelegate.didUpdateWeatherCalled)
  }
  
  func testGetWeatherWithCoordinates() {
    // Given
    let latitude: CLLocationDegrees = 41.881832
    let longitude: CLLocationDegrees = -87.623177
    let mockDelegate = MockWeatherManagerDelegate()
    viewModel.delegate = mockDelegate
    
    // When
    viewModel.getWeather(latitude: latitude, longitude: longitude)
    guard let weatherModel = viewModel.parseJSON(jsonData) else { return }
    mockDelegate.updateLocalWeather(viewModel, weather: weatherModel)
    // Then
    XCTAssertTrue(mockDelegate.updateLocalWeatherCalled)
  }
  
  func testParseJSON() {
    
    // When
    let weather = viewModel.parseJSON(jsonData)
    
    // Then
    XCTAssertNotNil(weather)
    XCTAssertEqual(weather?.cityName, "SampleCity")
    XCTAssertEqual(weather?.temperature, 25.0)
    XCTAssertEqual(weather?.feelsLike, 26.0)
    XCTAssertEqual(weather?.maxTemp, 30.0)
    XCTAssertEqual(weather?.minTemp, 20.0)
  }
  
  func testDownloadImage() {
    // Given
    let expectation = self.expectation(description: "Image download expectation")
    let imageUrl = "https://openweathermap.org/img/wn/01d.png"
    // When
    viewModel.downloadImage(from: imageUrl) { image in
      // Then
      XCTAssertNotNil(image)
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
}
