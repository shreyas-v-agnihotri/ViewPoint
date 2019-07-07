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
    
    static var immigration = Topic(
        title: "Immigration",
        category: "Public Policy",
        identifier: "marijuana",
        researchLink: "https://immigration.procon.org/",
        survey: [
            SurveyQuestion(
                questionText: "Is a country warranted in imposing temporary bans on all immigration?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Is it a country's responsibility to accept foreign refugees?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Is a wall an effective way to limit unwanted immigration?",
                answerChoices: ["Yes", "No"]
            ),
        ]
    )
    
    static var marijuana = Topic(
        title: "Legalizing Marijuana",
        category: "Public Policy",
        identifier: "marijuana",
        researchLink: "https://marijuana.procon.org/",
        survey: [
            SurveyQuestion(
                questionText: "Should recreational marijuana be universally legalized?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Should medical marijuana be universally legalized?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Would you ever smoke marijuana or consume a marijuana product recreationally?",
                answerChoices: ["Yes", "No"]
            ),
        ]
    )
    
    static var abortion = Topic(
        title: "Abortion",
        category: "Public Policy",
        identifier: "abortion",
        researchLink: "https://abortion.procon.org/",
        survey: [
            SurveyQuestion(
                questionText: "Should the government continue to fund Planned Parenthood?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Do you consider yourself to be more pro-choice or pro-life?",
                answerChoices: ["Pro-Choice", "Pro-Life"]
            ),
            SurveyQuestion(
                questionText: "Is access to birth control a fundamental right?",
                answerChoices: ["Yes", "No"]
            ),
        ]
    )
    
    static var healthCare = Topic(
        title: "Health Care",
        category: "Public Policy",
        identifier: "healthCare",
        researchLink: "https://healthcare.procon.org/",
        survey: [
            SurveyQuestion(
                questionText: "Should health insurers be allowed to deny coverage to people with a pre-existing condition?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Should the government regulate the prices of life-saving drugs?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "- [ ] Should all people be required to have a basic level of health insurance coverage?",
                answerChoices: ["Yes", "No"]
            ),
        ]
    )
    
    static var antiTerrorism = Topic(
        title: "Anti-Terrorism",
        category: "Public Policy",
        identifier: "marijuana",
        researchLink: "https://www.isidewith.com/poll/46492877",
        survey: [
            SurveyQuestion(
                questionText: "Should the President be able to authorize military force against terrorist groups without Congressional approval?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Should we actively try to assassinate suspected terrorists in foreign countries?",
                answerChoices: ["Yes", "No"]
            )
        ]
    )
    
    static var gunControl = Topic(
        title: "Gun Control",
        category: "Public Policy",
        identifier: "marijuana",
        researchLink: "https://gun-control.procon.org/",
        survey: [
            SurveyQuestion(
                questionText: "Should a normal civilian be legally permitted to own a gun?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Should there be more restrictions on the current process of purchasing a gun?",
                answerChoices: ["Yes", "No"]
            )
        ]
    )
    
    static var environmentalism = Topic(
        title: "Environmentalism",
        category: "Public Policy",
        identifier: "marijuana",
        researchLink: "https://climatechange.procon.org/",
        survey: [
            SurveyQuestion(
                questionText: "Should the government increase environmental regulations to prevent climate change?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Are climate change and global warming serious threats to humanity?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Do you agree with bans and restrictions on plastic and other non-biodegradable materials?",
                answerChoices: ["Yes", "No"]
            )
        ]
    )
    
    static var diet = Topic(
        title: "Diet",
        category: "Lifestyle",
        identifier: "marijuana",
        researchLink: "https://vegetarian.procon.org/",
        survey: [
            SurveyQuestion(
                questionText: "Would you ever consider going vegetarian or vegan?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Can \"fad\" diets, like keto and paleo, be effective?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Would you replace meat in your food with plant-based alternatives if they tasted the same?",
                answerChoices: ["Yes", "No"]
            )
        ]
    )
    
    static var pets = Topic(
        title: "Pets",
        category: "Lifestyle",
        identifier: "marijuana",
        researchLink: "https://www.diffen.com/difference/Cat_vs_Dog",
        survey: [
            SurveyQuestion(
                questionText: "Would you or have you ever owned a pet?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "If you had to choose, would you rather have a cat or a dog?",
                answerChoices: ["Cat", "Dog"]
            ),
        ]
    )
    
    static var socialMedia = Topic(
        title: "Social Media",
        category: "Technology",
        identifier: "marijuana",
        researchLink: "https://socialnetworking.procon.org/",
        survey: [
            SurveyQuestion(
                questionText: "Does social media make it harder to have meaningful relationships?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Do you trust social media companies not to misuse data?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Would you ever consider going \"off grid\" and taking a break from social networks?",
                answerChoices: ["Yes", "No"]
            )
        ]
    )
    
    static var artificialIntelligence = Topic(
        title: "Artificial Intelligence",
        category: "Technology",
        identifier: "marijuana",
        researchLink: "https://futureoflife.org/background/benefits-risks-of-artificial-intelligence/",
        survey: [
            SurveyQuestion(
                questionText: "Will humans ever create true artificial intelligence?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Is artificial intelligence dangerous to society?",
                answerChoices: ["Yes", "No"]
            ),
            SurveyQuestion(
                questionText: "Should we continue to try to create artificial intelligence and smart personal assistants?",
                answerChoices: ["Yes", "No"]
            )
        ]
    )
    
    static var topicList: [Topic] {
        
        return [
            gunControl,
            socialMedia,
            marijuana,
            artificialIntelligence,
            abortion,
            diet,
            environmentalism,
            pets,
            antiTerrorism,
            healthCare,
            immigration
        ]
    }
}
