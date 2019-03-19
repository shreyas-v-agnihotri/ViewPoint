//
//  GridViewCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 20/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import ElongationPreview

final class GridViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        scrollView.delegate = self
        
        let questions = createQuestions()
        setupQuestionsScrollView(questions: questions)
        
        pageControl.numberOfPages = questions.count
        pageControl.currentPage = 0
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x/screenWidth)
        pageControl.currentPage = Int(pageNumber)
        print("\n\(pageNumber)\n")
    }

    func createQuestions() -> [SurveyQuestionView] {
        
        let question1: SurveyQuestionView = Bundle.main.loadNibNamed("SurveyQuestionView", owner: self, options: nil)?.first as! SurveyQuestionView
        question1.questionLabel.text = "Do you think medical marijuana should be legalized in every US state?"
        question1.firstButton.setTitle("Yes", for: .normal)
        question1.secondButton.setTitle("No", for: .normal)
        question1.pageControl.isHidden = true
        
        let question2: SurveyQuestionView = Bundle.main.loadNibNamed("SurveyQuestionView", owner: self, options: nil)?.first as! SurveyQuestionView
        question2.questionLabel.text = "Do you think recreational marijuana should be legalized in every US state?"
        question2.firstButton.setTitle("Yes", for: .normal)
        question2.secondButton.setTitle("No", for: .normal)
        question2.pageControl.isHidden = true
        
        let question3: SurveyQuestionView = Bundle.main.loadNibNamed("SurveyQuestionView", owner: self, options: nil)?.first as! SurveyQuestionView
        question3.questionLabel.text = "Do you believe that marijuana has valuable medicinal properties?"
        question3.firstButton.setTitle("Yes", for: .normal)
        question3.secondButton.setTitle("No", for: .normal)
        question3.pageControl.isHidden = true
        
        return [question1, question2, question3]
    }
    
    func setupQuestionsScrollView(questions: [SurveyQuestionView]) {
        
        let headerHeight = ElongationConfig.shared.topViewHeight + ElongationConfig.shared.bottomViewHeight
        // let cellHeight = screenHeight - headerHeight + 20
        let cellHeight = 200
        let cellWidth = screenWidth
        
        scrollView.frame = CGRect(x: 0, y: 0, width: Int(cellWidth), height: cellHeight)
        scrollView.contentSize = CGSize(width: cellWidth * CGFloat(questions.count), height: CGFloat(cellHeight))
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< questions.count {
            questions[i].frame = CGRect(x: cellWidth * CGFloat(i), y: 0, width: cellWidth, height: CGFloat(cellHeight))
            scrollView.addSubview(questions[i])
        }
    }


}
