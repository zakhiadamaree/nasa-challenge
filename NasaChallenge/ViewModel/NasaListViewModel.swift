//
//  NasaListViewModel.swift
//  NasaChallenge
//
//  Created by Zakhia Damaree on 19/08/2021.
//  Copyright © 2021 Zakhia Damaree. All rights reserved.
//

import Foundation
import Combine

class NasaListViewModel: ObservableObject {
    let networkManager = NetworkManager()
    let imageDownloader = ImageDownloader()
    
    private var cancellable: AnyCancellable?
    @Published private(set) var _items: [NasaItem.Item] = []
    @Published private(set) var errorMessage: String? = nil
    
    var items = [NasaItem.Item]()
    
    func fetchItems() {
        cancellable = networkManager.fetchData(NasaItem.self, urlString: nasaListUrl)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = NetworkError.getMessageForError(error)
                case .finished:
                    Util.log("Nasa items received")
                }
            } receiveValue: { [weak self] nasaItem in
                self?._items = nasaItem.collection.items
            }
    }

}
