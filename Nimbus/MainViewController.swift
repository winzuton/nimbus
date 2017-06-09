//
//  ViewController.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/05/22.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var poweredByImage: UIImageView!
    
    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var unitsButton: UIButton!
    
    var isDaytime: Bool = true
    
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
        
        self.view.backgroundColor = UIColor.black
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Setup link to Powered By Image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPoweredByLink(tapGestureRecognizer:)))
        poweredByImage.isUserInteractionEnabled = true
        poweredByImage.addGestureRecognizer(tapGesture)
        
        if let hourlyVC = mainPageViewController?.viewControllerList.first as? HourlyViewController {
            hourlyViewController = hourlyVC
            hourlyVC.tryLabel.text = "やった！"
            // Call function in the class for hourly
        }
        
        if let dailyVC = mainPageViewController?.viewControllerList.last as? DailyViewController {
            dailyViewController = dailyVC
            // Daily View Controller not yet ready here
        }
        
        pageControl.addTarget(self, action: #selector(didChangePageControlValue), for: .valueChanged)
        
    }
    
    // Open Dark Sky Powered By Link
    func openPoweredByLink(tapGestureRecognizer: UITapGestureRecognizer) {
        let url = URL(string: "https://darksky.net/poweredby/")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func didChangePageControlValue() {
        mainPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    // Refresh 
    func refreshWeatherData(refreshControl: UIRefreshControl) {
        
        if isDaytime {
            self.view.backgroundColor = UIColor.white
            UIApplication.shared.statusBarStyle = .default
            poweredByImage.image = UIImage(named: "poweredby-dark")
            localityLabel.textColor = UIColor.black
            unitsButton.setTitleColor(UIColor.black, for: .normal)
            pageControl.tintColor = UIColor.lightGray
            pageControl.currentPageIndicatorTintColor = UIColor.black
            isDaytime = false
        } else {
            self.view.backgroundColor = UIColor.black
            UIApplication.shared.statusBarStyle = .lightContent
            poweredByImage.image = UIImage(named: "poweredby-light")
            localityLabel.textColor = UIColor.white
            unitsButton.setTitleColor(UIColor.white, for: .normal)
            pageControl.tintColor = UIColor.darkGray
            pageControl.currentPageIndicatorTintColor = UIColor.white
            isDaytime = true
        }
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
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
        if let dailyVC = mainPageViewController?.viewControllerList.last as? DailyViewController {
            dailyVC.tryLabel2.text = "やった！!!!!!!"
            // Call function in the class for setting daily values
        }
    }
}
