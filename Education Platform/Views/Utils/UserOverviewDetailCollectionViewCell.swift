//
//  UserOverviewDetailCollectionViewCell.swift
//  Education Platform
//
//  Created by nquan on 12/15/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Kingfisher

class UserOverviewDetailCollectionViewCell: UITableViewCell {

    @IBOutlet weak var mainContent: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var number1: UILabel!
    @IBOutlet weak var number2: UILabel!
    @IBOutlet weak var number3: UILabel!
    
    @IBOutlet weak var imageN1: UIImageView!
    @IBOutlet weak var imageN2: UIImageView!
    @IBOutlet weak var imageN3: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainContent.backgroundColor = Global.colorCloud
        number1.textColor = Global.colorMain
        number2.textColor = Global.colorMain
        number3.textColor = Global.colorMain
        
        
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
        self.userImage.clipsToBounds = true;
        
        
        let iosthumbsOUpIcon = FAKFontAwesome.thumbsOUpIcon(withSize: 25)
        iosthumbsOUpIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let iosthumbsOUpImage  = iosthumbsOUpIcon?.image(with: CGSize(width: 25, height: 25))
        
        imageN1.image = iosthumbsOUpImage
        
        let iosheartOIcon = FAKFontAwesome.heartOIcon(withSize: 25)
        iosheartOIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let iosheartOImage  = iosheartOIcon?.image(with: CGSize(width: 25, height: 25))
        
        imageN2.image = iosheartOImage

        
        let iosarrowUpIcon = FAKFontAwesome.arrowUpIcon(withSize: 25)
        iosarrowUpIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let arrowUpImage  = iosarrowUpIcon?.image(with: CGSize(width: 25, height: 25))

        imageN3.image = arrowUpImage
    }
    
    func bindingFromData(data: [String:String])
    {
        
        let fullName = data["fullname"]
        let username = data["userName"]
        
        userEmail.text = username
        userName.text = fullName
        if  Utils.verifyUrl(urlString: data["image"])
        {
         userImage.kf.setImage(with: URL(string: data["image"]!))
        }
        else {
         userImage.image = UIImage(named: "ic_user")
        }
    
    }
    
}
