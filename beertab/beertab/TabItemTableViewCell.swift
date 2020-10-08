//
//  TabItemTableViewCell.swift
//  beertab
//
//  Created by Michael Neilens on 05/10/2020.
//

import UIKit

class TabItemTableViewCell: UITableViewCell {

    @IBOutlet weak var brewer: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var quantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
