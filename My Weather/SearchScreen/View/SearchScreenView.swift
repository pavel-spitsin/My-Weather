//
//  SearchScreenView.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class SearchScreenView: BaseViewController, UISheetPresentationControllerDelegate {
    
    //MARK: - Properties
    
    private let presentLastPage: (Int) -> Void

    private lazy var substrateView: UIView = {
        let substrate = UIView()
        substrate.backgroundColor = .systemGray2
        substrate.layer.cornerRadius = 10
        return substrate
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Enter city name"
        searchBar.tintColor = .customTextColor
        searchBar.delegate = self
        return searchBar
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.customTextColor, for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 40, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .customTextColor
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.customTextColor, for: .normal)
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Init
    
    init(presentLastPage: @escaping (Int) -> Void) {
        self.presentLastPage = presentLastPage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(substrateView)
        substrateView.addSubview(searchBar)
        substrateView.addSubview(cancelButton)
        substrateView.addSubview(resultLabel)
        substrateView.addSubview(addButton)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        substrateView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            substrateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            substrateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            substrateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        
            searchBar.topAnchor.constraint(equalTo: substrateView.topAnchor, constant: 4),
            searchBar.leadingAnchor.constraint(equalTo: substrateView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor),

            cancelButton.topAnchor.constraint(equalTo: searchBar.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: substrateView.trailingAnchor, constant: -4),
            cancelButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            
            resultLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: substrateView.leadingAnchor, constant: 8),
            resultLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor),
            resultLabel.heightAnchor.constraint(equalToConstant: 36),
            resultLabel.bottomAnchor.constraint(equalTo: substrateView.bottomAnchor, constant: -4),
            
            addButton.topAnchor.constraint(equalTo: resultLabel.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: resultLabel.bottomAnchor),
        ])
    }
    
    //MARK: - Actions
    
    @objc private func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addAction() {
        guard let city = searchBar.text else { return }
        SaveLoadService.shared.cities.append(city)
        dismiss(animated: true) {
            self.presentLastPage(SaveLoadService.shared.cities.endIndex - 1)
        }
    }
    
    private func updateResultLabelWithData(data: ([String : AnyObject]?)) {
        guard let city = data?["name"] as? String else {
            DispatchQueue.main.async {
                self.resultLabel.text = "City not found"
            }
            return
        }
        DispatchQueue.main.async {
            self.resultLabel.text = city
            self.addButton.isHidden = false
        }
    }
}

    //MARK: - Extensions

//MARK: - UISearchBarDelegate

extension SearchScreenView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let cityName = searchBar.text else { return }
        RequestService().requestCurrentWeatherByCityName(name: cityName, completionBlock: updateResultLabelWithData(data:))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.addButton.isHidden = true
    }
}
