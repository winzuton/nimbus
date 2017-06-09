//
//  MainPageViewController.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/09.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController {
    

    // Declaration og a custom Delegate for page control
    weak var pageControlDelegate: PageControlDelegate?
    
    var hey: String?
    
    // Define Hourly and Daily Page slides
    lazy var viewControllerList:[UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "hourlyVC")
        let vc2 = sb.instantiateViewController(withIdentifier: "dailyVC")
        
        return [vc1, vc2]
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        pageControlDelegate?.pageControl(self, didUpdatePageCount: viewControllerList.count)
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = viewControllerList.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = viewControllerList[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        
        }
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    func scrollToViewController(viewController: UIViewController,
                                direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyTutorialDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    private func notifyTutorialDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = viewControllerList.index(of: firstViewController) {
            pageControlDelegate?.pageControl(self, didUpdatePageIndex: index)
        }
    }
    
}

extension MainPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard viewControllerList.count > previousIndex else { return nil }
        
        return viewControllerList[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else { return nil }
        
        guard viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
        
    }
}

extension MainPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = viewControllers?.first,
            let index = viewControllerList.index(of: currentViewController) {
            pageControlDelegate?.pageControl(self, didUpdatePageIndex: index)
            
        }
        
    }
}

// Custom delegate for page controls
protocol PageControlDelegate: class {
    
    // Called when the number of pages is updated.
    // Parameters:
    // - mainPageViewController: the MainPageViewController instance
    // - count: the total number of pages.
    func pageControl(_ mainPageViewController: MainPageViewController,
                                    didUpdatePageCount count: Int)
    
    // Called when the current index is updated.
    // Parameters:
    // - mainPageViewController: the MainPageViewController instance
    // - index: the index of the currently visible page.
    func pageControl(_ mainPageViewController: MainPageViewController,
                                    didUpdatePageIndex index: Int)
    
}


