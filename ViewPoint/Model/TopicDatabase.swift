//
//  Topic.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/19/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import Foundation

struct TopicDatabase {
    
    static var iOSvsAndroidSurvey: [SurveyQuestion] {
        
        let question1 = SurveyQuestion(
            questionText: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
            answerChoice1: "Yes",
            answerChoice2: "No"
        )
        let question2 = SurveyQuestion(
            questionText: "My very nice mother just baked me nine pies.",
            answerChoice1: "Yes",
            answerChoice2: "No"
        )
        let question3 = SurveyQuestion(
            questionText: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
            answerChoice1: "Yes",
            answerChoice2: "No"
        )
        
        return [question1, question2, question3]
    }
    
    static var iOSvsAndroid = Topic(
        title: "iOS vs Android",
        category: "Technology",
        identifier: "iOSvsAndroid",
        survey: iOSvsAndroidSurvey
    )
    
    static var marijuana = Topic(
        title: "Legalizing Marijuana",
        category: "Public Policy",
        identifier: "marijuana",
        survey: iOSvsAndroidSurvey
    )
    
    static var abortion = Topic(
        title: "Abortion",
        category: "Public Policy",
        identifier: "abortion",
        survey: iOSvsAndroidSurvey
    )
    
    static var healthCare = Topic(
        title: "Health Care",
        category: "Public Policy",
        identifier: "healthCare",
        survey: iOSvsAndroidSurvey
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
    let answerChoice1: String
    let answerChoice2: String
    
    init(questionText: String, answerChoice1: String, answerChoice2: String) {
        self.questionText = questionText
        self.answerChoice1 = answerChoice1
        self.answerChoice2 = answerChoice2
    }
}
