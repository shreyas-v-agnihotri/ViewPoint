//
//  SwipableTableViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 17/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit

/**

 UITableViewController subclass.

 Base class for `ElongationViewController` & `ElongationDetailViewController`.

 */
open class SwipableTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var panGestureRecognizer: UIPanGestureRecognizer!
    var startY: CGFloat = 0
    var swipedView: UIView?

    /// :nodoc:
    open override func viewDidLoad() {
        super.viewDidLoad()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognizerSwiped(_:)))
        panGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(panGestureRecognizer)
        
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 0
        tableView.layer.borderWidth = 0
        tableView.layer.borderColor = UIColor.clear.cgColor
        
    }

    @objc func gestureRecognizerSwiped(_: UIPanGestureRecognizer) {}

    /// :nodoc:
    public func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}
