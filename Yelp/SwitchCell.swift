//
//  SwitchCell.swift
//  Yelp
//
//  Created by Un on 10/21/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCellDidSwitchChanged(_ switchCell: SwitchCell, didValueChanged value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    weak var delegate: SwitchCellDelegate!
    
    @IBAction func onSwitchChanged(_ sender: UISwitch) {
        delegate?.switchCellDidSwitchChanged!(self, didValueChanged: sender.isOn)
    }

}
