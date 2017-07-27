//
//  MessageTableViewCell.swift
//  Education Platform
//
//  Created by nquan on 12/8/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
//import Parse
import JSQMessagesViewController
import Kingfisher
import Localize_Swift

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recentChat: UILabel!
    @IBOutlet weak var dateChat: UILabel!
    @IBOutlet weak var titleChat: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateChat.textColor = Global.colorMain
        self.imageUser.kf.indicatorType = .activity
        
        self.imageUser.layer.cornerRadius = self.imageUser.frame.size.width / 2
        self.imageUser.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindingData(data : GroupResult, userId: Int) {
        let count = data.UnSeen
        let Users = data.Users
        var tempUser = ChatUserResult()
        
        for user in Users{
            if (Int(user.Id) != userId){
                tempUser = user }
        }
        if(count > 0) {
            recentChat.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
            titleChat.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
            recentChat.textColor = UIColor.black
            titleChat.textColor = UIColor.black
        }
        else {
            recentChat.font = UIFont(name:"HelveticaNeue", size: 13.0)
            titleChat.font = UIFont(name:"HelveticaNeue", size: 16.0)
        }
        recentChat.text = data.LastMessage
        titleChat.text = tempUser.DisplayName
        
        if Utils.verifyUrl(urlString: tempUser.Avatar) {
            self.imageUser.kf.setImage(with: URL(string: tempUser.Avatar))
        }
        else{
            self.imageUser.image = UIImage(named: "ic_user")
        }
        
        if let date = Utils.stringtoDate(string: data.updated_time) {
            dateChat.text = NSDate().timeElapsed(date ,local: Localize.currentLanguage())
        }
    }
}
