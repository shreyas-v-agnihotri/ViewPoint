//
//  Surveyself.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/18/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import TwicketSegmentedControl

class SurveyQuestionCell: UITableViewCell, TwicketSegmentedControlDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var segmentedControlView: UIView!
    @IBOutlet weak var background: UIImageView!
    var surveyCell: SurveyCell = Bundle.main.loadNibNamed("SurveyCell", owner: self, options: nil)?.first as! SurveyCell
    var options: [String] = []
    
    func customInit(question: SurveyQuestion) {
        
        self.questionLabel.text = question.questionText
        options = question.answerChoices

        self.questionLabel.font = UIFont(name: MyFont.questionFont, size: MyFont.questionFontSize)
        self.pageControl.isHidden = true
        
//        self.background.layer.masksToBounds = false
//        self.background.layer.shadowColor = UIColor.darkGray.cgColor
//        self.background.layer.shadowOffset = CGSize(width: 0, height: -2)
//        self.background.layer.shadowRadius = 6
//        self.background.layer.shadowOpacity = 0.6
        
        let frame = CGRect(x: MyDimensions.screenWidth * (1-MyDimensions.answerChoiceWidthRatio) / 2, y: 0, width: MyDimensions.screenWidth * MyDimensions.answerChoiceWidthRatio, height: self.segmentedControlView.frame.height)
        
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(options)
        segmentedControl.segmentsBackgroundColor = MyColors.TRANSPARENT_BLACK
        segmentedControl.sliderBackgroundColor = MyColors.WHITE
        segmentedControl.highlightTextColor = MyColors.BLUE
        segmentedControl.defaultTextColor = MyColors.WHITE
        segmentedControl.font = UIFont(name: MyFont.answerFont, size: MyFont.answerFontSize)!
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.isSliderShadowHidden = true
        segmentedControl.move(to: -1)   // No selection on default
        
        segmentedControl.delegate = self
        self.segmentedControlView.addSubview(segmentedControl)
    }
    
    
    func didSelect(_ segmentIndex: Int) {
        
        surveyCell.addAnswer(choice: options[segmentIndex])
        surveyCell.scrollToNextQuestion()
    }
    
}
