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
            question: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
            answerChoice1: "Yes",
            answerChoice2: "No"
        )
        let question2 = SurveyQuestion(
            question: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
            answerChoice1: "Yes",
            answerChoice2: "No"
        )
        let question3 = SurveyQuestion(
            question: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
            answerChoice1: "Yes",
            answerChoice2: "No"
        )
        
        return [question1, question2, question3]
    }
    
    static var iOSvsAndroid = Topic(
        title: "iOS vs Android",
        category: "Technology",
        imageName: "iOSvsAndroid",
        survey: iOSvsAndroidSurvey
    )
    
    static var marijuana = Topic(
        title: "Legalizing Marijuana",
        category: "Public Policy",
        imageName: "marijuana",
        survey: iOSvsAndroidSurvey
    )
    
    static var abortion = Topic(
        title: "Abortion",
        category: "Public Policy",
        imageName: "abortion",
        survey: iOSvsAndroidSurvey
    )
    
    static var healthCare = Topic(
        title: "Health Care",
        category: "Public Policy",
        imageName: "healthCare",
        survey: iOSvsAndroidSurvey
    )
    
    static var topicList: [Topic] {
        
        return [
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
    let imageName: String
    let survey: [SurveyQuestion]
    
    init(title: String, category: String, imageName: String, survey: [SurveyQuestion]) {
        self.title = title
        self.category = category
        self.imageName = imageName
        self.survey = survey
    }
}

struct SurveyQuestion {
    
    let question: String
    let answerChoice1: String
    let answerChoice2: String
    
    init(question: String, answerChoice1: String, answerChoice2: String) {
        self.question = question
        self.answerChoice1 = answerChoice1
        self.answerChoice2 = answerChoice2
    }
}
