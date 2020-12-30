//
//  TabItem2TableViewCell.swift
//  beertab
//
//  Created by Michael Neilens on 30/12/2020.
//

import UIKit

class TabItem2TableViewCell: UITableViewCell {

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
