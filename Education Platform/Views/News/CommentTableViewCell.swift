//
//  CommentTableViewCell.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/22/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Kingfisher
import Alamofire
import Localize_Swift

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorIconBtn: UIButton!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeNumberLabel: UILabel!
    
    var isLike = false
    var commentPost: CommentPost!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        authorIconBtn.imageView?.contentMode = .scaleAspectFill
        authorIconBtn.layer.cornerRadius = 20
        authorIconBtn.clipsToBounds = true
        
        let heartOIcon = FAKFontAwesome.heartOIcon(withSize: 25)
        heartOIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let heartOImg  = heartOIcon?.image(with: CGSize(width: 30, height: 30))
        likeBtn.setImage(heartOImg, for: .normal)
        likeBtn.tintColor = Global.colorMain
        likeBtn.addTarget(self, action: #selector(likeBtnClicked), for: .touchUpInside)
        likeBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func bindingData(currentUser: RoleResult) {
        if commentPost.Avatar != "" {
            authorIconBtn.kf.setImage(with: URL(string: commentPost.Avatar), for: .normal)
        }
        else {
            authorIconBtn.setImage(UIImage(named: "ic_user"), for: .normal)
        }
        
        self.isLike = false
        for item in commentPost.likes {
            if item.UserId == currentUser.User.Id {
                let heartIcon = FAKFontAwesome.heartIcon(withSize: 30)
                heartIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
                let heartImg  = heartIcon?.image(with: CGSize(width: 30, height: 30))
                self.likeBtn.setImage(heartImg, for: .normal)
                self.isLike = true
                break
            }
        }
        if !self.isLike {
            let heartOIcon = FAKFontAwesome.heartOIcon(withSize: 25)
            heartOIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
            let heartOImg  = heartOIcon?.image(with: CGSize(width: 30, height: 30))
            likeBtn.setImage(heartOImg, for: .normal)
            self.isLike = false
        }
        
        likeBtn.tag = currentUser.User.Id
        authorNameLabel.text = commentPost.DisplayName
        commentLabel.text = commentPost.comment.Content
        if let date = Utils.stringtoDate(string: commentPost.comment.created_time) {
            timeLabel.text = NSDate().timeElapsed(date, local: Localize.currentLanguage())
        }
        likeNumberLabel.text = String(commentPost.likes.count)
    }
    
    func likeBtnClicked(_ sender: UIButton) {
        if !isLike {
            SwiftOverlays.showBlockingWaitOverlay()
            CommentService.likeComment(commentId: commentPost.comment.Id, userId: sender.tag) { (success, message) in
                SwiftOverlays.removeAllBlockingOverlays()
                if success == true {
                    let heartIcon = FAKFontAwesome.heartIcon(withSize: 30)
                    heartIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
                    let heartImg  = heartIcon?.image(with: CGSize(width: 30, height: 30))
                    self.likeBtn.setImage(heartImg, for: .normal)
                    self.isLike = true
                    self.likeNumberLabel.text = String(self.commentPost.likes.count + 1)
                    let like = Like()
                    like.CommentId = self.commentPost.comment.Id
                    like.UserId = sender.tag
                    self.commentPost.likes.append(like)
                }
            }
        }
    }
}
