//
//  EveryThreeHoursInfoView.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class EveryThreeHoursInfoView: UIView {
    
    //MARK: - Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        addTopBorder(with: .customTextColor, andHeight: 1)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
    
    public func createCards(data: [EveryThreeHoursForecastDataModel]) {
        data.forEach {
            let hourView = HourInfoView(model: $0)
            hourView.translatesAutoresizingMaskIntoConstraints = true
            hourView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            hourView.heightAnchor.constraint(equalToConstant: 110).isActive = true
            stackView.addArrangedSubview(hourView)
        }
    }
}
