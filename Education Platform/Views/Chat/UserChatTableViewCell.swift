  //
//  UserChatTableViewCell.swift
//  Education Platform
//
//  Created by nquan on 12/12/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import Kingfisher

class UserChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var activeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImage.kf.indicatorType = .activity
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        self.userImage.clipsToBounds = true
        
        self.activeImage.layer.cornerRadius = self.activeImage.frame.size.width / 2
        self.activeImage.clipsToBounds = true
    }
    
    
    func bindingData(user : ChatUserResult) {
        let activeUsers = WebSocketServices.shared.activeUsers
        
        if Utils.verifyUrl(urlString: user.Avatar) {
            self.userImage.kf.setImage(with: URL(string: user.Avatar))
        }
        else {
            self.userImage.image = UIImage(named: "ic_user")
        }
        
        userName.text = user.DisplayName
        userEmail.text = user.Email

        
        if activeUsers != nil && (activeUsers?.contains(user.Id))! {
            self.activeImage.backgroundColor = UIColor.green
        }
        else {
            self.activeImage.backgroundColor = UIColor.gray
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
