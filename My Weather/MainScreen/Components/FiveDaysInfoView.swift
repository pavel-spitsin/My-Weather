//
//  FiveDaysInfoView.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class FiveDaysInfoView: UIView {
    
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
    
    public func createDayViews(data: [FiveDaysForecastDataModel]) {
        data.forEach {
            guard $0.day != DateService().today() else { return }
            let dayView = DayInfoView(model: $0)
            stackView.addArrangedSubview(dayView)
        }
    }
}
