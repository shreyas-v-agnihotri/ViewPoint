//
//  Topic.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 5/8/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

class Topic {
    
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
    
    func contains(query: String) -> Bool {
        return title.lowercased().contains(query.lowercased()) || category.lowercased().contains(query.lowercased())
    }
}

