//
//  NasaListController+TableView.swift
//  NasaChallenge
//
//  Created by Zakhia Damaree on 23/08/2021.
//  Copyright © 2021 Zakhia Damaree. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource

extension NasaListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NasaItemCell.identifier, for: indexPath) as? NasaItemCell
        else { return UITableViewCell() }
        
        let item = viewModel.items[indexPath.row]
        let dataItem = viewModel.items[indexPath.row].data[0]
        cell.configure(dataItem)
        
        let imageThumbUrlString = item.links[0].href.replacingOccurrences(of: " ", with: "%20")
        
        if let imageThumbUrl = NSURL(string: imageThumbUrlString),
           let image = ImageCache.shared.getImage(url: imageThumbUrl) {
            cell.imgNasa.image = image
        } else {
            viewModel.imageDownloader.downloadThumbnailImageFromUrlString(imageThumbUrlString)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        let _ = NetworkError.getMessageForError(error)
                    case .finished:
                        Util.log("Thumbnail image downloaded")
                    }
                } receiveValue: { image in
                    if let visibleCell = tableView.cellForRow(at: indexPath) as? NasaItemCell {
                        visibleCell.imgNasa.image = image
                    }
                }.store(in: &cancellables)
    }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NasaListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]
        performSegue(withIdentifier: segueDetail, sender: item)
    }
}
