//
//  KMP_WordSearchTests.swift
//  KMP_WordSearchTests
//
//  Created by Nicky Taylor on 11/17/22.
//

import XCTest
@testable import KMP_WordSearch
import os.log

final class KMP_WordSearchTests: XCTestCase {

    func compare(matches1: [Bool], matches2: [Bool], count: Int) -> Bool {
        if matches1.count < count { return false }
        if matches2.count < count { return false }
        var index = 0
        while index < count {
            if matches1[index] != matches2[index] { return false }
            index += 1
        }
        return true
    }
    
    func testBruteForceBasic() {
        let string = "aacat"
        let words = ["cat"]
        
        let bfTool = StringMatchToolBruteForce()
        bfTool.findMatches(text: string, words: words)
        
        let expectedMatches = [false, false, true, true, true]
        let matches = bfTool.matches
        if !compare(matches1: expectedMatches, matches2: matches, count: string.count) {
            XCTFail("\(string) did not match \(words) {\(expectedMatches)} VS {\(matches)}")
        }
    }
    
    func testKMPBasic() {
        let string = "aacat"
        let words = ["cat"]
        
        let kmpTool = StringMatchTool()
        kmpTool.findMatches(text: string, words: words)
        
        let expectedMatches = [false, false, true, true, true]
        let matches = kmpTool.matches
        if !compare(matches1: expectedMatches, matches2: matches, count: string.count) {
            XCTFail("\(string) did not match \(words) {\(expectedMatches)} VS {\(matches)}")
        }
    }
    
    func testRepeatingSequenceWithOneWord() {
        let string = "aaaaaaaaaa"
        let words = ["aaa"]
        
        let bfTool = StringMatchToolBruteForce()
        bfTool.findMatches(text: string, words: words)
        
        let kmpTool = StringMatchTool()
        kmpTool.findMatches(text: string, words: words)
        
        if !compare(matches1: bfTool.matches, matches2: kmpTool.matches, count: string.count) {
            XCTFail("\(string) did not match \(words) {\(bfTool.matches)} VS {\(kmpTool.matches)}")
        }
    }
    
    static let characters: [Character] = ["a", "b", "$", "@", "x", "y", "z"]
    func randomChar() -> Character {
        return Self.characters.randomElement() ?? "a"
    }
    
    func wordSegmentAlwaysRepeating() -> [Character] {
        let commonCharacter = randomChar()
        let length = Int.random(in: 1...5)
        var result = [Character]()
        for _ in 0..<length {
            result.append(commonCharacter)
        }
        return result
    }
    
    func wordSegmentUsuallyRepeating() -> [Character] {
        let commonCharacter = randomChar()
        let length = Int.random(in: 1...5)
        var result = [Character]()
        for _ in 0..<length {
            if Int.random(in: 0...10) != 0 {
                result.append(commonCharacter)
            } else {
                result.append(randomChar())
            }
        }
        return result
    }
    
    func wordSegmentRandom() -> [Character] {
        let length = Int.random(in: 1...5)
        var result = [Character]()
        for _ in 0..<length {
            result.append(randomChar())
        }
        return result
    }
    
    func word() -> [Character] {
        let numberOfSegments = Int.random(in: 0...4)
        var result = [Character]()
        for _ in 0..<numberOfSegments {
            
            let type = Int.random(in: 0...3)
            if type == 0 {
                result.append(contentsOf: wordSegmentAlwaysRepeating())
            } else if type == 1 {
                result.append(contentsOf: wordSegmentUsuallyRepeating())
            } else {
                result.append(contentsOf: wordSegmentRandom())
            }
        }
        return result
    }
    
    func longWord() -> [Character] {
        let numberOfSegments = Int.random(in: 10...20)
        var result = [Character]()
        for _ in 0..<numberOfSegments {
            let type = Int.random(in: 0...3)
            if type == 0 {
                result.append(contentsOf: wordSegmentAlwaysRepeating())
            } else if type == 1 {
                result.append(contentsOf: wordSegmentUsuallyRepeating())
            } else {
                result.append(contentsOf: wordSegmentRandom())
            }
        }
        return result
    }
    
    func sentence() -> [Character] {
        let numberOfSegments = Int.random(in: 0...20)
        var result = [Character]()
        for _ in 0..<numberOfSegments {
            let type = Int.random(in: 0...5)
            if type == 0 {
                result.append(contentsOf: wordSegmentAlwaysRepeating())
            } else if type == 1 {
                result.append(contentsOf: wordSegmentUsuallyRepeating())
            } else if type == 2 {
                result.append(contentsOf: wordSegmentRandom())
            } else if type == 3 {
                result.append(" ")
            } else if type == 4 {
                result.append(".")
            }
        }
        return result
    }
    
    func longSentence() -> [Character] {
        let numberOfSegments = Int.random(in: 50...100)
        var result = [Character]()
        for _ in 0..<numberOfSegments {
            let type = Int.random(in: 0...5)
            if type == 0 {
                result.append(contentsOf: wordSegmentAlwaysRepeating())
            } else if type == 1 {
                result.append(contentsOf: wordSegmentUsuallyRepeating())
            } else if type == 2 {
                result.append(contentsOf: wordSegmentRandom())
            } else if type == 3 {
                result.append(" ")
            } else if type == 4 {
                result.append(".")
            }
        }
        return result
    }
    
    func testTenTimesWithOneWord() {
        
        let bfTool = StringMatchToolBruteForce()
        let kmpTool = StringMatchTool()
        
        for _ in 0..<10 {
            let sentence = sentence()
            let words = [word()]
            
            bfTool.findMatches(text: sentence, words: words)
            kmpTool.findMatches(text: sentence, words: words)
            
            if !compare(matches1: bfTool.matches, matches2: kmpTool.matches, count: sentence.count) {
                XCTFail("\(sentence) did not match \(words) {\(bfTool.matches)} VS {\(kmpTool.matches)}")
            }
        }
    }
    
    func testTenTimesWithThreeWord() {
        
        let bfTool = StringMatchToolBruteForce()
        let kmpTool = StringMatchTool()
        
        for _ in 0..<10 {
            
            let sentence = sentence()
            let words = [word(), word(), word()]
            
            bfTool.findMatches(text: sentence, words: words)
            kmpTool.findMatches(text: sentence, words: words)
            
            if !compare(matches1: bfTool.matches, matches2: kmpTool.matches, count: sentence.count) {
                XCTFail("\(sentence) did not match \(words) {\(bfTool.matches)} VS {\(kmpTool.matches)}")
            }
        }
    }
    
    func testTenTimesOnTenSentencesWithOneWord() {
        
        let bfTool = StringMatchToolBruteForce()
        let kmpTool = StringMatchTool()
        
        for _ in 0..<10 {
            
            let sentence = sentence()
            
            for _ in 0..<10 {
                let words = [word()]
                bfTool.findMatches(text: sentence, words: words)
                kmpTool.findMatches(text: sentence, words: words)
                
                if !compare(matches1: bfTool.matches, matches2: kmpTool.matches, count: sentence.count) {
                    XCTFail("\(sentence) did not match \(words) {\(bfTool.matches)} VS {\(kmpTool.matches)}")
                }
            }
        }
    }
    
    
    func testTenTimesOnTenLongSentencesWithOneWord() {
        
        let bfTool = StringMatchToolBruteForce()
        let kmpTool = StringMatchTool()
        
        for _ in 0..<10 {
            
            let sentence = longSentence()
            
            for _ in 0..<10 {
                let words = [word()]
                bfTool.findMatches(text: sentence, words: words)
                kmpTool.findMatches(text: sentence, words: words)
                
                if !compare(matches1: bfTool.matches, matches2: kmpTool.matches, count: sentence.count) {
                    XCTFail("\(sentence) did not match \(words) {\(bfTool.matches)} VS {\(kmpTool.matches)}")
                }
            }
        }
    }
    
    func testTenTimesOnTenSentencesWithOneLongWord() {
        
        let bfTool = StringMatchToolBruteForce()
        let kmpTool = StringMatchTool()
        
        for _ in 0..<10 {
            
            let sentence = sentence()
            
            for _ in 0..<10 {
                let words = [longWord()]
                bfTool.findMatches(text: sentence, words: words)
                kmpTool.findMatches(text: sentence, words: words)
                
                if !compare(matches1: bfTool.matches, matches2: kmpTool.matches, count: sentence.count) {
                    XCTFail("\(sentence) did not match \(words) {\(bfTool.matches)} VS {\(kmpTool.matches)}")
                }
            }
        }
    }
    
    let logHandler = OSLog(subsystem: "com.random.profiler", category: "qos-measuring")
    
    func testStress() {
        
        var bfTool = StringMatchToolBruteForce()
        var kmpTool = StringMatchTool()
        
        var outerLoops = 1_000
        
        while outerLoops > 0 {
            
            if Int.random(in: 0...100) == 0 { bfTool = StringMatchToolBruteForce() }
            if Int.random(in: 0...100) == 0 { kmpTool = StringMatchTool() }
            
            let sentence = Bool.random() ? sentence() : longSentence()
            
            var configurationLoops = Int.random(in: 0...3)
            
            while configurationLoops > 0 {
                
                var words = [[Character]]()
                
                for _ in 0..<5 {
                    let type = Int.random(in: 0...3)
                    if type == 1 {
                        words.append(word())
                    }
                    if type == 2 {
                        words.append(longWord())
                    }
                }
                
                os_signpost(.begin, log: logHandler, name: "bf")
                bfTool.findMatches(text: sentence, words: words)
                os_signpost(.end, log: logHandler, name: "bf")
              
                
                os_signpost(.begin, log: logHandler, name: "kmp")
                kmpTool.findMatches(text: sentence, words: words)
                os_signpost(.end, log: logHandler, name: "kmp")
                
                if !compare(matches1: bfTool.matches, matches2: kmpTool.matches, count: sentence.count) {
                    XCTFail("\(sentence) did not match \(words) {\(bfTool.matches)} VS {\(kmpTool.matches)}")
                }
                
                configurationLoops -= 1
            }
            
            outerLoops -= 1
        }
        
        
        
    }

}
