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
    var filteredTopics = [Topic]()
    
    let searchBar = UISearchBar()

    // MARK: Lifecycle 🌎

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setSearchButton()
        configureTableView()
        
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
        
        self.extendedLayoutIncludesOpaqueBars = true

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.view.setNeedsLayout() // force update layout
//        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//
//        UIView.animate(withDuration: 0.5, animations: {
//            self.searchBarView.addSubview(self.searchBar)
//
//        })
//    }
//
    
    func configureTableView() {
        tableView.backgroundColor = UIColor.black
        tableView.register(UINib(nibName: "TopicPreviewCell", bundle: nil), forCellReuseIdentifier: "topic")
    }

    func setSearchButton() {
        let searchButton = createBarButton(image: UIImage(named: "search")!, size: MyDimensions.navBarSearchButtonSize)
        searchButton.addTarget(self, action: #selector(self.searchButtonPressed), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = searchBarButton
        
    }
    
    @objc func searchButtonPressed() {
        print("Search pressed")
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(self.cancelButtonPressed))

    }
    
    @objc func cancelButtonPressed() {
//        self.navigationItem.title = ""
    }
    
    override func openDetailView(for indexPath: IndexPath) {
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
