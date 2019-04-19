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
        
        let searchButton = UIButton(type: .custom)
        searchButton.addTarget(self, action: #selector(self.searchButtonPressed), for: .touchUpInside)
        let searchIcon = UIImage(named: "search")!
        let searchButtonSize = CGFloat(MyDimensions.navBarSearchButtonSize)
        let searchIconScaled = searchIcon.af_imageAspectScaled(toFit: CGSize(width: searchButtonSize, height: searchButtonSize))
        searchButton.setImage(searchIconScaled, for: .normal)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = searchBarButton
        
        tableView.register(UINib(nibName: "TopicPreviewCell", bundle: nil), forCellReuseIdentifier: "topic")
    }
    
    @objc func searchButtonPressed() {
        
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
