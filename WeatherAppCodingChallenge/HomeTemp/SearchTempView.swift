import Foundation
import UIKit

class SearchTempView: UIView {
  
  let locationTitle = UILabel()
  let tempLabel = UILabel()
  let weatherImage = UIImageView()
  let descriptionLabel = UILabel()
  let horizontalStackView = UIStackView()
  let lowTemp = UILabel()
  let highTemp = UILabel()
  let explanationLabel = UILabel()
  
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
    locationTitle.text = weather.cityName
    tempLabel.text = "\(weather.temperatureString)°F"
    highTemp.text = NSLocalizedString(" high \(weather.maxTempString)°F",
                                      comment: "high temp")
    lowTemp.text = NSLocalizedString("low \(weather.minTempString)°F / ",
                                     comment: "high temp")
    explanationLabel.text = NSLocalizedString("Search a city's weather",
                                              comment: "high temp")
  }
  
  func setConstraints() {
    addSubview(locationTitle)
    addSubview(weatherImage)
    addSubview(tempLabel)
    addSubview(descriptionLabel)
    horizontalStackView.addArrangedSubview(lowTemp)
    horizontalStackView.addArrangedSubview(highTemp)
    addSubview(horizontalStackView)
    addSubview(explanationLabel)
    
    locationTitle.translatesAutoresizingMaskIntoConstraints = false
    locationTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
    locationTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    locationTitle.bottomAnchor.constraint(equalTo: weatherImage.topAnchor, constant: -5).isActive = true
    
    weatherImage.translatesAutoresizingMaskIntoConstraints = false
    weatherImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    weatherImage.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -5).isActive = true
    
    tempLabel.translatesAutoresizingMaskIntoConstraints = false
    tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    tempLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -2).isActive = true
    
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    descriptionLabel.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor).isActive = true
    
    horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
    horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
    horizontalStackView.bottomAnchor.constraint(equalTo: explanationLabel.topAnchor, constant: -2).isActive = true
    
    explanationLabel.translatesAutoresizingMaskIntoConstraints = false
    explanationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    explanationLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  func setUIElements() {
    
    locationTitle.font = .systemFont(ofSize: 25, weight: .semibold)

    tempLabel.font = .systemFont(ofSize: 60, weight: .regular)
    
    descriptionLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    
    horizontalStackView.axis = .horizontal
    horizontalStackView.alignment = .center
    
    lowTemp.font = .systemFont(ofSize: 12, weight: .regular)
    
    highTemp.font = .systemFont(ofSize: 12, weight: .regular)
    
    explanationLabel.font = .systemFont(ofSize: 15, weight: .regular)
  }
}
