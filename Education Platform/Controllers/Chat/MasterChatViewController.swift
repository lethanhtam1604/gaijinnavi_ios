//
//  MasterChatViewController.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 12/28/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Localize_Swift

class MasterChatViewController: UIViewController, MessageViewDelegate, SelectSingleViewControllerDelegate, MainViewDelegate {

    private lazy var userMessageTableViewController: UserMessageViewController = {
        var viewController = UserMessageViewController()
        viewController.delegate = self
        self.add(asChildViewController: viewController)
        return viewController
    }()


    private lazy var messageViewController: MessageViewController = {
        var viewController = MessageViewController()
        viewController.delegate = self
        self.add(asChildViewController: viewController)
        return viewController
    }()

    private lazy var requestViewController: RequestViewController = {
        var viewController = RequestViewController()
        self.add(asChildViewController: viewController)
        return viewController
    }()

    var currentUser = RoleResult()
    var segment: UISegmentedControl!

    var iconProfileImgView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.colorBg
        view.tintColor = UIColor.white
        view.clipsToBounds = true

        navigationController?.navigationBar.barTintColor = Global.colorMain
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

        currentUser = UserDefaultManager.getInstance().getCurrentUser()!

        let plusCircleIcon = FAKFontAwesome.plusCircleIcon(withSize: 25)
        plusCircleIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let plusCircleImg = plusCircleIcon?.image(with: CGSize(width: 25, height: 25))
        let addBarBtn = UIBarButtonItem(image: plusCircleImg, style: .plain, target: self, action: #selector(addUserChat))
        self.navigationItem.rightBarButtonItem = addBarBtn

        let iosPersonIcon = FAKIonIcons.iosPersonIcon(withSize: 30)
        iosPersonIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let iosPersonImg = iosPersonIcon?.image(with: CGSize(width: 30, height: 30))

        iconProfileImgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        iconProfileImgView.image = iosPersonImg
        iconProfileImgView.layer.cornerRadius = 15
        iconProfileImgView.layer.borderColor = UIColor.white.cgColor
        iconProfileImgView.layer.borderWidth = 1.5
        iconProfileImgView.clipsToBounds = true
        iconProfileImgView.contentMode = .scaleAspectFill
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userProfile))
        iconProfileImgView.isUserInteractionEnabled = true
        iconProfileImgView.addGestureRecognizer(tapGestureRecognizer)
        let profileBarBtn = UIBarButtonItem(customView: iconProfileImgView)
        self.navigationItem.leftBarButtonItem = profileBarBtn

        createSegment()
        setupView()

        setLanguageRuntime()
    }

    func loadData() {
        AccountService.getUser() {
            newUser in
            if let user = newUser {
                if user.User.Avatar != "" {
                    self.iconProfileImgView.kf.setImage(with: URL(string: user.User.Avatar))
                }
                else {
                    self.iconProfileImgView.image = UIImage(named: "ic_user")
                }
            }
            else {
                self.iconProfileImgView.image = UIImage(named: "ic_user")
            }
        }
    }

    func createSegment() {
        segment = UISegmentedControl(items: ["segment_chat".localized(), "segment_friend".localized(), "segment_request".localized()])
        segment.sizeToFit()
        segment.tintColor = UIColor.white
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        self.navigationItem.titleView = segment
    }

    private func setupView() {
        updateView()
    }

    private func updateView() {
        switch segment.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: userMessageTableViewController)
            remove(asChildViewController: requestViewController )
            add(asChildViewController: messageViewController)
            break
        case 1:
            remove(asChildViewController: messageViewController)
            remove(asChildViewController: requestViewController )
            add(asChildViewController: userMessageTableViewController)
            break
        case 2:
            remove(asChildViewController: userMessageTableViewController)
            remove(asChildViewController: messageViewController )
            add(asChildViewController: requestViewController)
            break
        default:
            remove(asChildViewController: userMessageTableViewController)
            remove(asChildViewController: requestViewController )
            add(asChildViewController: messageViewController)
            break
        }
    }

    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    private func add(asChildViewController viewController: UIViewController) {
        view.addSubview(viewController.view)
        let viewBound = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        viewController.view.frame = viewBound
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    func updateMessageCounter(counter: Int) {
        Utils.setBadgeIndicator(badgeCount: counter)
    }

    func addUserChat() {
        let userView = AllUserTableViewController()
        self.navigationController?.pushViewController(userView, animated: true)
    }

    func OpenChatMessage( groupID : String, name: String, userId: Int64, currentUser: RoleResult) {
        self.hidesBottomBarWhenPushed = true
        let messageVC = MessageChatViewController()
        messageVC.groupId = groupID
        messageVC.Name = name
        messageVC.userId = userId
        messageVC.CurrentUser = currentUser
        self.navigationController?.pushViewController(messageVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }

    func didSelectSingleUser(_ user: ChatUserResult) {
        ChatAPIservices.createChatGroup(UserIds: [user.Id]) { (Success, groupId) in
            if(Success == true) {
                self.OpenChatMessage(groupID: groupId!, name: user.DisplayName, userId: user.Id, currentUser: self.currentUser)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLanguageRuntime), name: NSNotification.Name(rawValue: LCLLanguageChangeNotification), object: nil)

        loadData()
    }

    func confirmedEmail() {
        Utils.showAlert(title: "Gaijinnavi", message: "confirm_email_successfully".localized(), viewController: self)
    }

    func setLanguageRuntime(){
        tabBarItem.title = "message".localized().uppercased()
        createSegment()
    }

    func userProfile() {
        let nav = ProfileViewController()
        self.navigationController?.pushViewController(nav, animated: true)
    }
}
