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
    //@IBOutlet weak var hourlyScrollView: UIScrollView!
    
    @IBOutlet weak var nowView: UIView!
    
    @IBOutlet weak var hourlyTableView: UITableView!
    
    @IBOutlet var nowHeaderView: UIView!
    
    @IBOutlet var summaryHeaderView: UIView!
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconBg: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var hourlySummary: UILabel!
    
    
    @IBOutlet weak var updateInfoView: UIView!
    @IBOutlet weak var updateInfo: UILabel!
    
    
    @IBOutlet weak var hoursSummaryView: UIView!
    
    
    @IBOutlet weak var timeLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tempLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tempLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherLabelTopConstraint: NSLayoutConstraint!
    
    
    weak var refreshControlDelegate: RefreshControlDelegate?

    var isSummmaryViewShadowed = false
    
    var currentBackgroundColor: UIColor?
    
    var hourlyForecasts = [HourlyForecast]()
    
    var topLine: UIView!
    var bottomLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        hourlyTableView.refreshControl = refreshControl
        
        // Adjust constraints to start animation from center
        let offset = iconBg.bounds.width
        timeLabelLeadingConstraint.constant += offset
        timeLabelTrailingConstraint.constant -= offset
        tempLabelLeadingConstraint.constant -= offset
        tempLabelTrailingConstraint.constant += offset
        weatherLabelTopConstraint.constant -= offset
        
        // Lines
        
        let summaryViewWidth = self.view.bounds.size.width
        let summaryViewHeight = summaryHeaderView.frame.size.height
        
        // TODO: change color when top
        topLine = UIView(frame: CGRect(x: 0, y: 0, width: summaryViewWidth, height: 2))
        topLine.backgroundColor = UIColor.OffWhite2
        summaryHeaderView.addSubview(topLine)
        
        bottomLine = UIView(frame: CGRect(x: 0, y: summaryViewHeight, width: summaryViewWidth, height: 2))
        bottomLine.backgroundColor = UIColor.OffWhite4
        summaryHeaderView.addSubview(bottomLine)
        
        //self.hourlyScrollView.delegate = self
        
        self.hourlyTableView.dataSource = self
        self.hourlyTableView.delegate = self
        
        hourlyTableView.tableHeaderView = nowHeaderView
        hourlyTableView.sectionHeaderHeight = summaryHeaderView.frame.size.height
        
        // Make summary view tappable to make the table view scroll to top
        let tap = UITapGestureRecognizer(target: self, action: #selector(HourlyViewController.scrollTableViewToTop))
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
        
        // Only call during first load
        /*if !isTableViewLoaded {
            hourlyTableView.setContentOffset(CGPoint(x: 0.0, y: CGFloat(UISize.updateView)), animated: true)
            isTableViewLoaded = true
        }*/
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Scroll Table view to top when summary is tapped
    func scrollTableViewToTop(sender: UITapGestureRecognizer) {
        // Scroll to top only when section header is at the top 
        // TODO: Create constants like for height of 260 (table header height)
        if hourlyTableView.contentOffset.y > CGFloat(UISize.hourlyHeaderView) {
            hourlyTableView.setContentOffset(CGPoint(x: 0.0, y: CGFloat(UISize.updateView)), animated: true)
        }
    }
    
// Animations
    
    func animateHourlyTableDataCells() {
        
        let cells = hourlyTableView.visibleCells
        let tableViewHeight = hourlyTableView.bounds.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }

}

// Custom delegate for refresh scroll
protocol RefreshControlDelegate: class {
    
    func refreshControl(_ viewController: UIViewController, _ refreshControl: UIRefreshControl)
    
}

// TODO: remove in current array of data if hour has passed for that object 
extension HourlyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Only display 23 hours 
        // TODO: be sure not negative 
        return hourlyForecasts.count < 24 ? hourlyForecasts.count: 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyTableDataCell", for: indexPath) as? HourlyTableViewCell {
            
            let hourlyForecast = hourlyForecasts[indexPath.row]
             cell.configureCell(forecast: hourlyForecast)
            
            cell.backgroundColor = currentBackgroundColor
            
            return cell
        } else {
            return HourlyTableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return summaryHeaderView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Hide Updated View after 01 second 
        if hourlyTableView.contentOffset.y == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
                // Confirm if still on top after the delay
                if self.hourlyTableView.contentOffset.y == 0 {
                    self.hourlyTableView.setContentOffset(CGPoint(x: 0.0, y: CGFloat(UISize.updateView)), animated: true)
                }
            })
        }
        
        // TODO: Create constants like for height of 260 (table header height)
        if hourlyTableView.contentOffset.y > CGFloat(UISize.hourlyHeaderView) && !isSummmaryViewShadowed {
            
            // Change summary view color to lighter shade
            topLine.backgroundColor = UIColor.OffWhite
            summaryHeaderView.backgroundColor = UIColor.OffWhite2
            
            // Create shadow under summary view 
            summaryHeaderView.layer.shadowOffset = CGSize(width: 0, height: 3)
            summaryHeaderView.layer.shadowRadius = 3
            summaryHeaderView.layer.shadowColor = UIColor.OffBlack.cgColor
            summaryHeaderView.layer.shadowOpacity = 0.4
            isSummmaryViewShadowed = true
        } else if hourlyTableView.contentOffset.y <= CGFloat(UISize.hourlyHeaderView) && isSummmaryViewShadowed {
            
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
