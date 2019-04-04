//
//  DetailViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 14/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import ElongationPreview
import UIKit

final class TopicDetailViewController: ElongationDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable scrolling (but not horizontal within the survey view)
        self.view.gestureRecognizers?.removeAll()
//        tableView.isScrollEnabled = false
        
//        view.layer.contents = #imageLiteral(resourceName: "horizontalGradient").cgImage
        tableView.backgroundColor = UIColor.clear
        
        tableView.register(UINib(nibName: "SurveyCell", bundle: nil), forCellReuseIdentifier: "survey")
        

    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "survey", for: indexPath) as! SurveyCell
        cell.topic = TopicDatabase.topicList[indexPath.row]
        cell.pageControl.isHidden = false
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return CGFloat(MyDimensions.detailViewHeight)
    }
}

