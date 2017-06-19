//
//  MainViewController.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/05/22.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    // IB Outlets
    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var poweredByImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var unitsButton: UIButton!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet weak var noDataView: UIView! // TODO: Hide when data has updated
    @IBOutlet weak var actionBg: UIImageView! // TODO: Add shadow below when no connection indeed 
    @IBOutlet weak var actionButton: UIButton! // TODO: Show when no connection indeed
    
    @IBOutlet weak var localityViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var localityLabelBottomConstraint: NSLayoutConstraint!
    
    
    // Class variables
    var isDaytime = true
    var isDataLoaded = false
    var isHourlyTableViewLoaded = false
    var isDailyTableViewLoaded = false
    var isDailyViewDidLoad = false
    
    var mainPageViewController: MainPageViewController? {
        didSet {
            mainPageViewController?.pageControlDelegate = self
        }
    }
    
    // TODO: Research delegates how to set etc!
    var hourlyViewController: HourlyViewController? {
        didSet {
            hourlyViewController?.refreshControlDelegate = self
            
        }
    }
    
    var dailyViewController: DailyViewController? {
        didSet {
            dailyViewController?.refreshControlDelegate = self
            dailyViewController?.dailyViewDidLoadDelegate = self
        }
    }
    
    // Location Variables
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    // Forecast Variables
    var currentForecast: CurrentForecast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set background image
        /*UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "day")?.draw(in: self.view.bounds)
        
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
            self.view.backgroundColor = UIColor.white
        }*/
        
        // self.view.backgroundColor = UIColor.OffWhite3
        
        // UIApplication.shared.statusBarStyle = .lightContent
        
        // Put locality view below to animate above 
        localityLabelBottomConstraint.constant -= actionBg.bounds.width
        
        // Setup link to Powered By Image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPoweredByLink(tapGestureRecognizer:)))
        poweredByImage.isUserInteractionEnabled = true
        poweredByImage.addGestureRecognizer(tapGesture)
        
        if let hourlyVC = mainPageViewController?.viewControllerList.first as? HourlyViewController {
            hourlyViewController = hourlyVC
            //hourlyVC.tryLabel.text = "やった！"
            // Call function in the class for hourly
        }
        
        if let dailyVC = mainPageViewController?.viewControllerList.last as? DailyViewController {
            dailyViewController = dailyVC
            // Daily View Controller not yet ready here
        }
        
        pageControl.addTarget(self, action: #selector(didChangePageControlValue), for: .valueChanged)
        
        // Current Weather
        currentForecast = CurrentForecast()
        
        // Prompt user to authorize location
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            // TODO: call again when user tapped something to finally allow location permission 
            locationManager.requestWhenInUseAuthorization()
        }
        
        // TODO: call again when user tapped something to finally allow location permission
        // Location settings when location is enabled 
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 5000
            locationManager.startUpdatingLocation() // Once nalang gicall pag enable, also the location updates // More consistent than one time request.. less calls of loactionupdate AND spinner issue happens not always maybe only from xcode? 
            //locationManager.startMonitoringSignificantLocationChanges() // TODO: Purpose? 
            //locationManager.requestLocation() // Not to be used concurrently with startUpdatingLocation
        }
        
        // Lines
        let tabViewWidth = self.view.bounds.size.width
        //let tabViewHeight = tabView.frame.size.height
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: tabViewWidth, height: 2))
        topLine.backgroundColor = UIColor.OffWhite
        tabView.addSubview(topLine)
        
        tabView.backgroundColor = UIColor.OffWhite2
        
        // Set background of Action View 
        noDataView.backgroundColor = UIColor.OffWhite3
        
        // TODO: rename colors first letter to lowercase first!  
        
        
    }
    
    // Open Dark Sky Powered By Link
    func openPoweredByLink(tapGestureRecognizer: UITapGestureRecognizer) {
        let url = URL(string: "https://darksky.net/poweredby/")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func didChangePageControlValue() {
        mainPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    func updateColors() {
        if isDaytime {
            /*self.view.backgroundColor = UIColor.white
             UIApplication.shared.statusBarStyle = .default
             poweredByImage.image = UIImage(named: "poweredby-dark")
             localityLabel.textColor = UIColor.black
             unitsButton.setTitleColor(UIColor.black, for: .normal)
             pageControl.tintColor = UIColor.lightGray
             pageControl.currentPageIndicatorTintColor = UIColor.black*/
            isDaytime = false
            UIView.animate(withDuration: 0.3){
                self.statusView.isHidden = true
                // self.statusView.backgroundColor = UIColor.black
                // Show text: no internet, data updated, privacy off, airplane mode on, etc.
            }
        } else {
            /*self.view.backgroundColor = UIColor.black
             UIApplication.shared.statusBarStyle = .lightContent
             poweredByImage.image = UIImage(named: "poweredby-light")
             localityLabel.textColor = UIColor.white
             unitsButton.setTitleColor(UIColor.white, for: .normal)
             pageControl.tintColor = UIColor.darkGray
             pageControl.currentPageIndicatorTintColor = UIColor.white*/
            isDaytime = true
            UIView.animate(withDuration: 0.3){
                self.statusView.isHidden = false
                // self.statusView.backgroundColor = UIColor.black
                // Show text: no internet, data updated, privacy off, airplane mode on, etc.
            }
        }
    }
    
    // Refresh 
    func refreshWeatherData(refreshControl: UIRefreshControl) {
        
        updateData(refreshControl: refreshControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: Already done during didSet?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainPageViewController = segue.destination as? MainPageViewController {
            // mainPageViewController.pageControlDelegate = self // TODO: Already done during didSet?
            self.mainPageViewController = mainPageViewController
        }
        
    }
    
    // Toggle °C / ° F button 
    @IBAction func toggleTemperatureUnit(_ sender: UIButton) {
        
        // New class for weather data
            // unit default = si
        // Set NSUserDefault as well for these data? to retain!
        // If clicked, set new unit var (si/us), convert the numbers <bug ang summary part>, set bold the new unit
            // Next call should use new unit specification 
        
        
        /*var boldText  = "Filter:"
        var attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(15)]
        var attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        var normalText = "Hi am normal"
        var normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.appendAttributedString(normalString)*/
        
    }
    
    // TODO: create new class for update location and data
    
    // TODO: info plist: 
        // App Transport Security Settings > Allow Arbitrary Loads > YES
        // Privacy - Location When In Use Usage Description: We need your location to give you relevant, up-to-date weather information.
    
    // TODO: Notification
        // In the background, trigger connecct with current lat lng
    
    func updateData(refreshControl: UIRefreshControl? = nil) { // Optional (? : can be nil) parameter with nil as default (= : can be left empty in calling)
        
        // Update by location if authorized
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            currentLocation = locationManager.location // TODO: save current location to static or class?
            
            // If no location, update view based on cached data or display tap to refresh/allow location/allow internet/disable the airplanemode
            if (currentLocation == nil) {
                
                print("Cannot get current location") // TODO: status view
                // TODO: Update view based on cached data // TODO: delayed change in status view with "View updated based on cached data"
                // TODO: If no cached data (or cached data already consumed, update table view with tap
                
                if refreshControl != nil {
                    refreshControl?.endRefreshing()
                }
                
            } else {
                
                // Update URL based on current location and download new data from DarkSky API 
                
                // Get current locations
                Location.sharedInstance.location = currentLocation
                Location.sharedInstance.latitude = currentLocation?.coordinate.latitude
                Location.sharedInstance.longitude = currentLocation?.coordinate.longitude
                
                // Update API call URL
                Forecast.sharedInstance.updateURL()
                
                // Download current forecast data
                currentForecast.downloadData {
                    
                    if !self.isDataLoaded {
                        // Update data with animation when first loaded
                        self.animateViewsToShowData()
                        self.isDataLoaded = true
                        // TODO: Set again to false when showing No Data View ( means no more cached = 3 hours left, dont mind days )
                    } else {
                        // TODO: Update data with fade ins
                        self.updateMainView()
                        self.updateHourlyView()
                        self.updateDailyView()
                    }
                    
                    
                    // End spinner in status bar
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    // TODO: where to call end of refresh
                    if refreshControl != nil {
                        refreshControl?.endRefreshing()
                    }
                    
                    // TODO: Reload tableViews of Hourly and Daily View Controllers
                        // self.tableView.reloadData()
                }
            }
        } else {
            // TODO: New button inside the table view to tap and allow location for weather updates
            
            if refreshControl != nil {
                refreshControl?.endRefreshing()
            }
            
            print("*Not Authorized")
            
        }
    }

// Animations
    
    // TODO: Transfer animations to designated View Controllers
    
    // TODO: Separate animation for daily summary and table view after fresh update and page slide
    
    // TODO: Show or hide according to connection/data
    // Animate to show data (depends what gets animated on current page for now
    func animateViewsToShowData() {
        
        // Prepare colors and data behind
        updateMainView()
        updateHourlyView()
        
        // Hide No Data View if data is received
        noDataView.isHidden = true // TODO: Display when no connection or an error occured
        
        // Animate to top when app is first loaded with data
        animateHourlyTableViewUp()
        animateDailyTableViewUp()
        
        // Animate items when data is loaded after hiding No Data View
        animateNowItems()
        
    }
    
    // TODO: Go to first page before showing No Data View so it will always be first page when animating
    // Animate to No Data View
    func animateViewsToHideData() {
        
        // Animate table view down
        animateHourlyTableViewDown()
        animateDailyTableViewDown()
        
        // Show No Data View
        self.noDataView.isHidden = false // TODO: Display when no connection or an error occured
        
        // Show shadow when no connection (meaning it is tappable)
        /*UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
         self.actionBg.layer.shadowOffset = CGSize(width: 0, height: 3)
         self.actionBg.layer.shadowRadius = 3
         self.actionBg.layer.shadowColor = UIColor.OffBlack.cgColor
         self.actionBg.layer.shadowOpacity = 0.5
         
         self.view.layoutIfNeeded()
         }, completion: nil)
         */
    }
    
    // Animate table view to top, hiding the update info view
    func animateHourlyTableViewUp() {
        if !isHourlyTableViewLoaded {
            hourlyViewController?.hourlyTableView.setContentOffset(CGPoint(x: 0.0, y: CGFloat(UISize.updateView)), animated: true)
            isHourlyTableViewLoaded = true
        }
    }
    
    // Animate table view to top, hiding the update info view
    func animateDailyTableViewUp() {
        if isDailyViewDidLoad && !isDailyTableViewLoaded {
            dailyViewController?.dailyTableView.setContentOffset(CGPoint(x: 0.0, y: CGFloat(UISize.updateView)), animated: true)
            isDailyTableViewLoaded = true
        }
    }
    
    // Animate table view down, showing the update info view
    func animateHourlyTableViewDown() {
        if isHourlyTableViewLoaded {
            hourlyViewController?.hourlyTableView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            isHourlyTableViewLoaded = false
        }
    }
    
    // Animate table view down, showing the update info view
    func animateDailyTableViewDown() {
        if isDailyViewDidLoad && isDailyTableViewLoaded {
            dailyViewController?.dailyTableView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            isDailyTableViewLoaded = false
        }
    }
    
    // TODO: refactor codes to have let once of vc to local
    
    // Animate icon, locality, Now, Temperature, Summary from icon background
    // Still call the fade ins first but now with another animation for motion
    func animateNowItems() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            let hourlyVC = self.hourlyViewController
            
            // Icon
            hourlyVC?.icon.alpha = 1
            
            // Locality
            self.localityLabelBottomConstraint.constant += self.actionBg.bounds.width
            self.localityLabel.alpha = 1
            
            let offset = hourlyVC?.iconBg.bounds.width
            // Now
            hourlyVC?.timeLabelLeadingConstraint.constant -= offset!
            hourlyVC?.timeLabelTrailingConstraint.constant += offset!
            hourlyVC?.time.alpha = 1
            
            // Temperature
            hourlyVC?.tempLabelTrailingConstraint.constant -= offset!
            hourlyVC?.tempLabelLeadingConstraint.constant += offset!
            hourlyVC?.temperature.alpha = 1
            
            // Summary
            hourlyVC?.weatherLabelTopConstraint.constant += offset! // LIFO
            hourlyVC?.summary.alpha = 1
            
            self.view.layoutIfNeeded()
            
        }, completion: { finished in
            self.animateHourlySummaryView()
        })
        
        self.hourlyViewController?.animateHourlyTableDataCells()
        
    }
    
    // Fade in
    func animateHourlySummaryView() {
        UIView.animate(withDuration: 1, animations: {
            self.hourlyViewController?.hourlySummary.alpha = 1
            self.view.layoutIfNeeded() // Important
        }, completion: nil)
    }
    
    // Cells coming from top to bottom
    func animateHourlyTableDataCells() {
        // TODO: Animate top to bottom effect
        hourlyViewController?.animateHourlyTableDataCells()
    }
    
// Animate with Fade ins only
    
    func updateMainView() {
        localityLabel.text = currentForecast.location
        locationView.backgroundColor = UIColor.OffWhite3
        tabView.backgroundColor = UIColor.OffWhite2
        
    }
    
    func updateHourlyView() {
        
        // TODO: set somewhere to set the colors according to the hour.. so general name na
        hourlyViewController?.updateInfo.textColor = UIColor.darkGray
        
        hourlyViewController?.summaryHeaderView.backgroundColor = UIColor.OffWhite3
        
        hourlyViewController?.time.text = currentForecast.timeString
        hourlyViewController?.icon.image = UIImage(named: "light-\(currentForecast.icon)")
        //hourlyViewController?.iconBg.image = UIImage(named: currentForecast.icon)
        hourlyViewController?.temperature.text = currentForecast.temperatureString
        hourlyViewController?.summary.text = currentForecast.currentSummary
        
        // hourlyViewController?.isSummmaryViewShadowed = false // Not need since table may update while time or location changed?
        // hourlyViewController?.isTableViewLoaded = false // Not need since purpose only is to have that soft animation during opening
        // TODO: header views
        
        // Update hourly table view
        hourlyViewController?.currentBackgroundColor = UIColor.OffWhite3
        hourlyViewController?.nowHeaderView.backgroundColor = UIColor.OffWhite3
        hourlyViewController?.hourlySummary.text = currentForecast.hourlySummary
        hourlyViewController?.hourlyForecasts.removeAll()
        hourlyViewController?.hourlyForecasts = currentForecast.hourlyForecasts
        hourlyViewController?.hourlyTableView.backgroundColor = UIColor.OffWhite // TODO: transfer functions for color related.. only called when time changed from day to night etc
        hourlyViewController?.hourlyTableView.reloadData()
        
    }
    
    // TODO: Is it correct to set values here or better to assign in the view controllers itself?
    
    func updateDailyView() {
        
        // dailyViewController?.isSummmaryViewShadowed = false
        // TODO: header views 
        
        // TODO: set somewhere to set the colors according to the hour.. so general name na
        
        // Update daily table view
        if isDailyViewDidLoad {
            dailyViewController?.currentBackgroundColor = UIColor.OffWhite3
            dailyViewController?.topHeaderView.backgroundColor = UIColor.OffWhite3
            dailyViewController?.summaryHeaderView.backgroundColor = UIColor.OffWhite3
            dailyViewController?.updateInfo.textColor = UIColor.darkGray
            dailyViewController?.dailySummary.text = currentForecast.dailySummary
            dailyViewController?.dailyForecasts.removeAll()
            dailyViewController?.dailyForecasts = currentForecast.dailyForecasts
            dailyViewController?.dailyTableView.backgroundColor = UIColor.OffWhite
            dailyViewController?.dailyTableView.reloadData()
        }
        
    }
    
    // Retry connection etc. 
    @IBAction func actionTapped(_ sender: UIButton) {
    }
    

}

extension MainViewController: PageControlDelegate {
    
    func pageControl(_ mainPageViewController: MainPageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func pageControl(_ mainPageViewController: MainPageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}

extension MainViewController: RefreshControlDelegate {
    func refreshControl(_ viewController: UIViewController, _ refreshControl: UIRefreshControl) {
        
        refreshWeatherData(refreshControl: refreshControl)
        
    }
}

extension MainViewController: DailyViewDidLoadDelegate {
    func dailyViewDidLoad(_ viewController: DailyViewController) {
        //if let dailyVC = mainPageViewController?.viewControllerList.last as? DailyViewController {
            //dailyVC.tryLabel2.text = "やった！!!!!!!"
            // Call function in the class for setting daily values
        //}
        isDailyViewDidLoad = true
        updateDailyView()
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("*Authorization changed.")
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("*Calling updateData")
            updateData()
        } else {
            print ("To provide you with weather updates, we need to have location permission.") // TODO: Display in status view
            // TODO: update table view to show tap to allow permission
        }
    }
    
    // TODO: Still called even not moved and app is opened again 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // let userLocation:CLLocation = locations.last!
        updateData()
        print("*Location updated.")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
        // TODO: update ui to show tap to allow permission
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("Location Updates are paused.")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("Location Updates are resumed.")
        //updateData()
    }
}


