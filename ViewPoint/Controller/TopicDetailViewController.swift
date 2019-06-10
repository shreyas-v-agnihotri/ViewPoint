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
    
    var selectedAnswers = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable scrolling, add swipe down to close
        self.view.gestureRecognizers?.removeAll()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.closeView))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        configureTableView()

    }
    
    func customInit(topic: Topic) {
        self.topic = topic
        reference = db.collection("requests")
//        reference = db.collection(["topics", topic.identifier, "chatRequests"].joined(separator: "/"))
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
    
    func addAnswer(choice: Int) {
        selectedAnswers.append(choice)
    }
    
    func findDebate() {
        
        startAnimating(
            message: "Looking for opposing ViewPoints..." + "\n\(selectedAnswers)",
            messageFont: UIFont(name: MyFont.regular, size: CGFloat(MyFont.navBarSmallFontSize)),
            type: .ballScaleMultiple
        )
        
        // Probably should add a state change listener to make sure user is not nil
        let user = Auth.auth().currentUser
        
        let requestRepresentation: [String : Any] = [
            "created": Date(),
            "topic": topic.title,
            "user": user!.uid,
            "answers": selectedAnswers
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
        
        

//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            self.stopAnimating(nil)
//        }
    }
        
}

