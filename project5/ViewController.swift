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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
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
    
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter your answer:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAnswer = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAnswer)
        present(ac, animated: true)
    }
    
    
    func submit(_ answer: String) {
        let word = answer.lowercased()
        
        let alertTitle: String
        let alertMessage: String
        
        if isPossible(word) {
            if isOriginal(word) {
                if isReal(word) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)

                    return
                } else {
                    alertTitle = "Word not recognized"
                    alertMessage = "You can't just make them up, you know!"
                }
            } else {
                alertTitle = "Word have already used"
                alertMessage = "Be more original!"
            }
        } else {
            guard let title = title?.lowercased() else { return }
            alertTitle = "Word not possible"
            alertMessage = "You can't spell that word from \(title)"
        }
        
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(_ word: String) -> Bool {
        guard var titleWord = title?.lowercased() else { return false }
        
        for char in word {
            if let indexOfChar = titleWord.firstIndex(of: char) {
                titleWord.remove(at: indexOfChar)
            } else {
                return true
            }
        }
        return true
    }
    
    func isOriginal(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}

