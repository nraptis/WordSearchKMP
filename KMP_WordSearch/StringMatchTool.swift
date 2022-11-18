//
//  StringMatchTool.swift
//  KMP_WordSearch
//
//  Created by Nicky Taylor on 11/17/22.
//

import Foundation

class StringMatchTool {
    
    private(set) var matches = [Bool]()
    private(set) var spans = [Int]()
    
    private var lps = [Int]()
    
    private func resetMatches(text: [Character]) {
        if matches.count < text.count {
            let newSize = text.count + text.count / 2 + 1
            matches = [Bool](repeating: false, count: newSize)
            spans = [Int](repeating: 0, count: newSize)
            
        } else {
            for index in 0..<text.count { matches[index] = false }
            for index in 0..<text.count { spans[index] = 0 }
        }
    }
    
    private func resetLPS(words: [[Character]]) {
        var longestWordLength = 0
        for word in words {
            if word.count > longestWordLength {
                longestWordLength = word.count
            }
        }
        
        if lps.count < longestWordLength {
            let newSize = longestWordLength + longestWordLength / 2 + 1
            lps = [Int](repeating: 0, count: newSize)
        } else {
            for index in 0..<longestWordLength {
                lps[index] = 0
            }
        }
    }
    
    private func buildLPS(word: [Character]) {
        var i = 1
        var len = 0
        while i < word.count {
            if word[i] == word[len] {
                len += 1
                lps[i] = len
                i += 1
            } else if len != 0 {
                len = lps[len - 1]
            } else {
                lps[i] = 0
                i += 1
            }
        }
    }
    
    private func search(text: [Character], word: [Character]) {
        var i = 0
        var j = 0
        while i < text.count {
            if text[i] == word[j] {
                i += 1
                j += 1
            }
            if j == word.count {
                if word.count > spans[(i - j)] {
                    spans[(i - j)] = word.count
                }
                j = lps[j - 1];
            }
            
            if i < text.count && text[i] != word[j] {
                if j != 0 {
                    j = lps[j - 1]
                } else {
                    i += 1
                }
            }
        }
    }
    
    private func writeSpansToMatching(text: [Character]) {
        var index = 0
        var count = 0
        while index < text.count {
            if spans[index] > count {
                count = spans[index]
            }
            spans[index] = count
            if count > 0 {
                matches[index] = true
            }
            
            count -= 1
            index += 1
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
        resetLPS(words: words)
        if text.count <= 0 { return }
        for word in words {
            if word.count > 0 {
                buildLPS(word: word)
                search(text: text, word: word)
            }
        }
        writeSpansToMatching(text: text)
    }
    
}
