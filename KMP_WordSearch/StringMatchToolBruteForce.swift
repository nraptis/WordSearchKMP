//
//  StringMatchToolBruteForce.swift
//  KMP_WordSearch
//
//  Created by Nicky Taylor on 11/17/22.
//

import Foundation

class StringMatchToolBruteForce {
    
    private(set) var matches = [Bool]()
    
    private func resetMatches(text: [Character]) {
        if matches.count < text.count {
            let newSize = text.count + text.count / 2 + 1
            matches = [Bool](repeating: false, count: newSize)
        } else {
            for index in 0..<text.count {
                matches[index] = false
            }
        }
    }
    
    func findMatches(text: String, words: [String]) {
        let text = Array(text)
        let words = words.map { Array($0) }
        findMatches(text: text, words: words)
    }
    
    func findMatches(text: String, words: [[Character]]) {
        let text = Array(text)
        findMatches(text: text, words: words)
    }
    
    func findMatches(text: [Character], words: [String]) {
        let words = words.map { Array($0) }
        findMatches(text: text, words: words)
    }
    
    func findMatches(text: [Character], words: [[Character]]) {
        
        resetMatches(text: text)
        for stringIndex in text.indices {
            for wordArray in words {
                guard stringIndex + wordArray.count <= text.count else {
                    continue
                }
                
                var match = true
                for wordIndex in 0..<wordArray.count {
                    if text[stringIndex + wordIndex] != wordArray[wordIndex] {
                        match = false
                        break
                    }
                }
                
                if match {
                    for wordIndex in 0..<wordArray.count {
                        matches[wordIndex + stringIndex] = true
                    }
                }
            }
        }
    }
    
}
