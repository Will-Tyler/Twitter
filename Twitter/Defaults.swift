//
//  Defaults.swift
//  Twitter
//
//  Created by Will Tyler on 1/30/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import Foundation


struct Defaults {

	private static let defaults = UserDefaults.standard

	static var isLoggedIn: Bool {
		get {
			return defaults.bool(forKey: "isLoggedIn")
		}
		set {
			defaults.set(newValue, forKey: "isLoggedIn")
		}
	}

}
