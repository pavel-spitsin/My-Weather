//
//  DayInfoView.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class DayInfoView: UIView {
    
    //MARK: - Properties
    
    private let model: FiveDaysForecastDataModel
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .left
        return label
    }()
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.tintColor = .customTextColor
        return imageView
    }()
    private lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .right
        return label
    }()
    private lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Init
    
    init(model: FiveDaysForecastDataModel) {
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
        addSubview(dayLabel)
        addSubview(weatherImageView)
        addSubview(maxTemperatureLabel)
        addSubview(minTemperatureLabel)

        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor),
            dayLabel.heightAnchor.constraint(equalToConstant: 40),
            
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 30),
            weatherImageView.heightAnchor.constraint(equalToConstant: 30),
            
            minTemperatureLabel.topAnchor.constraint(equalTo: topAnchor),
            minTemperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            minTemperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            minTemperatureLabel.widthAnchor.constraint(equalToConstant: 50),
            
            maxTemperatureLabel.topAnchor.constraint(equalTo: topAnchor),
            maxTemperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.leadingAnchor),
            maxTemperatureLabel.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Actions
    
    private func updateViews() {
        dayLabel.text = model.day
        maxTemperatureLabel.text = String(model.temperatureMax)
        minTemperatureLabel.text = String(model.temperatureMin)
        RequestService().imageRequest(for: weatherImageView, iconID: model.iconID, completion: nil)
    }
}
