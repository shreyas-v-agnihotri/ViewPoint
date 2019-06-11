//
//  OpponentProfileViewController.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 6/11/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Presentr

class OpponentProfileViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var viewpointsView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var viewpointsTableView: UITableView!
    
    var userImage: UIImage = UIImage(named: "defaultProfilePic")!
    var opponentImage: UIImage = UIImage(named: "defaultProfilePic")!
    var questions: [String] = []
    var userAnswers: [String] = []
    var opponentAnswers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.tintColor = UIColor.clear
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(patternImage: UIImage(named: "horizontalGradient")!), NSAttributedString.Key.font: UIFont(name: MyFont.pageControlSelectedFont, size: CGFloat(MyFont.pageControlSize))!], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: MyColors.DISABLED_BLACK, NSAttributedString.Key.font: UIFont(name: MyFont.pageControlFont, size: CGFloat(MyFont.pageControlSize))!], for: .normal)
        
        viewpointsTableView.delegate = self
        viewpointsTableView.dataSource = self
        viewpointsTableView.register(UINib(nibName: "ViewpointsTableViewCell", bundle: nil), forCellReuseIdentifier: "viewpoints")
        viewpointsTableView.rowHeight = UITableView.automaticDimension
        viewpointsTableView.estimatedRowHeight = 200

        viewpointsView.clipsToBounds = true
        settingsView.clipsToBounds = true

        viewpointsView.layer.cornerRadius = MyDimensions.profileViewRadius
        settingsView.layer.cornerRadius = MyDimensions.profileViewRadius
        
        viewpointsView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        settingsView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewpointsView.isHidden = false
            settingsView.isHidden = true
        case 1:
            viewpointsView.isHidden = true
            settingsView.isHidden = false
        default:
            break;
        }
    }
    
    func matchUserToAnswers(userIndex: Int, opponentIndex: Int, user1Answers: [String], user2Answers: [String]) -> ([String], [String]) {
        var answers: ([String], [String])
        (userIndex < opponentIndex) ? (answers = (user1Answers, user2Answers)) : (answers = (user2Answers, user1Answers))
        
        return answers
    }
    
    func present(userImage: UIImage, opponentImage: UIImage, questions: [String], user1Answers: [String], user2Answers: [String], userIndex: Int, opponentIndex: Int) -> Presentr {
        
        self.userImage = userImage
        self.opponentImage = opponentImage
        self.questions = questions
        (self.userAnswers, self.opponentAnswers) = matchUserToAnswers(userIndex: userIndex, opponentIndex: opponentIndex, user1Answers: user1Answers, user2Answers: user2Answers)
        
        let presenter: Presentr = {
            
            let customPresenter = Presentr(presentationType: .popup)
            customPresenter.transitionType = .coverVerticalFromTop
            
            //            customPresenter.transitionType = .coverHorizontalFromRight
            customPresenter.dismissOnSwipe = true
            customPresenter.cornerRadius = MyDimensions.profileViewRadius
            
            customPresenter.dropShadow = PresentrShadow(shadowColor: UIColor.darkGray, shadowOpacity: 0.6, shadowOffset: CGSize(width: 0, height: 2.0), shadowRadius: 2)
            
            return customPresenter
        }()
        
        return presenter
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewpoints", for: indexPath) as! ViewpointsTableViewCell
        
        cell.customInit(
            question: questions[indexPath.row],
            userImage: self.userImage,
            userAnswer: userAnswers[indexPath.row],
            opponentImage: self.opponentImage,
            opponentAnswer: opponentAnswers[indexPath.row]
        )
        
        return cell

    }
    
}
