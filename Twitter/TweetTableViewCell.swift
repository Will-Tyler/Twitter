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
	private lazy var favoriteButton: UIButton = {
		let button = UIButton(type: .custom)

		button.setImage(UIImage(named: "favorite-empty"), for: .normal)
		button.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)

		return button
	}()
	private lazy var retweetButton: UIButton = {
		let button = UIButton(type: .custom)

		button.tintColor = .white
		button.setImage(UIImage(named: "retweet"), for: .normal)
		button.addTarget(self, action: #selector(retweetButtonAction), for: .touchUpInside)

		return button
	}()

	private func setupInitialLayout() {
		let stackView = UIStackView(arrangedSubviews: [retweetButton, favoriteButton])

		stackView.axis = .horizontal
		stackView.distribution = .equalCentering

		addSubview(profileImageView)
		addSubview(nameLabel)
		addSubview(tweetLabel)
		addSubview(stackView)

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

		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.topAnchor.constraint(equalTo: tweetLabel.bottomAnchor, constant: 8).isActive = true
		stackView.leadingAnchor.constraint(equalTo: tweetLabel.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

		bottomAnchor.constraint(greaterThanOrEqualTo: profileImageView.bottomAnchor, constant: 8).isActive = true
		bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 8).isActive = true

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
			isFavorited = tweet["favorited"] as? Bool ?? false
			isRetweeted = tweet["retweeted"] as? Bool ?? false

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
	private var isFavorited: Bool = false {
		didSet {
			let image: UIImage?

			if isFavorited {
				image = UIImage(named: "favorite")
			}
			else {
				image = UIImage(named: "favorite-empty")
			}

			favoriteButton.tintColor = isFavorited ? .red : .white
			favoriteButton.setImage(image, for: .normal)
		}
	}
	private var isRetweeted: Bool = false {
		didSet {
			retweetButton.tintColor = isRetweeted ? .green : .white
		}
	}

	@objc
	private func favoriteButtonAction() {
		guard let id = tweet["id"] as? Int else {
			return
		}

		if isFavorited {
			TwitterAPICaller.client?.unfavorite(tweetID: id, success: {
				self.isFavorited = false
			}, failure: { error in
				print(error.localizedDescription)
			})
		}
		else {
			TwitterAPICaller.client?.favorite(tweetID: id, success: {
				self.isFavorited = true
			}, failure: { error in
				print(error.localizedDescription)
			})
		}
	}

	@objc
	private func retweetButtonAction() {
		guard let id = tweet["id"] as? Int else {
			return
		}

		if isRetweeted {
			TwitterAPICaller.client?.unretweet(tweetID: id, success: {
				self.isRetweeted = false
			}, failure: { error in
				print(error.localizedDescription)
			})
		}
		else {
			TwitterAPICaller.client?.retweet(tweetID: id, success: {
				self.isRetweeted = true
			}, failure: { error in
				print(error.localizedDescription)
			})
		}
	}

}
