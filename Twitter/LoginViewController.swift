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
		button.titleLabel!.font = UIFont.systemFont(ofSize: 35)
		button.backgroundColor = .blue

		return button
	}()

	private func setupInitialLayout() {
		view.addSubview(loginButton)

		loginButton.translatesAutoresizingMaskIntoConstraints = false
		loginButton.widthAnchor.constraint(equalToConstant: loginButton.intrinsicContentSize.width).isActive = true
		loginButton.heightAnchor.constraint(equalToConstant: loginButton.intrinsicContentSize.height).isActive = true
		loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = Colors.dark

		setupInitialLayout()
    }

}
