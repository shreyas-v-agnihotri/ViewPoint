//
//  TopicsViewController.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/17/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Navigation_Toolbar

class TopicsViewController: UIViewController {

    private var navigationView: NavigationView?
    @IBOutlet weak var topicsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.contents = #imageLiteral(resourceName: "horizontalGradient").cgImage
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
        navigationView = NavigationView.init(frame: topicsView.bounds,
                                             middleView: MiddleView(),
                                             screens: [
                                                ScreenObject(title: "MUSIC",
                                                             startColor: MyColors.GRAY,
                                                             endColor: MyColors.GRAY,
                                                             image: UIImage(named: "clouds")!,
                                                             controller: ProfileViewController()),
                                                
                                                ScreenObject(title: "EDUCATION",
                                                             startColor: MyColors.GRAY,
                                                             endColor: MyColors.GRAY,
                                                             image: UIImage(named: "clouds")!,
                                                             controller: ProfileViewController()),
                                                ],
                                             backgroundImage: UIImage(named: "verticalGradient")!)
        
        navigationView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topicsView.addSubview(navigationView!)
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
