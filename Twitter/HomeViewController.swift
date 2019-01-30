//
//  HomeViewController.swift
//  Twitter
//
//  Created by Will Tyler on 1/30/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit


class HomeViewController: UITableViewController {

	convenience init() {
		self.init(nibName: nil, bundle: nil)
	}
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

		title = "Home"
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let logoutItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutItemAction))
		
		logoutItem.tintColor = Colors.twitter

		navigationItem.setLeftBarButton(logoutItem, animated: false)
		tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.cellID)
		view.backgroundColor = Colors.dark

		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(loadTweets), for: .valueChanged)

		loadTweets()
	}

	var tweets = [[String: Any]]() {
		didSet {
			tableView.reloadData()
		}
	}

	@objc
	private func loadTweets() {
		let urlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
		let parameters = [ "count": 64 ]

		TwitterAPICaller.client?.getDictionariesRequest(url: urlString, parameters: parameters, success: { dictionaries in
			self.tweets = dictionaries as! [[String: Any]]
			self.refreshControl?.endRefreshing()
		}, failure: { error in
			print(error.localizedDescription)
			self.refreshControl?.endRefreshing()
		})
	}

	@objc
	private func logoutItemAction() {
		dismiss(animated: true)
		TwitterAPICaller.client?.logout()
		Defaults.isLoggedIn = false
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tweets.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.cellID) as! TweetTableViewCell
		let tweet = tweets[indexPath.row]

		cell.tweet = tweet

		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

}
