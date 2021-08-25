//
//  NasaDetailController.swift
//  NasaChallenge
//
//  Created by Zakhia Damaree on 19/08/2021.
//  Copyright © 2021 Zakhia Damaree. All rights reserved.
//

import UIKit
import Combine

class NasaDetailController: UITableViewController {
    @IBOutlet weak var imgNasa: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtVwDescription: UITextView!
    
    static let identifier = "NasaDetailController"
    
    var item: NasaItem.Item?
    
    private var dataItem: NasaItem.DataItem?
    private let viewModel = NasaDetailViewModel()
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        dataItem = item?.data[0]
        
        lblTitle.text = Util.getText(dataItem?.title ?? "")
        lblName.text = Util.getText(dataItem?.name ?? "")
        lblDate.text = DateHelper.shared.formatToMediumDate(dataItem?.dateCreated ?? Date())
        txtVwDescription.attributedText = getTextInParagraphStyle()
        
        configureTableView()
        fetchImage()
    }
    
    private func getTextInParagraphStyle() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: titleColor ?? .systemGray
        ]
        let attributedString = NSAttributedString(string: dataItem?.description ?? "", attributes: attributes)
        
        return attributedString
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = tableView.frame.height
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchImage() {
        if let imageCollectionUrl = item?.href {
            if let imageUrl = NSURL(string: imageCollectionUrl),
               let image = ImageCache.shared.getImage(url: imageUrl) {
                imgNasa.image = image
            } else {
                if let _ = UserDefaults.standard.value(forKey: imageCollectionUrl) {
                    let _ = NetworkError.getMessageForError(.originalImageUrlNotFound)
                } else {
                    downloadImageFromImageCollectionUrl(imageCollectionUrl)
                }
            }
        }
    }
    
    private func downloadImageFromImageCollectionUrl(_ imageCollectionUrl: String) {
        viewModel.fetchOriginalImageUrl(imageCollectionUrl: imageCollectionUrl)
        viewModel.$originalImageUrl.sink { originalImageUrl in
            if let originalImageUrl = originalImageUrl {
                self.viewModel.imageDownloader
                    .downloadOriginalImageFromUrlString(originalImageUrl, imageCollectionUrl: imageCollectionUrl)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            let _ = NetworkError.getMessageForError(error)
                            
                            switch error {
                            case .invalidImage:
                                Util.saveToUserDefault(imageCollectionUrl, value: 0)
                            default:
                                ()
                            }
                        case .finished:
                            Util.log("Original image downloaded")
                        }
                    } receiveValue: { [weak self] image in
                        self?.imgNasa.image = image
                    }.store(in: &self.cancellables)
            }
        }.store(in: &cancellables)
    }

}
