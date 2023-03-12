//
//  BaseViewController.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
