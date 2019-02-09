//
//  TweetComposerViewController.swift
//  Twitter
//
//  Created by Will Tyler on 2/4/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit


class TweetComposerViewController: UIViewController {

	private lazy var textField: UITextField = {
		let field = UITextField()

		field.textColor = .white
		field.placeholder = "What's happening?"
		field.attributedPlaceholder = NSAttributedString(string: "What's happening?", attributes: [.foregroundColor: UIColor.lightText])

		return field
	}()

	private func setupInitialLayout() {
		view.addSubview(textField)

		let safeArea = view.safeAreaLayoutGuide

		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
		textField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
		textField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
		textField.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/3).isActive = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = Colors.dark
		setupInitialLayout()

		let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelItemAction))
		let tweetItem = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(tweetItemAction))

		cancelItem.tintColor = Colors.twitter
		tweetItem.tintColor = Colors.twitter

		navigationItem.setLeftBarButton(cancelItem, animated: false)
		navigationItem.setRightBarButton(tweetItem, animated: false)

		textField.becomeFirstResponder()
	}

	@objc
	private func cancelItemAction() {
		navigationController?.popViewController(animated: true)
	}

	@objc
	private func tweetItemAction() {
		guard let content = textField.text, !content.isEmpty else {
			return
		}

		TwitterAPICaller.client?.tweet(content: content, success: {
			self.navigationController?.popViewController(animated: true)
		}, failure: { error in
			print(error.localizedDescription)
		})
	}

}
