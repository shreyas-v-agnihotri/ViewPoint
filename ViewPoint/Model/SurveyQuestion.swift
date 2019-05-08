//
//  SurveyQuestion.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 5/8/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

class SurveyQuestion {
    
    let questionText: String
    let answerChoices: [String]
    
    init(questionText: String, answerChoices: [String]) {
        self.questionText = questionText
        self.answerChoices = answerChoices
    }
}
