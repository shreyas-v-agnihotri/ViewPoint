//
//  Topic.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/19/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import Foundation
import UIKit

struct TopicDatabase {
    
    static var testSurvey: [SurveyQuestion] {
        
        let question1 = SurveyQuestion(
            questionText: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
            answerChoices: ["Yes", "No"]
        )
        let question2 = SurveyQuestion(
            questionText: "My very nice mother just baked me nine pies.",
            answerChoices: ["Yes", "No"]
        )
        let question3 = SurveyQuestion(
            questionText: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
            answerChoices: ["Yes", "No"]
        )
        
        return [question1, question2, question3]
    }
    
    static var iOSvsAndroid = Topic(
        title: "iOS vs Android",
        category: "Technology",
        identifier: "iOSvsAndroid",
        survey: testSurvey
    )
    
    static var marijuana = Topic(
        title: "Legalizing Marijuana",
        category: "Public Policy",
        identifier: "marijuana",
        survey: testSurvey
    )
    
    static var abortion = Topic(
        title: "Abortion",
        category: "Public Policy",
        identifier: "abortion",
        survey: testSurvey
    )
    
    static var healthCare = Topic(
        title: "Health Care",
        category: "Public Policy",
        identifier: "healthCare",
        survey: testSurvey
    )
    
    static var topicList: [Topic] {
        
        return [
            iOSvsAndroid,
            marijuana,
            abortion,
            healthCare,
            iOSvsAndroid,
            marijuana,
            abortion,
            healthCare
            // Dogs vs Cats
            // Gun Control
            // Minimum Wage
            // Electoral College
        ]
    }
}

struct Topic {
    
    let title: String
    let category: String
    let identifier: String
    let survey: [SurveyQuestion]
    
    init(title: String, category: String, identifier: String, survey: [SurveyQuestion]) {
        self.title = title
        self.category = category
        self.identifier = identifier
        self.survey = survey
    }
}

struct SurveyQuestion {
    
    let questionText: String
    let answerChoices: [String]
    
    init(questionText: String, answerChoices: [String]) {
        self.questionText = questionText
        self.answerChoices = answerChoices
    }
}
