//
//  DailyViewController.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/09.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController {
    
    //@IBOutlet weak var dailyScollView: UIScrollView!
    
    @IBOutlet weak var daysTitleView: UIView!
    
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet var topHeaderView: UIView!
    @IBOutlet var summaryHeaderView: UIView!
    
    weak var refreshControlDelegate: RefreshControlDelegate?
    weak var dailyViewDidLoadDelegate: DailyViewDidLoadDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        dailyTableView.refreshControl = refreshControl
        
        dailyViewDidLoadDelegate?.dailyViewDidLoad(self)
        
        // Lines
        /* let viewWidth = self.view.bounds.size.width
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 1))
        topLine.backgroundColor = UIColor.lightGray
        daysTitleView.addSubview(topLine)
        
        let daysTitleViewHeight = daysTitleView.frame.size.height
        let bottomLine = UIView(frame: CGRect(x: 0, y: daysTitleViewHeight, width: viewWidth, height: 1))
        bottomLine.backgroundColor = UIColor.lightGray
        daysTitleView.addSubview(bottomLine) */
        
        self.dailyTableView.delegate = self
        self.dailyTableView.dataSource = self
        
        dailyTableView.tableHeaderView = topHeaderView
        dailyTableView.sectionHeaderHeight = summaryHeaderView.frame.size.height
        
        // Make summary view tappable to make the table view scroll to top
        let tap = UITapGestureRecognizer(target: self, action: #selector(DailyViewController.scrollTableViewToTop))
        summaryHeaderView.isUserInteractionEnabled = true
        summaryHeaderView.addGestureRecognizer(tap)
        
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
        dailyTableView.setContentOffset(CGPoint(x: 0.0, y: 20.0), animated: false)
    }
    
    // Scroll Table view to top when locality is tapped
    func scrollTableViewToTop(sender: UITapGestureRecognizer) {
        // Scroll to top only when section header is at the top
        // TODO: Create constants like for height of 60 (table header height)
        if dailyTableView.contentOffset.y >= 60 {
            dailyTableView.setContentOffset(CGPoint(x: 0.0, y: 20.0), animated: true)
        }
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

extension DailyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "dailyTableDataCell", for: indexPath) as? DailyTableViewCell {
            
            /*let forecast = forecasts[indexPath.row]
             cell.configureCell(forecast: forecast)*/
            
            // cell.configureCell()
            
            return cell
        } else {
            return HourlyTableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return summaryHeaderView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dailyTableView.contentOffset.y == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
                self.dailyTableView.setContentOffset(CGPoint(x: 0.0, y: 20.0), animated: true)
            })
            
        }
    }
}



