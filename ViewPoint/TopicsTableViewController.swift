//
//  TopicsTableViewController.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/17/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit

class TopicsTableViewCell: UITableViewCell
{
    @IBOutlet weak var topicLabel: UILabel!
    
}


class TopicsTableViewController: UITableViewController {
    
    let cellSpacing: CGFloat = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.contents = #imageLiteral(resourceName: "verticalGradient").cgImage
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return topics.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacing
    }
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "topic", for: indexPath) as! TopicsTableViewCell

        cell.topicLabel.text = topics[indexPath.section].title

        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
