//
//  MainViewController.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit
import Combine

class MainScreenView: BaseViewController {
    
    //MARK: - Properties
    
    private var viewModel: MainScreenViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    private lazy var mainInfoView: MainInfoView = {
        let view = MainInfoView()
        return view
    }()
    private lazy var everyThreeHoursInfoView: EveryThreeHoursInfoView = {
        let view = EveryThreeHoursInfoView()
        return view
    }()
    private lazy var fiveDaysInfoView: FiveDaysInfoView = {
        let view = FiveDaysInfoView()
        return view
    }()
    private lazy var parametersListView: ParametersListView = {
        let view = ParametersListView()
        return view
    }()
    
    //MARK: - Init
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillStackView()
        setupLayout()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height + 40)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.city == "My location" {
            mainInfoView.showArrowAnimation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mainInfoView.hideArrow()
    }
    
    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(mainInfoView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        mainInfoView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: mainInfoView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    private func fillStackView() {
        stackView.addArrangedSubview(everyThreeHoursInfoView)
        stackView.addArrangedSubview(fiveDaysInfoView)
        stackView.addArrangedSubview(parametersListView)
    }
    
    //MARK: - Bindings
    
    private func setupBindings() {
        viewModel.$currentWeatherData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let data = $0 else { return }
                self?.mainInfoView.updateViewsData(data: data)
                self?.parametersListView.updateViewsData(data: data)
            }
            .store(in: &cancelBag)
        
        viewModel.$everyThreeHoursForecastData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let data = $0 else { return }
                self?.everyThreeHoursInfoView.createCards(data: data)
            }
            .store(in: &cancelBag)
        
        viewModel.$fiveDaysForecastData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let data = $0 else { return }
                self?.fiveDaysInfoView.createDayViews(data: data)
            }
            .store(in: &cancelBag)
    }
}
