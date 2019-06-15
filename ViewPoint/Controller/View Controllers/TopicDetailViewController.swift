//
//  DetailViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 14/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import ElongationPreview
import UIKit
import NVActivityIndicatorView
import Firebase

final class TopicDetailViewController: ElongationDetailViewController, NVActivityIndicatorViewable {
    
    // Default; changed on init
    let db = Firestore.firestore()
    var topic: Topic = TopicDatabase.topicList[0]   // default topic
    var reference: CollectionReference?
    
    var selectedAnswers = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable scrolling, add swipe down to close
        self.view.gestureRecognizers?.removeAll()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.closeView))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
                
        configureTableView()

    }
    
    func customInit(topic: Topic, topicPreviewCell: TopicPreviewCell) {
        self.topic = topic
        
        topicPreviewCell.researchButton.addTarget(self, action:#selector(researchPressed), for: .touchUpInside)
                
        reference = db.collection("requests")
//        topicsVC.addChild(self)
//        reference = db.collection(["topics", topic.identifier, "chatRequests"].joined(separator: "/"))
    }
    
    @objc func researchPressed() {
        print("research")
    }
    
    func configureTableView() {
        tableView.showsVerticalScrollIndicator = false
        view.layer.backgroundColor = MyColors.WHITE.cgColor
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib(nibName: "SurveyCell", bundle: nil), forCellReuseIdentifier: "survey")
    }
    
    @objc func closeView(gesture: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "survey", for: indexPath) as! SurveyCell
        cell.customInit(topic: topic, parentVC: self)
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return CGFloat(MyDimensions.detailViewHeight)
    }
    
    func addAnswer(choice: String) {
        selectedAnswers.append(choice)
    }
    
    func findDebate() {
        
        print("sending request")
        
        startAnimating(
            message: "Sending your debate request...",
            messageFont: UIFont(name: MyFont.loadingFont, size: CGFloat(MyFont.navBarSmallFontSize)),
            type: .ballScaleMultiple
        )
        
        // Probably should add a state change listener to make sure user is not nil
        let user = Auth.auth().currentUser
        
        var questions = [String]()
        for surveyQuestion in topic.survey {
            questions.append(surveyQuestion.questionText)
        }
        
        let requestRepresentation: [String : Any] = [
            "created": Date(),
            "topic": topic.title,
            "user": user!.uid,
            "userName": user!.displayName as Any,
            "userPhotoURL": user!.photoURL?.absoluteString as Any,
            "answers": selectedAnswers,
            "questions": questions
        ]
        
        reference?.addDocument(data: requestRepresentation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                self.stopAnimating(nil)
                return
            }
            self.stopAnimating(nil)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
        
}

