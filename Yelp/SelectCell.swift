//
//  SelectCell.swift
//  Yelp
//
//  Created by Un on 10/21/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol SelectCellDelegate {
    @objc optional func selectCellDidCellSelected(_ selectCell: SelectCell)
}

class SelectCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate: SelectCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.image = #imageLiteral(resourceName: "uncheck-24")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if(delegate != nil){
            delegate?.selectCellDidCellSelected!(self)
        }
    }

}
