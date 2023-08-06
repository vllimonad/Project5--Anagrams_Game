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
        
        
        startGame()
    }
    
    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }


}

