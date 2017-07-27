//
//  GlobalServices.swift
//  Education Platform
//
//  Created by Duy Cao on 11/29/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import CoreData
class GlobalServices: NSObject {
    static var appDelegate = UIApplication.shared.delegate as! AppDelegate
//    static var utility = Utility()
    
    
    
    static func DefineProps(coredatacontext : NSManagedObjectContext){
        
        //UI
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: GlobalServices.primaryColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        UINavigationBar.appearance().tintColor = GlobalServices.primaryColor
        UITextField.appearance().tintColor = GlobalServices.primaryColor
    }
    
    
    //MARK: UI
    static var primaryColor = UIColor.init(red: 25.0/255, green: 148.0/255, blue: 252.0/255, alpha: 1.0)
}
