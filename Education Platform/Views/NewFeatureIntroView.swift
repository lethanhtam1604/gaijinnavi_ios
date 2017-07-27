//
//  NewFeatureIntroView.swift
//  Education Platform
//
//  Created by nquan on 2/9/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit

class NewFeatureIntroView: UIView {
    
    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var featureImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        featureLabel.font = UIFont(name: "OpenSans-bold", size: 22)
    }
}
