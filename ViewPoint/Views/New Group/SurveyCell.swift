//
//  GridViewCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 20/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import ElongationPreview

final class SurveyCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var topic: Topic = TopicDatabase.topicList[0]   // Defaults to first topic; changed on init
    var topicDetailVC: TopicDetailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "topicDetailViewController") as! TopicDetailViewController
    
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
            
            questionCell.customInit(question: question, answerOptions: ["Yes", "No"])
            questionCell.surveyCell = self
            
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
        scrollView.isScrollEnabled = false
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false

        for i in 0 ..< questionCells.count {
            questionCells[i].frame = CGRect(x: cellWidth * CGFloat(i), y: 0, width: cellWidth, height: cellHeight)
            scrollView.addSubview(questionCells[i])
        }
    }
    
    func scrollToNextQuestion() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            if CGFloat(self.scrollView.contentOffset.x) / CGFloat(MyDimensions.screenWidth) == CGFloat(self.topic.survey.count-1) {
                
                self.topicDetailVC.findDebate()
                return
            }
            
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + MyDimensions.screenWidth, y: 0), animated: true)
            print("scrolled")
        }
        
    }

}
