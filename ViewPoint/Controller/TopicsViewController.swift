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
        
        tableView.backgroundColor = UIColor.black

//        navigationItem.largeTitleDisplayMode = .never

//        tableView.bounces = false
//        tableView.alwaysBounceVertical = false
        
        // Add action for search later
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)

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
        cell.customInit(topic: topic)
        
    }
    
}
