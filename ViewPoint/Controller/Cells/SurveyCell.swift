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
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var pageControl: UIPageControl!
    
    // Defaults; changed on init
    var topic: Topic = TopicDatabase.topicList[0]
    var topicDetailVC: TopicDetailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "topicDetailViewController") as! TopicDetailViewController
    var totalQuestions: Int {
        return topic.survey.count
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        scrollView.delegate = self
        // scrollView.layer.borderColor = UIColor.clear.cgColor
        
        questionTitleLabel.text = "Question 1/\(totalQuestions)"
        questionTitleLabel.font = UIFont(name: MyFont.questionTitleFont, size: MyFont.questionFontSize)
//        pageControl.numberOfPages = questionCells.count
//        pageControl.currentPage = 0
//        pageControl.isUserInteractionEnabled = false
//        pageControl.isHidden = false
    }
    
    func addAnswer(choice: String) {
        topicDetailVC.addAnswer(choice: choice)
    }
    
    func customInit(topic: Topic, parentVC: TopicDetailViewController) {
        self.topic = topic
        self.topicDetailVC = parentVC
        let questionCells = createQuestionCells()
        setupQuestionsScrollView(questionCells: questionCells)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x/MyDimensions.screenWidth))
        questionTitleLabel.text = "Question \(pageNumber+1)/\(totalQuestions)"
//        pageControl.currentPage = Int(pageNumber)
    }
    
    func createQuestionCells() -> [SurveyQuestionCell] {
        
        var questionCells = [SurveyQuestionCell]()
            
        for question in topic.survey {
                
            let questionCell: SurveyQuestionCell = Bundle.main.loadNibNamed("SurveyQuestionCell", owner: self, options: nil)?.first as! SurveyQuestionCell
            
            questionCell.customInit(question: question)
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + MyAnimations.questionScrollTime) {
            if CGFloat(self.scrollView.contentOffset.x) / CGFloat(MyDimensions.screenWidth) == CGFloat(self.topic.survey.count-1) {
                
                self.topicDetailVC.findDebate()
                return
            }
            
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + MyDimensions.screenWidth, y: 0), animated: true)
        }
        
    }

}
