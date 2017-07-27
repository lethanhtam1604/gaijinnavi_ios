//
//  WaitingAcceptTableViewCell.swift
//  Education Platform
//
//  Created by nquan on 12/29/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import Kingfisher

class WaitingAcceptTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
//    @IBOutlet weak var waitingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImage.kf.indicatorType = .activity
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        self.userImage.clipsToBounds = true
        
//        waitingLabel.text = "requesting".localized()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func bindingfromData(user : ChatUserResult) {
        userNameLabel.text = user.DisplayName
        userEmail.text = user.Email
        
        if Utils.verifyUrl(urlString: user.Avatar) {
            self.userImage.kf.setImage(with: URL(string: user.Avatar))
        }
        else {
            self.userImage.image = UIImage(named: "ic_user")
        }
    }
}
