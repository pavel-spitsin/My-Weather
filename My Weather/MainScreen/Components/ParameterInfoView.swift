//
//  ParameterInfoView.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class ParameterInfoView: UIView {
    
    //MARK: - Properties
    
    private let weatherParameter: WeatherParameter
    private lazy var parameterNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .right
        label.text = weatherParameter.rawValue + ":"
        return label
    }()
    private lazy var parameterValueLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .left
        label.text = "-"
        return label
    }()
    
    // MARK: - Init
    
    init(with parameter: WeatherParameter) {
        self.weatherParameter = parameter
        super.init(frame: .zero)
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    private func setupLayout() {
        addSubview(parameterNameLabel)
        addSubview(parameterValueLabel)

        parameterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        parameterValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            parameterNameLabel.topAnchor.constraint(equalTo: topAnchor),
            parameterNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            parameterNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            parameterNameLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -4),
            parameterNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            parameterValueLabel.topAnchor.constraint(equalTo: topAnchor),
            parameterValueLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 4),
            parameterValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            parameterValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    //MARK: - Actions
    
    public func updateParameterValue(data: CurrentWeatherDataModel) {
        parameterValueLabel.text = "-"
        parameterValueLabel.text = data.returnData(for: weatherParameter) + " " + weatherParameter.parameterUnit
    }
}

enum WeatherParameter: String, CaseIterable {
    case cloudiness = "Cloudiness"
    case humidity = "Humidity"
    case pressure = "Pressure"
    case maxTemperature = "Max. temperature"
    case minTemperature = "Min. temperature"
    case sunrise = "Sunrise"
    case sunset = "Sunset"
    case windDirection = "Wind direction"
    case windSpeed = "Wind speed"
    case visibility = "Visibility"
    
    var parameterUnit: String {
        switch self {
        case .cloudiness:
            return "%"
        case .humidity:
            return "%"
        case .pressure:
            return "mm Hg"
        case .maxTemperature:
            return "°C"
        case .minTemperature:
            return "°C"
        case .windSpeed:
            return "m/s"
        case .visibility:
            return "m"
        default:
            return ""
        }
    }
}
