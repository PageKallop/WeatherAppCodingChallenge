import UIKit
import CoreLocation

class HomeWeatherViewController: UIViewController, WeatherManagerDelegate {
  
  let locationManager = CLLocationManager()
  let viewModel: HomeWeatherViewModel
  let defaults = UserDefaults.standard
  let tableView = UITableView()
  
  let tempHeader = SearchTempView()
  let currentWeatherView = CurrentWeatherView()
  let horizontalStackView = UIStackView()
  let searchField = UITextField()
  let searchButton = UIButton()
  var lastSearchedCity = ""
  let cellID = "cellID"
  
  init(viewModel: HomeWeatherViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    checkForLastCity()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setConstraints()
    setElements()
    view.backgroundColor = .lightGray
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    viewModel.delegate = self
    searchField.delegate = self
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    defaults.set(lastSearchedCity, forKey: "City")
    print(lastSearchedCity)
  }
  
  func setConstraints() {
    
    view.addSubview(currentWeatherView)
    view.addSubview(tempHeader)
    horizontalStackView.addArrangedSubview(searchField)
    horizontalStackView.addArrangedSubview(searchButton)
    view.addSubview(horizontalStackView)
    
    currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
    currentWeatherView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
    currentWeatherView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    currentWeatherView.bottomAnchor.constraint(equalTo: tempHeader.topAnchor, constant: -10).isActive = true
    
    
    tempHeader.translatesAutoresizingMaskIntoConstraints = false
    tempHeader.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    tempHeader.heightAnchor.constraint(equalToConstant: 200).isActive = true
  
    horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    horizontalStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    horizontalStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -5).isActive = true
    
    searchField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    searchField.widthAnchor.constraint(equalToConstant: 200).isActive = true
    
    searchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    searchButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
  }
  
  
  func setElements() {
    
    horizontalStackView.axis = .horizontal
    horizontalStackView.alignment = .center
    horizontalStackView.spacing = 5

    searchField.backgroundColor = .white
    searchField.becomeFirstResponder()
    searchField.layer.cornerRadius = 8
    updateTextFieldTextColor()

    searchButton.backgroundColor = .gray
    searchButton.layer.cornerRadius = 8
    searchButton.setTitle(NSLocalizedString("Search", comment: ""), for: .normal)
    searchButton.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
  }
  
  func didUpdateWeather(_ weatherManager: HomeWeatherViewModel, weather: WeatherModel) {
    lastSearchedCity = weather.cityName
    viewModel.downloadImage(from: weather.iconUrl) { image in
      if let image = image {
        DispatchQueue.main.async {
          self.tempHeader.weatherImage.image = image
          self.tempHeader.addValues(weather: weather)
        }
      } else {
        DispatchQueue.main.async {
          self.currentWeatherView.addValues(weather: weather)
        }
      }
    }
  }
  
  func updateLocalWeather(_ weatherManager: HomeWeatherViewModel, weather: WeatherModel) {
    viewModel.downloadImage(from: weather.iconUrl) { image in
      if let image = image {
        DispatchQueue.main.async {
          self.currentWeatherView.weatherImage.image = image
          self.currentWeatherView.addValues(weather: weather)
        }
      } else {
        DispatchQueue.main.async {
          self.currentWeatherView.addValues(weather: weather)
        }
      }
    }
  }

  func checkForLastCity() {
    let launchCity = defaults.object(forKey: "City") as? String
    if launchCity?.isEmpty == true {
      return
    } else {
      let city = launchCity?.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "%20")
      viewModel.searchWeather(cityName: city ?? "")
    }
  }
}

// MARK: Set TextField Delegates
extension HomeWeatherViewController: UITextFieldDelegate {

  @objc func searchPressed(_ sender: UIButton) {
    searchField.endEditing(true)
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchField.endEditing(true)
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if searchField.text != "" {
      return true
    } else {
      searchField.placeholder = "Type a city"
      return false
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    let cityName = searchField.text
    let city = cityName!.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "%20")
    viewModel.searchWeather(cityName: city)
    searchField.text = ""
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}

// MARK: Set Location Manager
extension HomeWeatherViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      
      locationManager.stopUpdatingLocation()
      
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      viewModel.getWeather(latitude: lat, longitude: lon)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

// MARK: override dark mode text color
extension HomeWeatherViewController {
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      updateTextFieldTextColor()
    }
  }
  func updateTextFieldTextColor() {
      if traitCollection.userInterfaceStyle == .dark {
          searchField.textColor = UIColor.black
      } else {
        searchField.textColor = UIColor.black
      }
  }
}

