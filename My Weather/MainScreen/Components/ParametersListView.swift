//
//  ParametersListView.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class ParametersListView: UIView {
    
    //MARK: - Properties
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        addTopBorder(with: .customTextColor, andHeight: 1)
        createWeatherParameterViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    private func setupLayout() {
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func createWeatherParameterViews() {
        for parameter in WeatherParameter.allCases {
            let parameterInfoView = ParameterInfoView(with: parameter)
            stackView.addArrangedSubview(parameterInfoView)
        }
    }
    
    // MARK: - Actions
    
    public func updateViewsData(data: CurrentWeatherDataModel) {
        stackView.arrangedSubviews.forEach {
            guard let parameterInfoView = $0 as? ParameterInfoView else { return }
            parameterInfoView.updateParameterValue(data: data)
        }
    }
}


