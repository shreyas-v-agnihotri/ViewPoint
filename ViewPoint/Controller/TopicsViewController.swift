//
//  ViewController.swift
//  ElongationPreviewDemo
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import ElongationPreview
import UIKit

final class TopicsViewController: ElongationViewController, UISearchBarDelegate {
    
    var topicList: [Topic] = TopicDatabase.topicList
    
    let searchBar = UISearchBar()

    // MARK: Lifecycle 🌎

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setSearchBar()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        topicList = TopicDatabase.topicList
        tableView.reloadData()
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText != "") {
            topicList = TopicDatabase.topicList.filter { (topic) -> Bool in
                topic.contains(query: searchText)
            }
        } else {
            topicList = TopicDatabase.topicList
        }
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.backgroundColor = UIColor.black
        tableView.register(UINib(nibName: "TopicPreviewCell", bundle: nil), forCellReuseIdentifier: "topic")
    }

    func setSearchBar() {
        searchBar.delegate = self
        searchBar.isTranslucent = true
        searchBar.searchBarStyle = .minimal
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = MyColors.WHITE
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = MyColors.WHITE
        
        let searchBarView = UIView()
        searchBarView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        searchBar.frame = CGRect(x: -5, y: -10, width: (navigationController?.view.bounds.size.width)!-55, height: 60)
        searchBarView.addSubview(self.searchBar)
        
        self.navigationItem.titleView = searchBarView
    }
    
    override func openDetailView(for indexPath: IndexPath) {
        
//        searchBar.resignFirstResponder()
//        searchBar.showsCancelButton = false
//        searchBar.text = ""
        
        guard let topicDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "topicDetailViewController") as? TopicDetailViewController else { return }
        
        let topic = topicList[indexPath.row]
        topicDetailViewController.customInit(topic: topic)
        expand(viewController: topicDetailViewController)
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return topicList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topic", for: indexPath) as! TopicPreviewCell
        
        let topic = topicList[indexPath.row]
        cell.customInit(topic: topic)
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
//        guard let cell = cell as? TopicPreviewCell else { return }
//
//
//    }
    
}
