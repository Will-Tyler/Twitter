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

		let logoutItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutItemAction))
		let tweetItem = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(tweetItemAction))
		
		logoutItem.tintColor = Colors.twitter
		tweetItem.tintColor = Colors.twitter

		navigationItem.setLeftBarButton(logoutItem, animated: false)
		navigationItem.setRightBarButton(tweetItem, animated: false)
		tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.cellID)
		tableView.showsVerticalScrollIndicator = false
		view.backgroundColor = Colors.dark

		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(loadTweets), for: .valueChanged)

		loadTweets()
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

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

	private func loadMoreTweets() {
		let urlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"

		if let lastTweet = tweets.last, let lastID = lastTweet["id"] as? Int64 {
			let parameters: [String : Any] = [ "count": 64, "max_id": lastID-1 ]

			TwitterAPICaller.client?.getDictionariesRequest(url: urlString, parameters: parameters, success: { dictionaries in
				self.tweets.append(contentsOf: dictionaries as! [[String: Any]])
			}, failure: { error in
				print(error.localizedDescription)
			})
		}
	}

	@objc
	private func logoutItemAction() {
		dismiss(animated: true)
		TwitterAPICaller.client?.logout()
		Defaults.isLoggedIn = false
	}

	private lazy var composerViewController = TweetComposerViewController()

	@objc
	private func tweetItemAction() {
		navigationController?.pushViewController(composerViewController, animated: true)
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
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row + 1 == tweets.count {
			loadMoreTweets()
		}
	}

}
