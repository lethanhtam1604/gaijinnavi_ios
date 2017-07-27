//
//  GrantAccessTableViewCell.swift
//  Education Platform
//
//  Created by nquan on 12/29/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import Kingfisher

class GrantAccessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deleteRequestBtn: UIButton!
    @IBOutlet weak var confirmRequestBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImage.kf.indicatorType = .activity
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        self.userImage.clipsToBounds = true
        self.userImage.contentMode = .scaleAspectFill
        
        confirmRequestBtn.setTitleColor(UIColor.white, for: .normal)
        confirmRequestBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        confirmRequestBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        confirmRequestBtn.titleLabel?.font = UIFont(name: (confirmRequestBtn.titleLabel?.font.fontName)!, size: 12)
        confirmRequestBtn.layer.cornerRadius = 5
        confirmRequestBtn.clipsToBounds = true
        confirmRequestBtn.backgroundColor = Global.colorFollow
        
        deleteRequestBtn.setTitleColor(UIColor.white, for: .normal)
        deleteRequestBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        deleteRequestBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        deleteRequestBtn.titleLabel?.font = UIFont(name: (deleteRequestBtn.titleLabel?.font.fontName)!, size: 12)
        deleteRequestBtn.layer.cornerRadius = 5
        deleteRequestBtn.clipsToBounds = true
        deleteRequestBtn.backgroundColor = Global.colorFollow
    
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            userImage.autoSetDimensions(to: CGSize(width: 60, height: 60))
            userImage.layer.cornerRadius = 30
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingFromData(user : ChatUserResult) {
        confirmRequestBtn.setTitle("confirm".localized(), for: .normal)
        deleteRequestBtn.setTitle("delete".localized(), for: .normal)
        userName.text = user.DisplayName
        userEmail.text = user.Email
        
        if Utils.verifyUrl(urlString: user.Avatar) {
            self.userImage.kf.setImage(with: URL(string: user.Avatar))
        }
        else {
            self.userImage.image = UIImage(named: "ic_user")
        }
    }
}
