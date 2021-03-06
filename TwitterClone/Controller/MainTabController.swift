//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabController: UITabBarController {
    
    // MARK: - Public properties
    var user: User? {
        didSet {
            guard let navigationController = viewControllers?[0] as? UINavigationController else { return }
            guard let feedVC = navigationController.viewControllers.first as? FeedViewController else { return }
            feedVC.user = user
        }
    }
    
    
    // MARK: - Private properties
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .mainBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        fetchUser()
        confugureViewControllers()
        configureUI()
        
        delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
    }
    
    @objc fileprivate func handleActionButtonTapped() {
        guard let user = user else { return }
        let navigationController = UINavigationController(rootViewController: UploadTweetController(user: user, config: .upload))
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Private properties
    
    private func confugureViewControllers() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let feed = FeedViewController(collectionViewLayout: layout)
        feed.tabBarItem.image = UIImage(named: "home_unselected")
        
        let explore = ExploreViewController()
        explore.tabBarItem.image = UIImage(named: "search_unselected")
        
        let notifications = NotificationsViewController()
        notifications.tabBarItem.image = UIImage(named: "like_unselected")
        
        let conversation = ConversationViewController()
        conversation.tabBarItem.image = UIImage(named: "ic_mail_outline_white_2x-1")
        
        
        viewControllers = [feed, explore, notifications, conversation]
        viewControllers = viewControllers?.map({ viewController -> UINavigationController in
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.barTintColor = .white
            return navigationController
        })
    }
    
    private func configureUI() {
        view.addSubview(actionButton)
        
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
}


extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is FeedViewController {
            print("Feed vc")
        }
    }
}
