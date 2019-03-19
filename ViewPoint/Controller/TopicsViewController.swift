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

    var datasource: [Topic] = Topic.topicList

    // MARK: Lifecycle 🌎

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func openDetailView(for indexPath: IndexPath) {
        let id = String(describing: DetailViewController.self)
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? DetailViewController else { return }
        let topic = datasource[indexPath.row]
        detailViewController.title = topic.title
        expand(viewController: detailViewController)
    }
}

// MARK: - Setup ⛏

extension TopicsViewController {

    func setup() {
        view.layer.contents = #imageLiteral(resourceName: "horizontalGradient").cgImage
        // tableView.backgroundColor = MyColors.GRAY
        tableView.register(UINib(nibName: "DemoElongationCell", bundle: nil), forCellReuseIdentifier: "topic")
    }
}

// MARK: - TableView 📚

extension TopicsViewController {

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topic", for: indexPath) as! DemoElongationCell
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        guard let cell = cell as? DemoElongationCell else { return }

        let topic = datasource[indexPath.row]
        
        let attributedLocality = NSMutableAttributedString(string: topic.title, attributes: [
            NSAttributedString.Key.kern: 4,
        ])

        cell.topImageView?.image = UIImage(named: topic.imageName)
        cell.localityLabel?.attributedText = attributedLocality
        cell.countryLabel?.text = topic.title
        cell.aboutTitleLabel?.text = topic.title
        cell.aboutDescriptionLabel?.text = topic.title
    }
}
