//
//  MenuView.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/9/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit

class MenuView: UIView {

    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        containView.layer.cornerRadius = 5
        
        titleLabel.font = UIFont(name: "OpenSans", size: 17)
        
        let iosArrowForwardIcon = FAKIonIcons.iosArrowForwardIcon(withSize: 25)
        iosArrowForwardIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let iosArrowForwardImg  = iosArrowForwardIcon?.image(with: CGSize(width: 25, height: 25))
        nextBtn.setImage(iosArrowForwardImg, for: .normal)
        nextBtn.tintColor = Global.colorGray
        nextBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
