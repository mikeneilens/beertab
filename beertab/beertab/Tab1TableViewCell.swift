//
//  Tab2TableViewCell.swift
//  beertab
//
//  Created by Michael Neilens on 06/10/2020.
//

import UIKit

class Tab1TableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setNameAndTotal(name:String, pubName:String, total:String) {
        guard let nameLabel = self.name, let totalLabel = self.total else {return}
        nameLabel.text = name.isEmpty ? pubName : name
        totalLabel.text = total
    }
}
