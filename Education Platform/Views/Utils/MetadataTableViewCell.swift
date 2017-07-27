//
//  MetadataTableViewCell.swift
//  Education Platform
//
//  Created by nquan on 12/16/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit

class MetadataTableViewCell: UITableViewCell {

    @IBOutlet weak var ContentMasterView: UIView!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        ContentMasterView.backgroundColor = Global.colorCloud
        mainView.backgroundColor = UIColor.white
        
        typeLabel.textColor = Global.colorMain
        // Configure the view for the selected state
    }
    
    func bindingfromData(data :String,type: String)
    {
        if  type == "email"
        {
            typeLabel.text = "EMAIL"
            if(data == "")
            {
            editTextField.placeholder = "swallow@citynow.vn"
            }
            else {
            editTextField.text = data
            }
        }
        else if type == "address"
        {
            typeLabel.text = "ADDRESS"
            if(data == "")
            {
                editTextField.placeholder = "298 Jump Street, LA, USA"
            }
            else {
            editTextField.text = data
            }
        }
        else if type == "phone"
        {
            typeLabel.text = "PHONE"
            if(data == "")
            {
                editTextField.placeholder = "+84 - 096969696969"
            }
            else {
            editTextField.text = data
            }
        }
        else if type == "dob"
        {
            typeLabel.text = "DOB"
            if(data == "")
            {
                editTextField.placeholder = "18/11/2016"
            }
            else {
            editTextField.text = data
            }
        }
    
    }
    
}
