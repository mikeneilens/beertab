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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
