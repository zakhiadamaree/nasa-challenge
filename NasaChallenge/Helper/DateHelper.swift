//
//  DateHelper.swift
//  NasaChallenge
//
//  Created by Zakhia Damaree on 19/08/2021.
//  Copyright © 2021 Zakhia Damaree. All rights reserved.
//

import Foundation

struct DateHelper {
    static let shared = DateHelper()
    
    private let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter
    }()
    
    private init() { }
    
    func formatToMediumDate(_ date: Date) -> String {
        return mediumDateFormatter.string(from: date)
    }
    
}
