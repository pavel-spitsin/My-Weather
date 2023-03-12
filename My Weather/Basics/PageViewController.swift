//
//  MyPageViewController.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class PageViewController: UIPageViewController {
    
    //MARK: - Properties
    
    private lazy var viewControllersArray: [UIViewController] = {
        var array = [MainScreenView]()
        SaveLoadService.shared.cities.forEach {
            let mainScreenView = MainScreenView(viewModel: MainScreenViewModel(city: $0))
            array.append(mainScreenView)
        }
        return array
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: view.frame.height - 70,
                                              width: view.frame.width,
                                              height: 70))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        let listItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                       style: .done,
                                       target: self,
                                       action: #selector(openCityListAction))
        listItem.tintColor = .customTextColor
        toolBar.items = [flexibleSpace, listItem]
        toolBar.isTranslucent = false
        toolBar.barTintColor = .customBackgroundColor
        toolBar.sizeToFit()
        toolBar.addTopBorder(with: .customTextColor, andHeight: 1)
        return toolBar
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = viewControllersArray.count
        pageControl.backgroundColor = .clear
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.currentPageIndicatorTintColor = .customCurrentPageIndicatorTintColor
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        dataSource = self
        delegate = self
        setupLayout()
        
        if let firstViewController = viewControllersArray.first {
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
        }
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.addSubview(toolBar)
        toolBar.addSubview(pageControl)

        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor),
        ])
    }
    
    //MARK: - Actions
    
    @objc private func openCityListAction() {
        let viewController = ListScreenView(openSearchAction: openSearchViewAction,
                                            updatePageViewControllerWithIndex: presentViewControllerWithIndex(index:),
                                            updatePageViewControllerCityOrder: updateCityOrder(andPresentPageWith:))
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }
        present(viewController, animated: true, completion: nil)
    }
    
    @objc private func openSearchViewAction() {
        let viewController = SearchScreenView(presentLastPage: updateCityOrder(andPresentPageWith:))
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }
        present(viewController, animated: true, completion: nil)
    }
    
    private func presentViewControllerWithIndex(index: Int) {
        pageControl.currentPage = index
        goToPageWithIndex(index: index)
    }
    
    private func goToPageWithIndex(index: Int) {
        let viewController = self.viewControllersArray[index]
        setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func updateCityOrder(andPresentPageWith index: Int) {
        var array = [MainScreenView]()
        SaveLoadService.shared.cities.forEach {
            let mainScreenView = MainScreenView(viewModel: MainScreenViewModel(city: $0))
            array.append(mainScreenView)
        }
        viewControllersArray = array
        pageControl.numberOfPages = viewControllersArray.count
        self.presentViewControllerWithIndex(index: index)
    }
}

    //MARK: - Extensions

//MARK: - Page ViewController Data Source

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersArray.firstIndex(of: viewController as! MainScreenView) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllersArray.count > previousIndex else { return nil }
        return viewControllersArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersArray.lastIndex(of: viewController as! MainScreenView) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = viewControllersArray.count
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        return viewControllersArray[nextIndex]
    }
}

//MARK: - Page ViewController Delegate

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?[0] else { return }
        guard let index = viewControllersArray.firstIndex(of: pageContentViewController) else { return }
        pageControl.currentPage = index
    }
}
