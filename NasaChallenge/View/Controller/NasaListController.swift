//
//  NasaListController.swift
//  NasaChallenge
//
//  Created by Zakhia Damaree on 19/08/2021.
//  Copyright © 2021 Zakhia Damaree. All rights reserved.
//

import UIKit
import Combine

class NasaListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    static let identifier = "NasaListController"
    let viewModel = NasaListViewModel()
    let segueDetail = "SegueDetail"
    var cancellables: [AnyCancellable] = []
    
    private let spinner = UIActivityIndicatorView(style: .large)
    private var alertController: UIAlertController?
    
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewModel.items.count == 0 {
            showSpinner()
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        viewModel.networkManager.delegate = self
        title = NSLocalizedString("nasa.list.title", comment: "")
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 112
        tableView.rowHeight = UITableView.automaticDimension
        
        let nasaItemCellNib = UINib(nibName: NasaItemCell.identifier, bundle: nil)
        tableView.register(nasaItemCellNib, forCellReuseIdentifier: NasaItemCell.identifier)
    }
    
    private func loadItems() {
        viewModel.fetchItems()
        
        viewModel.$errorMessage.sink { [weak self] message in
            if let errorMessage = message {
                self?.showAlertNetworkError(message: errorMessage)
            }
        }.store(in: &cancellables)
        
        viewModel.$_items.sink { [weak self] items in
            if items.count > 0 {
                self?.hideAlert()
                let filteredItems = items.filter { !($0.data[0].name?.isEmpty ?? true) }
                self?.viewModel.items = filteredItems
                self?.tableView.reloadData()
                self?.hideSpinner()
            }
        }.store(in: &cancellables)
    }
    
    // MARK: - Spinner
    
    private func showSpinner() {
        let tableViewFrame = tableView.bounds
        var spinnerFrame = spinner.bounds
        
        spinnerFrame.origin.x = tableViewFrame.size.width/2 - spinnerFrame.size.width/2
        spinnerFrame.origin.y = tableViewFrame.size.height/2 - spinnerFrame.size.width/2
        
        spinner.frame = spinnerFrame
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        tableView.addSubview(spinner)
    }
    
    private func hideSpinner() {
        DispatchQueue.main.async {
            if self.spinner.isAnimating {
                self.spinner.stopAnimating()
            }
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueDetail,
           let nasaDetailController = segue.destination as? NasaDetailController,
           let item = sender as? NasaItem.Item {
            nasaDetailController.item = item
        }
    }
    
    // MARK: - Alert
    
    fileprivate func showAlertNetworkError(message: String) {
        alertController = UIAlertController(title: Util.localizedString("network.error.title"), message: message, preferredStyle: .alert)
        
        guard let alertController = self.alertController
        else { return }
        
        let retryAction = UIAlertAction(title: NSLocalizedString("network.error.retry", comment: ""), style: .default) { _ in
            self.alertController?.dismiss(animated: true, completion: nil)
            self.spinner.startAnimating()
            self.loadItems()
        }
        
        alertController.addAction(retryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func hideAlert() {
        DispatchQueue.main.async {
            self.alertController?.dismiss(animated: true, completion: nil)
        }
    }

}

// MARK: - NetworkManagerDelegate

extension NasaListController: NetworkManagerDelegate {
    func taskIsWaitingForConnectivity() {
        hideAlert()
        hideSpinner()
        showAlertNetworkError(message: Util.localizedString("network.error.message.no.connection"))
    }
}
