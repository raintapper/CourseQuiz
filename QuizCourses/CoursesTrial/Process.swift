//
//  QuizCheckAnswerBrain.swift
//  CoursesTrial
//
//  Created by Barry Chew on 7/8/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import Foundation

class Process {
    
    //questions[i-1].score = checkAnswers(submittedAnswers, questions: questions, index: i-1)
    
    func compareAndReturnBool (correct: [String], answered: [String]) -> Bool {
    
        if correct.count == answered.count {
            return correct.elementsEqual(answered)
        }
        return false
    }
    
    func breakdownStringToChars (string: String) -> [String]{
        var characterDict = [String]()
        for chars in string.characters {
            characterDict.append("\(chars)")
        }
        return characterDict
    }
    
    
}