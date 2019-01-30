//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Will Tyler on 1/30/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage


class TweetTableViewCell: UITableViewCell {

	private lazy var profileImageView: UIImageView = {
		let image = UIImageView()

		image.layer.masksToBounds = true
		image.layer.cornerRadius = 4

		return image
	}()
	private lazy var nameLabel: UILabel = {
		let label = UILabel()

		label.font = UIFont.boldSystemFont(ofSize: 15)
		label.numberOfLines = 1
		label.textColor = .white

		return label
	}()
	private lazy var tweetLabel: UILabel = {
		let label = UILabel()

		label.font = UIFont.systemFont(ofSize: 12)
		label.numberOfLines = 0
		label.textColor = .white

		return label
	}()

	private func setupInitialLayout() {
		addSubview(profileImageView)
		addSubview(nameLabel)
		addSubview(tweetLabel)

		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
		profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
		profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
		profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true

		tweetLabel.translatesAutoresizingMaskIntoConstraints = false
		tweetLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		tweetLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
		tweetLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		tweetLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

		didSetupInitialLayout = true
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		backgroundColor = .clear
	}

	static let cellID = "TweetTableViewCell"
	private var didSetupInitialLayout = false

	var tweet: [String: Any]! {
		didSet {
			tweetLabel.text = tweet["text"] as? String

			if let user = tweet["user"] as? [String: Any] {
				nameLabel.text = user["name"] as? String

				if let profileImageURLString = user["profile_image_url_https"] as? String, let url = URL(string: profileImageURLString) {
					profileImageView.af_setImage(withURL: url)
				}
			}

			if !didSetupInitialLayout {
				setupInitialLayout()
			}
		}
	}

}
