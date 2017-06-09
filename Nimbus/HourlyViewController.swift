//
//  HourlyViewController.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/09.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit

class HourlyViewController: UIViewController {
    
    @IBOutlet weak var tryLabel: UILabel!
    
    // delegate for scroll to main?
    @IBOutlet weak var hourlyScrollView: UIScrollView!
    
    weak var refreshControlDelegate: RefreshControlDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        hourlyScrollView.refreshControl = refreshControl
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(refreshControl: UIRefreshControl) {
        refreshControlDelegate?.refreshControl(self, refreshControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews() // important
        hourlyScrollView.setContentOffset(CGPoint(x: 0.0, y: 30.0), animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Custom delegate for refresh scroll
protocol RefreshControlDelegate: class {
    
    func refreshControl(_ viewController: UIViewController, _ refreshControl: UIRefreshControl)
    
}

