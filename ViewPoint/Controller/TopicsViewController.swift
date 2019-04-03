//
//  ViewController.swift
//  ElongationPreviewDemo
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import ElongationPreview
import UIKit

final class TopicsViewController: ElongationViewController {

    var topicList: [Topic] = TopicDatabase.topicList

    // MARK: Lifecycle 🌎

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view.layer.contents = #imageLiteral(resourceName: "horizontalGradient").cgImage
        
        tableView.backgroundColor = UIColor.black
        
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        
        tableView.register(UINib(nibName: "TopicPreviewCell", bundle: nil), forCellReuseIdentifier: "topic")
    }

    override func openDetailView(for indexPath: IndexPath) {
        guard let topicDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "topicDetailViewController") as? TopicDetailViewController else { return }
        expand(viewController: topicDetailViewController)
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return topicList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topic", for: indexPath) as! TopicPreviewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        guard let cell = cell as? TopicPreviewCell else { return }
        
        let topic = topicList[indexPath.row]
        
        let spacedTitle = NSMutableAttributedString(string: topic.title, attributes: [
            NSAttributedString.Key.kern: MyFont.topicPreviewTitleKern,
        ])
        
        cell.topImageView?.image = UIImage(named: topic.imageName)
        cell.localityLabel?.attributedText = spacedTitle
        cell.countryLabel?.text = topic.category
        cell.aboutTitleLabel?.text = topic.title
        cell.aboutDescriptionLabel?.text = topic.title
        cell.bottomViewHeight.constant = CGFloat(MyDimensions.bottomViewHeight)
    }
    
}
