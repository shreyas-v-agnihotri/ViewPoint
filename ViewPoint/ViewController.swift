//
//  ViewController.swift
//  ElongationPreviewDemo
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import ElongationPreview
import UIKit

final class ViewController: ElongationViewController {

    var datasource: [Villa] = Villa.testData

    // MARK: Lifecycle 🌎

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func openDetailView(for indexPath: IndexPath) {
        let id = String(describing: DetailViewController.self)
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? DetailViewController else { return }
        let villa = datasource[indexPath.row]
        detailViewController.title = villa.title
        expand(viewController: detailViewController)
    }
}

// MARK: - Setup ⛏

private extension ViewController {

    func setup() {
        tableView.backgroundColor = UIColor.black
        // tableView.registerNib(DemoElongationCell.self)
        tableView.register(UINib(nibName: "DemoElongationCell", bundle: nil), forCellReuseIdentifier: "topic")
    }
}

// MARK: - TableView 📚

extension ViewController {

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return datasource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeue(DemoElongationCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: "topic", for: indexPath) as! DemoElongationCell
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        guard let cell = cell as? DemoElongationCell else { return }

        let villa = datasource[indexPath.row]

        let attributedLocality = NSMutableAttributedString(string: villa.locality.uppercased(), attributes: [
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-medium", size: 22)!,
            NSAttributedString.Key.kern: 8.2,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ])

        // cell.topImageView?.image = UIImage(named: villa.imageName)
        cell.topImageView?.image = UIImage(named: "clouds")
        cell.localityLabel?.attributedText = attributedLocality
        cell.countryLabel?.text = villa.country
        cell.aboutTitleLabel?.text = villa.title
        cell.aboutDescriptionLabel?.text = villa.description
    }
}
