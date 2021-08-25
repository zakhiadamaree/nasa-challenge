//
//  NasaItemCell.swift
//  NasaChallenge
//
//  Created by Zakhia Damaree on 19/08/2021.
//  Copyright © 2021 Zakhia Damaree. All rights reserved.
//

import UIKit

class NasaItemCell: UITableViewCell {
    @IBOutlet weak var imgNasa: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    static let identifier = "NasaItemCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ dataItem: NasaItem.DataItem) {
        imgNasa.image = nil
        lblTitle.text = Util.getText(dataItem.title ?? "")
        lblName.text = Util.getText(dataItem.name ?? "")
        lblDate.text = DateHelper.shared.formatToMediumDate(dataItem.dateCreated ?? Date())
    }
    
}
