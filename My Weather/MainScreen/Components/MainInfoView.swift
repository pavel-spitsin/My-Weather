//
//  MainInfoView.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class MainInfoView: UIView {
    
    //MARK: - Properties
    
    private lazy var locationSubstrateView: UIView = {
        let substrate = UIView()
        substrate.backgroundColor = .clear
        return substrate
    }()
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = .init(systemName: "location.fill")
        imageView.tintColor = .customTextColor
        return imageView
    }()
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 40, weight: .thin)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .center
        label.text = "-"
        return label
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
        label.font = .systemFont(ofSize: 200, weight: .thin)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    private lazy var locationImageWidthConstraint: NSLayoutConstraint = {
        let constraint = locationImageView.widthAnchor.constraint(equalToConstant: 0)
        return constraint
    }()
    private lazy var locationImageHeightConstraint: NSLayoutConstraint = {
        let constraint = locationImageView.heightAnchor.constraint(equalToConstant: 0)
        return constraint
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    private func setupLayout() {
        locationSubstrateView.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(locationSubstrateView)
        locationSubstrateView.addSubview(locationImageView)
        addSubview(cityNameLabel)
        addSubview(weatherDescriptionLabel)
        addSubview(weatherImageView)
        addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            locationSubstrateView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            locationSubstrateView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            locationSubstrateView.widthAnchor.constraint(equalToConstant: 40),
            locationSubstrateView.heightAnchor.constraint(equalToConstant: 40),
            
            locationImageWidthConstraint,
            locationImageHeightConstraint,
            locationImageView.centerXAnchor.constraint(equalTo: locationSubstrateView.centerXAnchor),
            locationImageView.centerYAnchor.constraint(equalTo: locationSubstrateView.centerYAnchor),
            
            cityNameLabel.topAnchor.constraint(equalTo: locationSubstrateView.bottomAnchor, constant: 0),
            cityNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            cityNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            cityNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            weatherDescriptionLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 0),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            weatherDescriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            weatherImageView.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 0),
            weatherImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 40),
            weatherImageView.heightAnchor.constraint(equalToConstant: 40),
            
            temperatureLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 0),
            temperatureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 100),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
    
    // MARK: - Actions
    
    public func updateViewsData(data: CurrentWeatherDataModel) {
        cityNameLabel.text = data.cityName
        weatherDescriptionLabel.text = data.weatherDescription
        temperatureLabel.text = data.currentTemperature + "°C"
        RequestService().imageRequest(for: weatherImageView, iconID: data.iconID, completion: nil)
    }
    
    public func showArrowAnimation() {
        layoutIfNeeded()
        NSLayoutConstraint.deactivate([
            locationImageWidthConstraint,
            locationImageHeightConstraint,
        ])
        locationImageWidthConstraint = self.locationImageView.widthAnchor.constraint(equalToConstant: 40)
        locationImageHeightConstraint = self.locationImageView.heightAnchor.constraint(equalToConstant: 40)
        
        UIView.animate(withDuration: 1.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseInOut,
                       animations: {
            NSLayoutConstraint.activate([
                self.locationImageWidthConstraint,
                self.locationImageHeightConstraint,
            ])
            self.layoutIfNeeded()
            self.locationImageView.transform = CGAffineTransform.init(rotationAngle: 0)
            self.locationImageView.transform = CGAffineTransform.init(rotationAngle: Double.pi)
            self.locationImageView.transform = CGAffineTransform.init(rotationAngle: 0)
        },
                       completion: nil)
    }
    
    public func hideArrow() {
        NSLayoutConstraint.deactivate([
            locationImageWidthConstraint,
            locationImageHeightConstraint,
        ])
        locationImageWidthConstraint = self.locationImageView.widthAnchor.constraint(equalToConstant: 0)
        locationImageHeightConstraint = self.locationImageView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            self.locationImageWidthConstraint,
            self.locationImageHeightConstraint,
        ])
    }
}
