//
//  LanguageTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/3/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit

class LanguageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let iosArrowForwardIcon = FAKIonIcons.iosCheckmarkEmptyIcon(withSize: 30)
        iosArrowForwardIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let iosArrowForwardImg = iosArrowForwardIcon?.image(with: CGSize(width: 30, height: 30))
        checkBtn.setImage(iosArrowForwardImg, for: .normal)
        checkBtn.tintColor = Global.colorMain
        checkBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
