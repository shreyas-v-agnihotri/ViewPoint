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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationView = NavigationView.init(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height-50),
                                             middleView: MiddleView(),
                                             screens: [
                                                ScreenObject(title: "MUSIC",
                                                             startColor: .red,
                                                             endColor: .blue,
                                                             image: UIImage(named : "clouds")!,
                                                             controller: ProfileViewController()),
                                                
                                                ScreenObject(title: "EDUCATION",
                                                             startColor: .black,
                                                             endColor: .white,
                                                             image: UIImage(named : "clouds")!,
                                                             controller: ProfileViewController()),
                                                ],
                                             backgroundImage: UIImage(named: "verticalGradient")!)
        
        navigationView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(navigationView!)
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
