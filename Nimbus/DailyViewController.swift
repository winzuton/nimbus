//
//  DailyViewController.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/09.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController {
    
    @IBOutlet weak var dailyScollView: UIScrollView!
    
    @IBOutlet weak var daysTitleView: UIView!
    
    
    weak var refreshControlDelegate: RefreshControlDelegate?
    weak var dailyViewDidLoadDelegate: DailyViewDidLoadDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        dailyScollView.refreshControl = refreshControl
        
        dailyViewDidLoadDelegate?.dailyViewDidLoad(self)
        
        // Lines
        let viewWidth = self.view.bounds.size.width
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 1))
        topLine.backgroundColor = UIColor.lightGray
        daysTitleView.addSubview(topLine)
        
        let daysTitleViewHeight = daysTitleView.frame.size.height
        let bottomLine = UIView(frame: CGRect(x: 0, y: daysTitleViewHeight, width: viewWidth, height: 1))
        bottomLine.backgroundColor = UIColor.lightGray
        daysTitleView.addSubview(bottomLine)
        
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
        dailyScollView.setContentOffset(CGPoint(x: 0.0, y: 20.0), animated: false)
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

