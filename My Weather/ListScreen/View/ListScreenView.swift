//
//  ListScreenView.swift
//  My Weather
//
//  Created by Pavel
//

import UIKit

class ListScreenView: BaseViewController {

    //MARK: - Properties
    
    private let openSearchAction: () -> Void
    private let updatePageViewControllerWithIndex: (Int) -> Void
    private let updatePageViewControllerCityOrder: (Int) -> Void
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListViewCell.self, forCellReuseIdentifier: "ListViewCell")
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.dropDelegate = self
        return tableView
    }()
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: view.frame.height - 140,
                                              width: view.frame.width,
                                              height: 140))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        let addItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .done,
                                     target: self,
                                     action: #selector(openSearchViewAction))
        addItem.tintColor = .customTextColor
        toolBar.items = [flexibleSpace, addItem]
        toolBar.isTranslucent = false
        toolBar.barTintColor = view.backgroundColor
        toolBar.sizeToFit()
        toolBar.addTopBorder(with: .customTextColor, andHeight: 1)
        return toolBar
    }()
    
    // MARK: - Init
    
    init(openSearchAction: @escaping () -> Void,
         updatePageViewControllerWithIndex: @escaping (Int) -> Void,
         updatePageViewControllerCityOrder: @escaping (Int) -> Void) {
        self.openSearchAction = openSearchAction
        self.updatePageViewControllerWithIndex = updatePageViewControllerWithIndex
        self.updatePageViewControllerCityOrder = updatePageViewControllerCityOrder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    //MARK: - Layout
    
    private func setupLayout() {
        view.addSubview(toolBar)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            tableView.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
        ])
    }
    
    private func makeDragAndDropCellBackgroundInviseble(indexPath: IndexPath) -> UIDragPreviewParameters? {
        let cell = tableView.cellForRow(at: indexPath) as! ListViewCell
        let previewParameters = UIDragPreviewParameters()
        let path = UIBezierPath(roundedRect: cell.dragShadowRect, cornerRadius: 10.0)
        previewParameters.visiblePath = path
        previewParameters.backgroundColor = .clear
        return previewParameters
    }
    
    //MARK: - Actions

    @objc private func openSearchViewAction() {
        dismiss(animated: true) { [self] in
            self.openSearchAction()
        }
    }
}

    //MARK: - Extensions

//MARK: - UITableViewDataSource

extension ListScreenView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SaveLoadService.shared.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as? ListViewCell else {
            return UITableViewCell()
        }
        cell.index = indexPath.row
        cell.viewModel = ListViewCellViewModel(city: SaveLoadService.shared.cities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        indexPath.row != 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.row != 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            SaveLoadService.shared.cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

//MARK: - UITableViewDelegate

extension ListScreenView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = SaveLoadService.shared.cities.remove(at: sourceIndexPath.row)
        SaveLoadService.shared.cities.insert(mover, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            SaveLoadService.shared.cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.updatePageViewControllerCityOrder(0)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [self] in
            self.updatePageViewControllerWithIndex(indexPath.row)
        }
    }
}

//MARK: - UITableViewDragDelegate

extension ListScreenView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = SaveLoadService.shared.cities[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        makeDragAndDropCellBackgroundInviseble(indexPath: indexPath)
    }
}

//MARK: - UITableViewDropDelegate

extension ListScreenView: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        return
    }
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        updatePageViewControllerCityOrder(indexPath.row)
        return makeDragAndDropCellBackgroundInviseble(indexPath: indexPath)
    }
}
