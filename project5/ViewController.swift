//
//  ViewController.swift
//  project5
//
//  Created by Vlad Klunduk on 06/08/2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let wordsFromFile = try? String(contentsOf: url) {
                allWords = wordsFromFile.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["TryAgain"]
        }
    }


}

