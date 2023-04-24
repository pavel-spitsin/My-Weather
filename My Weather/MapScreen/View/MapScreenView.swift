//
//  MapScreenView.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation
import MapKit
import CoreLocation
import Combine

class MapScreenView: BaseViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Properties
    
    private var viewModel: MapScreenViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsCompass = false
         
        //TODO: - Replace
        if #available(iOS 16.0, *) {
            map.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: .realistic)
        } else {
            map.mapType = .satellite
        }
        return map
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBackgroundColor
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.customTextColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return button
    }()
    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBackgroundColor
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.tintColor = .customTextColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(currentLocationAction), for: .touchUpInside)
        return button
    }()
    private lazy var cityListButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBackgroundColor
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.tintColor = .customTextColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(cityListAction), for: .touchUpInside)
        return button
    }()
    private lazy var mapLayersButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBackgroundColor
        button.setImage(UIImage(systemName: "square.3.layers.3d"), for: .normal)
        button.tintColor = .customTextColor
        button.layer.cornerRadius = 8
        button.showsMenuAsPrimaryAction = true
        button.menu = setupLayersMenu()
        return button
    }()
    
    //MARK: - Init
    
    init(viewModel: MapScreenViewModel) {
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
        setupLayout()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        mapView.centerToLocation(CLLocation(latitude: 56.33376, longitude: 43.93227))
    }
    
    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(mapView)
        view.addSubview(doneButton)
        view.addSubview(currentLocationButton)
        view.addSubview(cityListButton)
        view.addSubview(mapLayersButton)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        cityListButton.translatesAutoresizingMaskIntoConstraints = false
        mapLayersButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            doneButton.widthAnchor.constraint(equalToConstant: 80),
            
            currentLocationButton.topAnchor.constraint(equalTo: doneButton.topAnchor),
            currentLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            currentLocationButton.heightAnchor.constraint(equalTo: doneButton.heightAnchor),
            currentLocationButton.widthAnchor.constraint(equalTo: currentLocationButton.heightAnchor),
            
            cityListButton.topAnchor.constraint(equalTo: currentLocationButton.bottomAnchor, constant: 4),
            cityListButton.trailingAnchor.constraint(equalTo: currentLocationButton.trailingAnchor),
            cityListButton.heightAnchor.constraint(equalTo: currentLocationButton.heightAnchor),
            cityListButton.widthAnchor.constraint(equalTo: cityListButton.heightAnchor),
            
            mapLayersButton.topAnchor.constraint(equalTo: cityListButton.bottomAnchor, constant: 4),
            mapLayersButton.trailingAnchor.constraint(equalTo: currentLocationButton.trailingAnchor),
            mapLayersButton.heightAnchor.constraint(equalTo: currentLocationButton.heightAnchor),
            mapLayersButton.widthAnchor.constraint(equalTo: mapLayersButton.heightAnchor),
        ])
    }
    
    private func setupLayersMenu() -> UIMenu {
        let scheme = UIAction(title: "Scheme") { _ in
            self.displaySchemeLayer()
        }
        let satellite = UIAction(title: "Satellite") { _ in
            self.displaySatelliteLayer()
        }
        let hybrid = UIAction(title: "Hybrid") { _ in
            self.displayHybridLayer()
        }
        let mapLayersMenu = UIMenu(title: "Layers", children: [scheme, satellite, hybrid])
        return mapLayersMenu
    }
    
    //MARK: - Actions
    
    @objc private func doneAction() {
        dismiss(animated: true)
    }
    
    @objc private func currentLocationAction() {
        mapView.centerToLocation(CLLocation(latitude: 56.33376, longitude: 43.93227))
    }
    
    @objc private func cityListAction() {
        dismiss(animated: true)
    }
    
    private func displaySchemeLayer() {
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .flat)
        } else {
            mapView.mapType = .standard
        }
    }
    
    private func displaySatelliteLayer() {
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKImageryMapConfiguration(elevationStyle: .realistic)
        } else {
            mapView.mapType = .satellite
        }
    }
    
    private func displayHybridLayer() {
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: .realistic)
        } else {
            mapView.mapType = .hybrid
        }
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}

extension MapScreenView: MKMapViewDelegate {
}



private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 3000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
