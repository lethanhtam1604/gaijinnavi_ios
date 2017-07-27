//
//  NotificationTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/19/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift
import Kingfisher

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var masterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconBtn.imageView?.contentMode = .scaleAspectFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func bindData(data: NotificationResult) {
        
        if (data.SeenFlag == 0){
            masterView.backgroundColor = Global.colorUnSeen
        }
        else {
            masterView.backgroundColor = UIColor.white
        }
        
        if (Utils.verifyUrl(urlString: data.Avatar)) {
            iconBtn.kf.setImage(with: URL(string: data.Avatar), for: .normal)
        }
        else {
            iconBtn.setImage(UIImage(named: "ic_user"), for: .normal)
        }
        
        let attrString:NSAttributedString!
        if data.PostType == 1 {
            attrString = NSAttributedString(string: "had_post_school".localized())
        }
        else {
            attrString = NSAttributedString(string: "had_post_news".localized())
        }
        
        let myString = data.UserName
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Arial-BoldMT", size: 14.0)! ]
        let myAttrString = NSMutableAttributedString(string: " \(myString) ", attributes: myAttribute)
        myAttrString.append(attrString)
        let attrString1 = NSAttributedString(string: " \(data.PostDetail.Title)", attributes: myAttribute)
        myAttrString.append(attrString1)
        contentLabel.attributedText = myAttrString
        if data.PostDetail.Id > 0 {
            timeLabel.isHidden = false
            
            if let date = Utils.stringtoDate(string: data.PostDetail.created_time) {
                timeLabel.text = NSDate().timeElapsed(date, local: Localize.currentLanguage())
            }
        }
        else {
            timeLabel.isHidden = true
        }
        
    }
    
}
