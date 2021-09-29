//
//  TabTableViewCell.swift
//  beertab
//
//  Created by Michael Neilens on 06/10/2020.
//

import UIKit

class Tab2TableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pubName: UILabel!
    @IBOutlet weak var total: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setNameAndTotal(name:String, pubName:String, total:String) {
        guard let nameLabel = self.name, let pubNameLabel = self.pubName, let totalLabel = self.total else {return}
        nameLabel.text = name
        pubNameLabel.text = pubName
        totalLabel.text = total
    }
}
