//
//  HourInfoView.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class HourInfoView: UIView {
    
    //MARK: - Properties
    
    private let model: EveryThreeHoursForecastDataModel

    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .center
        return label
    }()
    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    private lazy var imageSubstrateView: UIView = {
        let substrate = UIView()
        substrate.backgroundColor = .clear
        return substrate
    }()
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.tintColor = .customTextColor
        return imageView
    }()
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    private lazy var weatherImageWidthConstraint: NSLayoutConstraint = {
        let constraint = weatherImageView.widthAnchor.constraint(equalToConstant: 0)
        return constraint
    }()
    private lazy var weatherImageHeightConstraint: NSLayoutConstraint = {
        let constraint = weatherImageView.heightAnchor.constraint(equalToConstant: 0)
        return constraint
    }()
    
    // MARK: - Init
    
    init(model: EveryThreeHoursForecastDataModel) {
        self.model = model
        super.init(frame: .zero)
        backgroundColor = .clear
        setupLayout()
        updateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    private func setupLayout() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        imageSubstrateView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dayLabel)
        addSubview(hourLabel)
        addSubview(imageSubstrateView)
        imageSubstrateView.addSubview(weatherImageView)
        addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            dayLabel.heightAnchor.constraint(equalToConstant: 14),
            
            hourLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 0),
            hourLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            hourLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            hourLabel.heightAnchor.constraint(equalToConstant: 14),
            
            imageSubstrateView.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 0),
            imageSubstrateView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageSubstrateView.widthAnchor.constraint(equalToConstant: 30),
            imageSubstrateView.heightAnchor.constraint(equalToConstant: 30),
            
            weatherImageView.centerXAnchor.constraint(equalTo: imageSubstrateView.centerXAnchor),
            weatherImageView.centerYAnchor.constraint(equalTo: imageSubstrateView.centerYAnchor),
            weatherImageWidthConstraint,
            weatherImageHeightConstraint,
            
            temperatureLabel.topAnchor.constraint(equalTo: imageSubstrateView.bottomAnchor, constant: 0),
            temperatureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 20),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
        ])
    }
    
    // MARK: - Actions
    
    private func updateViews() {
        hourLabel.text = model.time
        temperatureLabel.text = String(model.temperatureCurrent)
        RequestService().imageRequest(for: weatherImageView, iconID: model.iconID, completion: showWeatherImageAnimation)
        
        switch model.time {
        case "00:00", "01:00", "02:00":
            addLeftBorder(with: .customTextColor, andWidth: 1)
            dayLabel.text = model.day
        default:
            return
        }
    }
    
    private func showWeatherImageAnimation() {
        layoutIfNeeded()
        NSLayoutConstraint.deactivate([
            weatherImageWidthConstraint,
            weatherImageHeightConstraint,
        ])
        weatherImageWidthConstraint = self.weatherImageView.widthAnchor.constraint(equalToConstant: 30)
        weatherImageHeightConstraint = self.weatherImageView.heightAnchor.constraint(equalToConstant: 30)

        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: {
            NSLayoutConstraint.activate([
                self.weatherImageWidthConstraint,
                self.weatherImageHeightConstraint,
            ])
            self.layoutIfNeeded()
        },
                       completion: nil)
    }
}
