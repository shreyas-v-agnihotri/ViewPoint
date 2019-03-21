//
//  GridViewCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 20/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import ElongationPreview
import TwicketSegmentedControl

final class SurveyCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var topic: Topic = TopicDatabase.topicList[0]   // Defaults to first topic; changed on init
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        scrollView.delegate = self
        // scrollView.layer.borderColor = UIColor.clear.cgColor
        
        let questionCells = createQuestionCells()
        setupQuestionsScrollView(questionCells: questionCells)
        
        pageControl.numberOfPages = questionCells.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x/MyDimensions.screenWidth)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func createQuestionCells() -> [SurveyQuestionCell] {
        
        var questionCells = [SurveyQuestionCell]()
            
        for question in topic.survey {
                
            let questionCell: SurveyQuestionCell = Bundle.main.loadNibNamed("SurveyQuestionCell", owner: self, options: nil)?.first as! SurveyQuestionCell
            
            questionCell.questionLabel.text = question.question
            questionCell.questionLabel.font = UIFont(name: MyFont.normal, size: MyFont.questionFontSize)
            questionCell.pageControl.isHidden = true

            let options = ["Yes", "No"]
            let frame = CGRect(x: MyDimensions.screenWidth * (1-MyDimensions.answerChoiceWidthRatio) / 2, y: 0, width: MyDimensions.screenWidth * MyDimensions.answerChoiceWidthRatio, height: questionCell.segmentedControlView.frame.height)
            let segmentedControl = TwicketSegmentedControl(frame: frame)
            segmentedControl.setSegmentItems(options)
            segmentedControl.segmentsBackgroundColor = MyColors.TRANSPARENT_WHITE
            segmentedControl.sliderBackgroundColor = MyColors.WHITE
            segmentedControl.highlightTextColor = MyColors.BLUE
            segmentedControl.defaultTextColor = MyColors.WHITE
            segmentedControl.font = UIFont(name: MyFont.medium, size: MyFont.answerFontSize)!
            segmentedControl.backgroundColor = UIColor.clear
            segmentedControl.isSliderShadowHidden = true
            questionCell.segmentedControlView.addSubview(segmentedControl)
            
            questionCells.append(questionCell)
        }
        
        return questionCells
    }
    
    func setupQuestionsScrollView(questionCells: [SurveyQuestionCell]) {
        
        let cellHeight = CGFloat(MyDimensions.detailViewHeight)
        let cellWidth = MyDimensions.screenWidth
        
        scrollView.frame = CGRect(x: 0, y: 0, width: Int(cellWidth), height: Int(cellHeight))
        scrollView.contentSize = CGSize(width: cellWidth * CGFloat(questionCells.count), height: cellHeight)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0 ..< questionCells.count {
            questionCells[i].frame = CGRect(x: cellWidth * CGFloat(i), y: 0, width: cellWidth, height: cellHeight)
            scrollView.addSubview(questionCells[i])
        }
    }

}
