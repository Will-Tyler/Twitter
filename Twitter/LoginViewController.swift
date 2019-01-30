//
//  LoginViewController.swift
//  Twitter
//
//  Created by Will Tyler on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

	private lazy var loginButton: UIButton = {
		let button = UIButton()

		button.tintColor = .white
		button.setTitle("Login", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel!.font = UIFont.systemFont(ofSize: 32)
		button.backgroundColor = Colors.twitter
		button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)

		button.layer.masksToBounds = true
		button.layer.cornerRadius = 8

		return button
	}()

	private func setupInitialLayout() {
		view.addSubview(loginButton)

		loginButton.translatesAutoresizingMaskIntoConstraints = false
		loginButton.widthAnchor.constraint(equalToConstant: loginButton.intrinsicContentSize.width+32).isActive = true
		loginButton.heightAnchor.constraint(equalToConstant: loginButton.intrinsicContentSize.height).isActive = true
		loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = Colors.dark

		setupInitialLayout()
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if Defaults.isLoggedIn {
			presentHome()
		}
	}

	private func presentHome() {
		let navigation = UINavigationController(rootViewController: HomeViewController())

		navigation.navigationBar.barTintColor = Colors.lighter
		navigation.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

		self.present(navigation, animated: true)
	}

	@objc
	private func loginButtonAction() {
		let urlString = "https://api.twitter.com/oauth/request_token"

		TwitterAPICaller.client?.login(url: urlString, success: {
			self.presentHome()
			Defaults.isLoggedIn = true
		}, failure: { error in
			print(error.localizedDescription)
		})
	}

}
