//
//  ListViewCell.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation
import UIKit
import Combine

class ListViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = String(describing: ListViewCell.self)
    var index: Int? {
        didSet {
            guard index == 0 else { return }
            myLocationLabel.isHidden = false
        }
    }
    var viewModel: ListViewCellViewModel? {
        didSet {
            setupBindings()
        }
    }
    private var cancelBag = Set<AnyCancellable>()
    
    public lazy var dragShadowRect: CGRect = {
        let rect = substrateView.frame
        return rect
    }()
    private lazy var substrateView: UIView = {
        let substrate = UIView()
        substrate.backgroundColor = .systemGray2
        substrate.layer.cornerRadius = 10
        return substrate
    }()
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 60, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .left
        label.text = "-"
        return label
    }()
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .left
        label.text = "-"
        return label
    }()
    private lazy var myLocationLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .left
        label.isHidden = true
        label.text = "My Location"
        return label
    }()
    public lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 60, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .right
        return label
    }()
    private lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .right
        label.text = "-"
        return label
    }()
    private lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .right
        label.text = "-"
        return label
    }()

    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityNameLabel.text = "-"
        weatherDescriptionLabel.text = "-"
        currentTemperatureLabel.text = "-"
        maxTemperatureLabel.text = ""
        minTemperatureLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Layout
    
    private func configureComponents() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }
    
    private func setupLayout() {
        substrateView.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        myLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(substrateView)
        substrateView.addSubview(cityNameLabel)
        substrateView.addSubview(weatherDescriptionLabel)
        substrateView.addSubview(myLocationLabel)
        substrateView.addSubview(currentTemperatureLabel)
        substrateView.addSubview(maxTemperatureLabel)
        substrateView.addSubview(minTemperatureLabel)
        
        NSLayoutConstraint.activate([
            substrateView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            substrateView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            substrateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            substrateView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            cityNameLabel.topAnchor.constraint(equalTo: substrateView.topAnchor, constant: 8),
            cityNameLabel.leadingAnchor.constraint(equalTo: substrateView.leadingAnchor, constant: 8),
            cityNameLabel.trailingAnchor.constraint(equalTo: currentTemperatureLabel.leadingAnchor),
            cityNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            weatherDescriptionLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: cityNameLabel.leadingAnchor),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: currentTemperatureLabel.leadingAnchor),
            weatherDescriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            myLocationLabel.leadingAnchor.constraint(equalTo: cityNameLabel.leadingAnchor),
            myLocationLabel.trailingAnchor.constraint(equalTo: maxTemperatureLabel.leadingAnchor),
            myLocationLabel.heightAnchor.constraint(equalTo: minTemperatureLabel.heightAnchor),
            myLocationLabel.bottomAnchor.constraint(equalTo: minTemperatureLabel.bottomAnchor),
            
            currentTemperatureLabel.topAnchor.constraint(equalTo: substrateView.topAnchor, constant: 8),
            currentTemperatureLabel.trailingAnchor.constraint(equalTo: substrateView.trailingAnchor, constant: -8),
            currentTemperatureLabel.heightAnchor.constraint(equalToConstant: 60),
            currentTemperatureLabel.widthAnchor.constraint(equalToConstant: 100),
            
            minTemperatureLabel.trailingAnchor.constraint(equalTo: substrateView.trailingAnchor, constant: -8),
            minTemperatureLabel.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor),
            minTemperatureLabel.widthAnchor.constraint(equalToConstant: 50),
            minTemperatureLabel.heightAnchor.constraint(equalToConstant: 24),
            minTemperatureLabel.bottomAnchor.constraint(equalTo: substrateView.bottomAnchor, constant: -8),
            
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.leadingAnchor),
            maxTemperatureLabel.topAnchor.constraint(equalTo: minTemperatureLabel.topAnchor),
            maxTemperatureLabel.widthAnchor.constraint(equalToConstant: 50),
            maxTemperatureLabel.heightAnchor.constraint(equalTo: minTemperatureLabel.heightAnchor),
        ])
    }
    
    //MARK: - Bindings
    
    private func setupBindings() {
        viewModel?.$cellDataModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let data = $0 else { return }
                self?.cityNameLabel.text = data.cityName
                self?.weatherDescriptionLabel.text = data.weatherDescription
                self?.currentTemperatureLabel.text = String(data.temperatureCurrent) + "°"
                self?.minTemperatureLabel.text = String(data.temperatureMin) + "°"
                self?.maxTemperatureLabel.text = String(data.temperatureMax) + "°"
            }
            .store(in: &cancelBag)
    }
}
