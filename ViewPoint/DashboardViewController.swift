//
//  DashboardViewController.swift
//  ViewPoint
//
//  Created by Shreyas Agnihotri on 3/15/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Kingfisher

class DashboardViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Auth.auth().addStateDidChangeListener { (auth, currentFirebaseUser) in
            
            if let photoURL = currentFirebaseUser?.photoURL {
                
                let processor = RoundCornerImageProcessor(cornerRadius: 125) >> DownsamplingImageProcessor(size: CGSize(width: 30, height: 30))
                
                KingfisherManager.shared.retrieveImage(with: photoURL, options: [.processor(processor)]) { result in
                    // Do something with `result`
                    
                    switch result {
                    case .success(let value):
                        
                        // If the `cacheType is `.none`, `image` will be `nil`.
                        let button = UIButton(type: .custom)
                        button.setImage(value.image, for: .normal)
                        button.addTarget(self, action: #selector(self.profileButtonPressed), for: .touchUpInside)
                        
                        let barButton = UIBarButtonItem(customView: button)
                        self.navigationItem.leftBarButtonItem = barButton
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                    
                }
                
            }
            
            
            
        }

    }
    
    @objc func profileButtonPressed(sender: UIButton!) {
        
        performSegue(withIdentifier: "goToProfile", sender: self)
        
    }
    
    
}


