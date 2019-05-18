//
//	IdentifiableByString.swift
//	Vocabulary
//
//	Created by Alexander Baraley on 11/18/17.
//	Copyright © 2017 Alexander Baraley. All rights reserved.
//

import UIKit

protocol IdentifiableByString {
	static var stringIdentifier: String { get }
}

extension IdentifiableByString {
	static var stringIdentifier: String {
		return String(describing: self)
	}
}

extension UIView: IdentifiableByString { }
extension UIViewController: IdentifiableByString { }
