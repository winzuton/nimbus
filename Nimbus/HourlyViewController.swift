//
//  HourlyViewController.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/09.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit

class HourlyViewController: UIViewController {
    
    // delegate for scroll to main?
    @IBOutlet weak var hourlyScrollView: UIScrollView!
    
    @IBOutlet weak var nowView: UIView!
    
    @IBOutlet weak var hoursTitleView: UIView!
    
    
    weak var refreshControlDelegate: RefreshControlDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        hourlyScrollView.refreshControl = refreshControl
        
        // Lines
        
        let viewWidth = self.view.bounds.size.width
        let viewHeight = nowView.frame.size.height
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 1))
        topLine.backgroundColor = UIColor.lightGray
        nowView.addSubview(topLine)
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: viewHeight, width: viewWidth, height: 1))
        bottomLine.backgroundColor = UIColor.lightGray
        nowView.addSubview(bottomLine)
        
        let hoursTitleViewHeight = hoursTitleView.frame.size.height
        let bottomLine2 = UIView(frame: CGRect(x: 0, y: hoursTitleViewHeight, width: viewWidth, height: 1))
        bottomLine2.backgroundColor = UIColor.lightGray
        hoursTitleView.addSubview(bottomLine2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(refreshControl: UIRefreshControl) {
        refreshControlDelegate?.refreshControl(self, refreshControl)
    }
    
    // Also called after refresh scroll 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hourlyScrollView.setContentOffset(CGPoint(x: 0.0, y: 20.0), animated: true)
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

