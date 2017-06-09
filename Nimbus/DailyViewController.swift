//
//  DailyViewController.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/09.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController {
    
    @IBOutlet weak var tryLabel2: UILabel!
    
    @IBOutlet weak var dailyScollView: UIScrollView!
    
    weak var refreshControlDelegate: RefreshControlDelegate?
    weak var dailyViewDidLoadDelegate: DailyViewDidLoadDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        dailyScollView.refreshControl = refreshControl
        
        dailyViewDidLoadDelegate?.dailyViewDidLoad(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(refreshControl: UIRefreshControl) {
        refreshControlDelegate?.refreshControl(self, refreshControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dailyScollView.setContentOffset(CGPoint(x: 0.0, y: 30.0), animated: false)
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

protocol DailyViewDidLoadDelegate: class {
    
    func dailyViewDidLoad(_ viewController: DailyViewController)
    
}

