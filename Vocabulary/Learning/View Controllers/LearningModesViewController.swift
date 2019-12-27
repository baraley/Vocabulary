//
//	LearningModesViewController.swift
//	Vocabulary
//
//	Created by Alexander Baraley on 3/24/18.
//	Copyright © 2018 Alexander Baraley. All rights reserved.
//

import UIKit
import CoreData.NSManagedObjectID

class LearningModesViewController: UIViewController, SegueHandlerType {

	// MARK: - Properties -

	var vocabularyStore: VocabularyStore!
	var currentWordCollectionInfoProvider: CurrentWordCollectionInfoProvider!

	@IBOutlet private var learningModesView: LearningModesView!

	private var currentWordCollectionID: NSManagedObjectID? {
		currentWordCollectionInfoProvider.wordCollectionInfo?.objectID
	}

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNotifications()
		currentWordCollectionInfoProvider.addObserver(self)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateLearningModesView()
	}
	
	// MARK: - Navigation
	
	enum SegueIdentifier: String {
		case remembering, repetition, remindWord
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		switch segueIdentifier(for: segue) {
		case .remembering:
			let viewController = segue.destination as! UnknownWordsViewController
			viewController.vocabularyStore = vocabularyStore
			viewController.currentWordCollectionID = currentWordCollectionID
			
		case .repetition:
			let viewController = segue.destination as! LearningProcessViewController
			viewController.vocabularyStore = vocabularyStore
			viewController.currentWordCollectionID = currentWordCollectionID
			
			let fetchRequest = FetchRequestFactory.fetchRequest(for: .repetition, wordCollectionID: currentWordCollectionID)
			let words = vocabularyStore.wordsFrom(fetchRequest)
			
			viewController.learningMode = .repetition(words)
			
		case .remindWord:
			let viewController = segue.destination as! RemindWordsViewController
			viewController.vocabularyStore = vocabularyStore
			viewController.currentWordCollectionID = currentWordCollectionID
		}
	}
}

// MARK: - Private -
private extension LearningModesViewController {

	// MARK: - Methods
	
	func setupNotifications() {
		let enterForeground = UIApplication.willEnterForegroundNotification
		NotificationCenter.default.addObserver(
			self, selector: #selector(updateLearningModesView), name: enterForeground, object: nil
		)
	}
	
	@objc
	func updateLearningModesView() {

		let rememberWordsNumber = vocabularyStore.numberOfWordsFrom(
			FetchRequestFactory.fetchRequest(for: .remembering, wordCollectionID: currentWordCollectionID)
		)
		let repeatWordsNumber = vocabularyStore.numberOfWordsFrom(
			FetchRequestFactory.fetchRequest(for: .repetition, wordCollectionID: currentWordCollectionID)
		)
		let remindWordsNumber = vocabularyStore.numberOfWordsFrom(
			FetchRequestFactory.fetchRequest(for: .reminding, wordCollectionID: currentWordCollectionID)
		)

		learningModesView.viewData = LearningModesView.ViewData(
			rememberWordsNumber: rememberWordsNumber,
			repeatWordsNumber: repeatWordsNumber,
			remindWordsNumber: remindWordsNumber
		)
	}
}

extension LearningModesViewController: CurrentWordCollectionInfoObserver {

	func currentWordCollectionDidChange(_ wordCollectionInfo: WordCollectionInfo?) {
		navigationItem.title = "\(wordCollectionInfo?.name ?? "Vocabulary")"
		updateLearningModesView()
	}
}

