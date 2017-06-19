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
    
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet var topHeaderView: UIView!
    @IBOutlet var summaryHeaderView: UIView!
    @IBOutlet weak var dailySummary: UILabel!
    
    
    @IBOutlet weak var updateInfoView: UIView!
    @IBOutlet weak var updateInfo: UILabel!
    
    @IBOutlet weak var daysSummaryView: UIView!
    
    
    weak var refreshControlDelegate: RefreshControlDelegate?
    weak var dailyViewDidLoadDelegate: DailyViewDidLoadDelegate?
    
    var isSummmaryViewShadowed = false
    
    var dailyForecasts = [DailyForecast]()
  
    var currentBackgroundColor: UIColor?
    
    var topLine: UIView!
    var bottomLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        dailyTableView.refreshControl = refreshControl
        
        dailyViewDidLoadDelegate?.dailyViewDidLoad(self)
        
        // Lines
        let summaryViewWidth = self.view.bounds.size.width
        let summaryViewHeight = summaryHeaderView.frame.size.height
        
        topLine = UIView(frame: CGRect(x: 0, y: 0, width: summaryViewWidth, height: 2))
        topLine.backgroundColor = UIColor.OffWhite2
        summaryHeaderView.addSubview(topLine)
        
        bottomLine = UIView(frame: CGRect(x: 0, y: summaryViewHeight, width: summaryViewWidth, height: 2))
        bottomLine.backgroundColor = UIColor.OffWhite4
        summaryHeaderView.addSubview(bottomLine)
        
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
        dailyTableView.setContentOffset(CGPoint(x: 0.0, y: CGFloat(UISize.updateView)), animated: false)
    }
    
    // Scroll Table view to top when summary is tapped
    func scrollTableViewToTop(sender: UITapGestureRecognizer) {
        // Scroll to top only when section header is at the top
        // TODO: Create constants like for height of 60 (table header height)
        if dailyTableView.contentOffset.y > CGFloat(UISize.dailyHeaderView) {
            dailyTableView.setContentOffset(CGPoint(x: 0.0, y: CGFloat(UISize.updateView)), animated: true)
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

// TODO: remove in current array of data if day has passed for that object 
extension DailyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Only display 6 days 
        // TODO: be sure not negative 
        return dailyForecasts.count < 7 ? dailyForecasts.count : 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "dailyTableDataCell", for: indexPath) as? DailyTableViewCell {
            
            let dailyForecast = dailyForecasts[indexPath.row]
             cell.configureCell(forecast: dailyForecast)
            
            cell.backgroundColor = currentBackgroundColor
            
            return cell
        } else {
            return DailyTableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return summaryHeaderView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Hide Updated View after 01 second 
        if dailyTableView.contentOffset.y == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
                // Confirm if still on top after the delay
                if self.dailyTableView.contentOffset.y == 0 {
                    self.dailyTableView.setContentOffset(CGPoint(x: 0.0, y: CGFloat(UISize.updateView)), animated: true)
                }
            })
        }
        
        // TODO: Create constants like for height of 60 (table header height)
        if dailyTableView.contentOffset.y > CGFloat(UISize.dailyHeaderView) && !isSummmaryViewShadowed {
            
            // Change summary view color to lighter shade
            topLine.backgroundColor = UIColor.OffWhite
            summaryHeaderView.backgroundColor = UIColor.OffWhite2
            
            // Create shadow under summary view
            summaryHeaderView.layer.shadowOffset = CGSize(width: 0, height: 3)
            summaryHeaderView.layer.shadowRadius = 3
            summaryHeaderView.layer.shadowColor = UIColor.OffBlack.cgColor
            summaryHeaderView.layer.shadowOpacity = 0.4
            isSummmaryViewShadowed = true
        } else if dailyTableView.contentOffset.y <= CGFloat(UISize.dailyHeaderView) && isSummmaryViewShadowed {
            
            // Change summary view color to current shade
            topLine.backgroundColor = UIColor.OffWhite2
            summaryHeaderView.backgroundColor = currentBackgroundColor
            
            // Remove shadow under summary view
            summaryHeaderView.layer.shadowOffset = CGSize(width: 0, height: 0)
            summaryHeaderView.layer.shadowRadius = 0
            summaryHeaderView.layer.shadowOpacity = 0
            isSummmaryViewShadowed = false
        }
    }
}



