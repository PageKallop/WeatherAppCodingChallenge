import Foundation
import UIKit

class CurrentWeatherView: UIView {
  
  let titleLable = UILabel()
  private let currentWeatherStackView = UIStackView()
  private let currentTemp = UILabel()
  private let feelsLiketemp = UILabel()
  let weatherImage = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    setConstraints()
    setUIElements()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addValues(weather: WeatherModel) {
    titleLable.text = NSLocalizedString("Now in \(weather.cityName)",
                                        comment: "feels liketemp")
    currentTemp.text = NSLocalizedString("/ current temp \(weather.temperatureString) °F",
                                         comment: "feels liketemp")
    feelsLiketemp.text = NSLocalizedString("/ feels like \(weather.feelsLikeString)°F",
                                           comment: "feels liketemp")
  }
  
  func setConstraints() {
    addSubview(titleLable)
    addSubview(currentWeatherStackView)
    currentWeatherStackView.addArrangedSubview(weatherImage)
    currentWeatherStackView.addArrangedSubview(currentTemp)
    currentWeatherStackView.addArrangedSubview(feelsLiketemp)
    
    titleLable.translatesAutoresizingMaskIntoConstraints = false
    titleLable.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    titleLable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    titleLable.bottomAnchor.constraint(equalTo: currentWeatherStackView.topAnchor).isActive = true
    
    currentWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
    currentWeatherStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    currentWeatherStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    currentWeatherStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  func setUIElements() {
    currentWeatherStackView.axis = .horizontal
    currentWeatherStackView.spacing = 5
    currentWeatherStackView.alignment = .center
    
    titleLable.font = .systemFont(ofSize: 15, weight: .bold)
    currentTemp.font = .systemFont(ofSize: 12, weight: .regular)
    feelsLiketemp.font = .systemFont(ofSize: 12, weight: .regular)
  }
}
