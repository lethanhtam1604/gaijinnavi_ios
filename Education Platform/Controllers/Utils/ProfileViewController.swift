//
//  ProfileViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/27/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import Localize_Swift
import FontAwesomeKit
import Alamofire
import STPopup
import INSPhotoGallery
import SwiftyJSON
import DropDown

class ProfileViewController: UIViewController, UITextFieldDelegate, FollowServiceDelegate, FollowUserDelegate, CameraDelegate, SSRadioButtonControllerDelegate, LocationDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var followedBtn: UIButton!
    @IBOutlet weak var iconProfileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var birthDateField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var nationality: UITextField!
    @IBOutlet weak var maleButton: SSRadioButton!
    @IBOutlet weak var femaleButton: SSRadioButton!
    @IBOutlet weak var nationalityView: UIView!
    @IBOutlet weak var numberPhoneCodeView: UIView!
    @IBOutlet weak var numberCodeLabel: UILabel!
    @IBOutlet weak var numberPhoneCodeBorder: UIView!
    @IBOutlet weak var phoneNumberCodeAbstractView: UIView!

    let phoneDropDown = DropDown()
    var phoneSource = ["84-", "81-", "86-"]
    var currentPhoneID = 0
    
    var radioButtonController: SSRadioButtonsController?
    var countryCode = CountryCode()
    
    var gender = 0
    
    let displayNameBorder = UIView()
    let accountBorder = UIView()
    let emailBorder = UIView()
    let phoneBorder = UIView()
    let birthDateBorder = UIView()
    let addressBorder = UIView()
    let descriptionBorder = UIView()
    let nationalityBorder = UIView()

    var constraintsAdded = false
    var user: RoleResult!
    var photos: [INSPhotoViewable] = [INSPhotoViewable]()
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Global.colorBg
        self.view.tintColor = UIColor.clear
        self.view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg
        
        view.addSubview(indicator)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = Global.colorBg
        containerView.backgroundColor = Global.colorBg
        user = UserDefaultManager.getInstance().getCurrentUser()
        
        followingBtn.setTitleColor(Global.colorGray, for: .normal)
        followingBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        followingBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        followingBtn.titleLabel?.font = UIFont(name: (followingBtn.titleLabel?.font.fontName)!, size: 14)
        followingBtn.clipsToBounds = true
        followingBtn.backgroundColor = UIColor.clear
        followingBtn.titleLabel?.lineBreakMode = .byWordWrapping
        followingBtn.titleLabel?.textAlignment = .center
        followingBtn.setTitle("0\n" + "following".localized(), for: .normal)
        followingBtn.addTarget(self, action: #selector(showUsersFollowing), for: .touchUpInside)
        
        followedBtn.setTitleColor(Global.colorGray, for: .normal)
        followedBtn.setTitleColor(Global.colorSecond, for: .highlighted)
        followedBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        followedBtn.titleLabel?.font = UIFont(name: (followedBtn.titleLabel?.font.fontName)!, size: 14)
        followedBtn.clipsToBounds = true
        followedBtn.backgroundColor = UIColor.clear
        followedBtn.titleLabel?.lineBreakMode = .byWordWrapping
        followedBtn.titleLabel?.textAlignment = .center
        followedBtn.setTitle("0\n" + "follower".localized(), for: .normal)
        followedBtn.addTarget(self, action: #selector(showUsersFollowed), for: .touchUpInside)
        
        updateBtn.setTitleColor(UIColor.white, for: .normal)
        updateBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        updateBtn.layer.cornerRadius = 5
        updateBtn.clipsToBounds = true
        updateBtn.addTarget(self, action: #selector(updateBtnClicked), for: .touchUpInside)
        updateBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        updateBtn.backgroundColor = Global.colorMain
        
        iconProfileImgView.layer.cornerRadius = 45
        iconProfileImgView.layer.borderColor = UIColor.white.cgColor
        iconProfileImgView.layer.borderWidth = 5
        iconProfileImgView.clipsToBounds = true
        iconProfileImgView.contentMode = .scaleAspectFill
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconProfileBtnClicked))
        iconProfileImgView.isUserInteractionEnabled = true
        iconProfileImgView.addGestureRecognizer(tapGestureRecognizer)
        
        errorLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        displayNameField.font = UIFont(name: "OpenSans", size: 17)
        displayNameField.delegate = self
        displayNameField.textColor = UIColor.black.withAlphaComponent(0.9)
        displayNameField.returnKeyType = .next
        displayNameField.keyboardType = .default
        displayNameField.inputAccessoryView = UIView()
        displayNameField.autocorrectionType = .no
        displayNameField.autocapitalizationType = .none
        displayNameBorder.backgroundColor = Global.colorSeparator
        displayNameField.addSubview(displayNameBorder)

        accountField.font = UIFont(name: "OpenSans", size: 17)
        accountField.delegate = self
        accountField.textColor = UIColor.black.withAlphaComponent(0.9)
        accountField.returnKeyType = .next
        accountField.keyboardType = .default
        accountField.inputAccessoryView = UIView()
        accountField.autocorrectionType = .no
        accountField.autocapitalizationType = .none
        accountBorder.backgroundColor = Global.colorSeparator
        accountField.addSubview(accountBorder)

        emailField.font = UIFont(name: "OpenSans", size: 17)
        emailField.delegate = self
        emailField.textColor = Global.colorGray
        emailField.returnKeyType = .next
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.isEnabled = false
        emailBorder.backgroundColor = Global.colorSeparator
        emailField.addSubview(emailBorder)

        phoneField.font = UIFont(name: "OpenSans", size: 17)
        phoneField.delegate = self
        phoneField.textColor = UIColor.black.withAlphaComponent(0.9)
        phoneField.returnKeyType = .next
        phoneField.keyboardType = .phonePad
        phoneField.inputAccessoryView = UIView()
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneBorder.backgroundColor = Global.colorSeparator
        phoneField.addSubview(phoneBorder)

        birthDateField.font = UIFont(name: "OpenSans", size: 17)
        birthDateField.delegate = self
        birthDateField.textColor = UIColor.black.withAlphaComponent(0.9)
        birthDateField.returnKeyType = .next
        birthDateField.keyboardType = .default
        birthDateField.inputAccessoryView = UIView()
        birthDateField.autocorrectionType = .no
        birthDateField.autocapitalizationType = .none
        birthDateField.isEnabled = false
        birthDateBorder.backgroundColor = Global.colorSeparator
        birthDateField.addSubview(birthDateBorder)

        addressField.font = UIFont(name: "OpenSans", size: 17)
        addressField.delegate = self
        addressField.textColor = UIColor.black.withAlphaComponent(0.9)
        addressField.returnKeyType = .next
        addressField.keyboardType = .default
        addressField.inputAccessoryView = UIView()
        addressField.autocorrectionType = .no
        addressField.autocapitalizationType = .none
        addressBorder.backgroundColor = Global.colorSeparator
        addressField.addSubview(addressBorder)

        descriptionField.font = UIFont(name: "OpenSans", size: 17)
        descriptionField.delegate = self
        descriptionField.textColor = UIColor.black.withAlphaComponent(0.9)
        descriptionField.returnKeyType = .next
        descriptionField.keyboardType = .default
        descriptionField.inputAccessoryView = UIView()
        descriptionField.autocorrectionType = .no
        descriptionField.autocapitalizationType = .none
        descriptionBorder.backgroundColor = Global.colorSeparator
        descriptionField.addSubview(descriptionBorder)

        nationality.font = UIFont(name: "OpenSans", size: 17)
        nationality.delegate = self
        nationality.textColor = UIColor.black.withAlphaComponent(0.9)
        nationality.returnKeyType = .done
        nationality.keyboardType = .default
        nationality.inputAccessoryView = UIView()
        nationality.autocorrectionType = .no
        nationality.autocapitalizationType = .none
        nationalityBorder.backgroundColor = Global.colorSeparator
        nationality.addSubview(nationalityBorder)
        nationality.isEnabled = false

        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToNationality))
        nationalityView.addGestureRecognizer(viewGesture)
        
        let calendarIcon = FAKFontAwesome.calendarIcon(withSize: 30)
        calendarIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let calendarImg  = calendarIcon?.image(with: CGSize(width: 30, height: 30))
        calendarBtn.setImage(calendarImg, for: .normal)
        calendarBtn.tintColor = Global.colorMain
        calendarBtn.addTarget(self, action: #selector(calenderBtnClicked), for: .touchUpInside)
        calendarBtn.imageView?.contentMode = .scaleAspectFit
        
        maleButton.setTitleColor(Global.colorGray, for: .normal)
        maleButton.setTitleColor(Global.colorMain, for: .highlighted)
        maleButton.setTitleColor(Global.colorGray, for: .selected)
        maleButton.addTarget(self, action: #selector(male), for: .touchUpInside)
        maleButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        maleButton.sizeToFit()
        maleButton.clipsToBounds = true
        maleButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        maleButton.contentHorizontalAlignment = .left
        maleButton.circleColor = Global.colorMain
        maleButton.circleRadius = 10
        
        femaleButton.setTitleColor(Global.colorGray, for: .normal)
        femaleButton.setTitleColor(Global.colorMain, for: .highlighted)
        femaleButton.setTitleColor(Global.colorGray, for: .selected)
        femaleButton.addTarget(self, action: #selector(female), for: .touchUpInside)
        femaleButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        femaleButton.sizeToFit()
        femaleButton.clipsToBounds = true
        femaleButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        femaleButton.contentHorizontalAlignment = .left
        femaleButton.circleColor = Global.colorMain
        femaleButton.circleRadius = 10
        
        radioButtonController = SSRadioButtonsController(buttons: maleButton, femaleButton)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
        radioButtonController = SSRadioButtonsController(buttons: maleButton, femaleButton)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
        numberPhoneCodeBorder.backgroundColor = Global.colorSeparator
        phoneDropDown.anchorView = numberPhoneCodeBorder
        phoneDropDown.direction = .bottom
        phoneDropDown.bottomOffset = CGPoint(x: 0, y: 1)
        phoneDropDown.selectionAction = { [unowned self] (index, item) in
            self.numberCodeLabel.text = item
            self.currentPhoneID = index
        }
        phoneDropDown.dataSource = ["+84", "+81", "+86"]
        
        let phoneNumberCodeViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToPhoneNumberCodeView))
        phoneNumberCodeAbstractView.addGestureRecognizer(phoneNumberCodeViewGesture)
        
        setLanguageRuntime()
        view.setNeedsUpdateConstraints()
        loadData()
    }
    
    func actionTapToPhoneNumberCodeView() {
        phoneDropDown.show()
    }
    
    func loadData() {
        self.indicator.startAnimating()
        AccountService.getUser() {
            newUser in
            
            if newUser != nil {
                self.user = newUser
                self.nameLabel.text = newUser?.User.DisplayName
                self.addressLabel.text = newUser?.User.Address
                self.displayNameField.text = newUser?.User.DisplayName
                self.accountField.text = newUser?.User.NameFurigana
                self.emailField.text = newUser?.User.Email
                self.birthDateField.text = newUser?.User.DOB
                self.addressField.text = newUser?.User.Address
                self.descriptionField.text = newUser?.User.Biography
                
                let phoneNumberArr = newUser?.User.Phone.components(separatedBy: "-")
                if (phoneNumberArr?.count)! >= 2 {
                    self.phoneField.text = phoneNumberArr?[1]
                    self.numberCodeLabel.text = (phoneNumberArr?[0])! + "+"
                }
                
                for countryCode in CountryCodeService.getInstance().countryData {
                    if countryCode.code.contains(newUser?.User.Nationality ?? "")  {
                        self.nationality.text = countryCode.name
                        self.countryCode = countryCode
                        break
                    }
                }
                
                if newUser?.User.Gender == 0 {
                    self.femaleButton.isSelected = true
                    self.gender = 0
                }
                else {
                    self.maleButton.isSelected = true
                    self.gender = 1
                }
                
                if self.user.User.Avatar != "" {
                    self.iconProfileImgView.kf.setImage(with: URL(string: self.user.User.Avatar))
                    self.createPhotoFromURL(url: self.user.User.Avatar)
                }
                else {
                    let image = UIImage(named: "ic_user")
                    self.createPhotoFromImage(image: image!)
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                self.fromDate = dateFormatter.date(from: (newUser?.User.DOB)!) as NSDate?
                
                self.indicator.stopAnimating()
                
                FollowService.getFollowingList(userId: self.user.User.Id, followServiceDelegate: self)
                FollowService.getFollowedList(userId: self.user.User.Id, followServiceDelegate: self)
                
            }
            else {
                self.indicator.stopAnimating()
            }
        }
    }
    
    func createPhotoFromURL(url: String) {
        self.photos.removeAll()
        let url_go = URL.init(string: url)
        let tmppho = INSPhoto(imageURL: url_go, thumbnailImageURL: url_go)
        self.photos.append(tmppho)
    }
    
    func createPhotoFromImage(image: UIImage) {
        self.photos.removeAll()
        let tmppho = INSPhoto(image: image, thumbnailImage: image)
        self.photos.append(tmppho)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            indicator.autoPinEdge(toSuperviewEdge: .top)
            indicator.autoPinEdge(toSuperviewEdge: .bottom)
            indicator.autoPinEdge(toSuperviewEdge: .right)
            indicator.autoPinEdge(toSuperviewEdge: .left)
            
            displayNameBorder.autoSetDimension(.height, toSize: 1)
            displayNameBorder.autoPinEdge(toSuperviewEdge: .bottom)
            displayNameBorder.autoPinEdge(toSuperviewEdge: .left)
            displayNameBorder.autoPinEdge(toSuperviewEdge: .right)
            
            accountBorder.autoSetDimension(.height, toSize: 1)
            accountBorder.autoPinEdge(toSuperviewEdge: .bottom)
            accountBorder.autoPinEdge(toSuperviewEdge: .left)
            accountBorder.autoPinEdge(toSuperviewEdge: .right)
            
            emailBorder.autoSetDimension(.height, toSize: 1)
            emailBorder.autoPinEdge(toSuperviewEdge: .bottom)
            emailBorder.autoPinEdge(toSuperviewEdge: .left)
            emailBorder.autoPinEdge(toSuperviewEdge: .right)
            
            phoneBorder.autoSetDimension(.height, toSize: 1)
            phoneBorder.autoPinEdge(toSuperviewEdge: .bottom)
            phoneBorder.autoPinEdge(toSuperviewEdge: .left)
            phoneBorder.autoPinEdge(toSuperviewEdge: .right)
            
            birthDateBorder.autoSetDimension(.height, toSize: 1)
            birthDateBorder.autoPinEdge(toSuperviewEdge: .bottom)
            birthDateBorder.autoPinEdge(toSuperviewEdge: .left)
            birthDateBorder.autoPinEdge(toSuperviewEdge: .right)
            
            addressBorder.autoSetDimension(.height, toSize: 1)
            addressBorder.autoPinEdge(toSuperviewEdge: .bottom)
            addressBorder.autoPinEdge(toSuperviewEdge: .left)
            addressBorder.autoPinEdge(toSuperviewEdge: .right)
            
            descriptionBorder.autoSetDimension(.height, toSize: 1)
            descriptionBorder.autoPinEdge(toSuperviewEdge: .bottom)
            descriptionBorder.autoPinEdge(toSuperviewEdge: .left)
            descriptionBorder.autoPinEdge(toSuperviewEdge: .right)
            
            nationalityBorder.autoSetDimension(.height, toSize: 1)
            nationalityBorder.autoPinEdge(toSuperviewEdge: .bottom)
            nationalityBorder.autoPinEdge(toSuperviewEdge: .left)
            nationalityBorder.autoPinEdge(toSuperviewEdge: .right)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    
    func setLanguageRuntime(){
        self.navigationItem.title = "profile".localized().uppercased()
        displayNameField.placeholder = "display_name".localized()
        accountField.placeholder = "furigana_name".localized()
        emailField.placeholder = "email".localized()
        phoneField.placeholder = "phone_number".localized()
        birthDateField.placeholder = "birth_date".localized()
        addressField.placeholder = "address".localized()
        descriptionField.placeholder = "biography".localized()
        updateBtn.setTitle("update".localized().uppercased(), for: .normal)
        nationality.placeholder = "nationality".localized()
    }
    
    func getFollowingListOwnerFinished(success: Bool, message: String, result: [UserResult]) {
        
    }
    
    func getFollowingListFinished(success: Bool, message: String, result: [UserResult]) {
        if success {
            self.followingBtn.setTitle(String(result.count) + "\n" + "following".localized(), for: .normal)
        }
    }
    
    func getFollowedListFinished(success: Bool, message: String, result: [UserResult]) {
        if success {
            self.followedBtn.setTitle(String(result.count) + "\n" + "follower".localized(), for: .normal)
        }
    }
    
    func followFinised(success: Bool, message: String) {
        
    }
    
    func unFollowFinised(success: Bool, message: String) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerImgView.addBlurEffect()
    }
    
    func iconProfileBtnClicked() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "take_photos".localized(), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            self.present(cameraViewController, animated: false, completion: nil)
        })
        
        let photoLibraryAction = UIAlertAction(title: "photo_library".localized(), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            cameraViewController.pickImage = 1
            self.present(cameraViewController, animated: false, completion: nil)
        })
        
        let viewProfilePictureAction = UIAlertAction(title: "view_profile_picture".localized(), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let galleryPreview = INSPhotosViewController(photos: self.photos)
            let overlayViewBar = (galleryPreview.overlayView as! INSPhotosOverlayView).navigationBar
            
            overlayViewBar?.autoPin(toTopLayoutGuideOf: galleryPreview, withInset: 0.0)
            
            galleryPreview.view.backgroundColor = UIColor.black
            galleryPreview.view.tintColor = Global.colorMain
            self.present(galleryPreview, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(viewProfilePictureAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = self.iconProfileImgView
        optionMenu.popoverPresentationController?.sourceRect = self.iconProfileImgView.bounds
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func tookPicture(url: String) {
        user.User.Avatar = url
        iconProfileImgView.kf.setImage(with: URL(string: url))
        
        createPhotoFromURL(url: url)
    }
    
    func male() {
        gender = 1
    }
    
    func female() {
        gender = 0
    }
    
    func updateBtnClicked() {
        
        guard checkInput(textField: displayNameField, value: displayNameField.text) else {
            return
        }
        
        guard checkInput(textField: phoneField, value: phoneField.text) else {
            return
        }
        
        guard checkInput(textField: birthDateField, value: birthDateField.text) else {
            return
        }
        
        guard checkInput(textField: addressField, value: addressField.text) else {
            return
        }
        
        guard checkInput(textField: descriptionField, value: descriptionField.text) else {
            return
        }
        
        view.endEditing(true)
        
        SwiftOverlays.showBlockingWaitOverlay()
        let headers: HTTPHeaders = ["X-Auth-Token": (UserDefaultManager.getInstance().getCurrentUser()?.User.Token)!]
        
        let body = ["DisplayName": displayNameField.text!, "Avatar" : user.User.Avatar, "DOB": birthDateField.text!, "Gender": gender, "Phone": phoneSource[currentPhoneID] + phoneField.text!, "Address": addressField.text!, "Biography": descriptionField.text!, "Nationality": countryCode.code, "NameFurigana" : accountField.text ?? ""] as [String : Any]
        Alamofire.request(Global.newBaseURL + "account/update/user", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                SwiftOverlays.removeAllBlockingOverlays()
                if json["success"].intValue == 1 {
                    self.errorLabel.text = "could_not_update_profile_please_try_again".localized()
                }
                else {
                    self.nameLabel.text = self.displayNameField.text!
                    self.addressLabel.text = self.addressField.text!
                    
                    Utils.showAlert(title: "profile".localized(), message: "update_profile_successfully".localized(), viewController: self)
                }
            case .failure(_):
                SwiftOverlays.removeAllBlockingOverlays()
                self.errorLabel.text = "could_not_update_profile_please_try_again".localized()
            }
        }
    }
    
    var fromDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if fromDate != nil {
                birthDateField.text = dateFormatter.string(from: fromDate! as Date)
            } else {
                birthDateField.text = user.User.DOB
            }
        }
    }
    
    func calenderBtnClicked(sender: UIButton) {
        phoneField.resignFirstResponder()
        addressField.resignFirstResponder()
        descriptionField.resignFirstResponder()
        
        var date = NSDate()
        if(fromDate != nil) {
            date = fromDate!
        }
        
        var datePickerViewController : UIViewController!
        datePickerViewController = AIDatePickerController.picker(with: date as Date!, selectedBlock: {
            newDate in
            self.fromDate = newDate as NSDate?
            datePickerViewController.dismiss(animated: true, completion: nil)
        }, cancel: {
            datePickerViewController.dismiss(animated: true, completion: nil)
        }) as! UIViewController
        
        present(datePickerViewController, animated: true, completion: nil)
    }
    
    func actionTapToNationality() {
        let viewController = LocationViewController()
        viewController.locationDelegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func saveLocation(countryCode: CountryCode) {
        nationality.text = countryCode.name
        self.countryCode = countryCode
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case displayNameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                phoneField.becomeFirstResponder()
                return true
            }
        case accountField:
            return true
        case phoneField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                addressField.becomeFirstResponder()
                return true
            }
        case addressField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                descriptionField.becomeFirstResponder()
                return true
            }
        case descriptionField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                nationality.becomeFirstResponder()
                return true
            }
        default:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                return true
            }
        }
        
        return false
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case displayNameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_display_name".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case accountField:
            return true
        case phoneField:
            if value != nil && value!.isValidPhone() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_phone_number".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case birthDateField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                birthDateBorder.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_birth_date".localized()
            birthDateBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case addressField:
            if value != nil && value!.isValidAddress() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_address".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case descriptionField:
            if value != nil && value!.isValidDescription() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_description".localized()
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && value!.isValidNationality() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorSeparator
                return true
            }
            errorLabel.text = "invalid_nationality".localized()
        }
        return false
    }
    
    var viewPopupController: STPopupController!
    
    func showUsersFollowing() {
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 16)!]
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 14)!]
        }
        
        let viewController = UsersFollowingViewController()
        viewController.user = user.User
        viewController.followUserDelegate = self
        viewPopupController = STPopupController(rootViewController: viewController)
        viewPopupController.containerView.layer.cornerRadius = 4
        viewPopupController.present(in: self)
    }
    
    func showUsersFollowed() {
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 16)!]
        
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 14)!]
        }
        
        let viewController = UsersFollowedViewController()
        viewController.user = user.User
        viewController.followUserDelegate = self
        viewPopupController = STPopupController(rootViewController: viewController)
        viewPopupController.containerView.layer.cornerRadius = 4
        viewPopupController.present(in: self)
    }
    
    func userProfileClicked(user: UserResult) {
        viewPopupController.dismiss()
        let nav = UserViewController()
        nav.user = user
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
