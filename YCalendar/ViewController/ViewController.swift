//
//  ViewController.swift
//  YCalendar
//
//  Created by Archie on 2022/7/16.
//

import UIKit
import iOS_Kit

class ViewController: UIViewController {
    @IBOutlet weak var weekdayContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var monthViewControllerList = [MonthViewController]()
    var currentMinMonthOffset = 0
    var currentMaxMonthOffset = 0
    var scrollerViewTopConstraint: NSLayoutConstraint?
    
    let createCountEveryTime = 6
    let removeThreshold = 12
    
    let weekdayViewController: WeekdayViewController =  {
        let viewController = WeekdayViewController()
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(weekdayViewController)
        weekdayContainerView.addSubview(weekdayViewController.view)
        weekdayViewController.view.topAnchor.constraint(equalTo: weekdayContainerView.topAnchor).isActive = true
        weekdayViewController.view.bottomAnchor.constraint(equalTo: weekdayContainerView.bottomAnchor).isActive = true
        weekdayViewController.view.leadingAnchor.constraint(equalTo: weekdayContainerView.leadingAnchor).isActive = true
        weekdayViewController.view.trailingAnchor.constraint(equalTo: weekdayContainerView.trailingAnchor).isActive = true
        
        view.layoutIfNeeded()
        setupMonthViewControllerList()
        initializeContentOffset()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateContentSize()
    }
    
    private func setupMonthViewControllerList() {
        let viewController = createMonthViewController(monthOffset: 0)
        monthViewControllerList.append(viewController)
        
        createMonthViewControllers(count: createCountEveryTime, forward: true)
        createMonthViewControllers(count: createCountEveryTime, forward: false)
    }
    
    private func createMonthViewController(monthOffset: Int) -> MonthViewController {
        let viewController = MonthViewController(byAdding: monthOffset)
        
        addChild(viewController)
        scrollView.addSubview(viewController.view)
        viewController.view.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        
        return viewController
    }
    
    private func createMonthViewControllers(count: Int, forward: Bool) {
        for _ in 1...count {
            if forward {
                currentMaxMonthOffset += 1
            } else {
                currentMinMonthOffset -= 1
            }
            
            let viewController = createMonthViewController(monthOffset: forward ? currentMaxMonthOffset : currentMinMonthOffset)
            
            if forward {
                if let preViewController = monthViewControllerList.last {
                    viewController.view.topAnchor.constraint(equalTo: preViewController.view.bottomAnchor).isActive = true
                }
                monthViewControllerList.append(viewController)
            } else {
                if let nextViewController = monthViewControllerList.first {
                    viewController.view.bottomAnchor.constraint(equalTo: nextViewController.view.topAnchor).isActive = true
                }
                monthViewControllerList.insert(viewController, at: 0)
            }
        }
        if !forward  {
            updateScrollerViewTopConstraint()
        }
        updateContentSize()
    }
    
    private func updateScrollerViewTopConstraint() {
        if let viewController = monthViewControllerList.first  {
            scrollerViewTopConstraint?.isActive = false
            scrollerViewTopConstraint = viewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor)
            scrollerViewTopConstraint?.isActive = true
        }
    }
    
    private func createMoreMonthViewControllersIfNeed() {
        guard let currentViewController = getCurrentMonthViewController() else { return }
        if currentViewController.dataSource.offset - currentMinMonthOffset < 4 {
            let contentOffsetY = scrollView.contentOffset.y
            
            createMonthViewControllers(count: createCountEveryTime, forward: false)
            
            var increasedHeight = 0.0
            for index in 0..<createCountEveryTime {
                increasedHeight += monthViewControllerList[index].view.height
            }
            scrollView.contentOffset = CGPoint(x: 0, y: contentOffsetY + increasedHeight)
        } else if currentMaxMonthOffset - currentViewController.dataSource.offset < 4 {
            createMonthViewControllers(count: createCountEveryTime, forward: true)
        }
    }
    
    private func removeMonthViewControllersIfNeed() {
        guard let currentViewController = getCurrentMonthViewController() else { return }
        var numberOfExcesses = currentViewController.dataSource.offset - currentMinMonthOffset - removeThreshold
        if numberOfExcesses > 0 {
            let contentOffsetY = scrollView.contentOffset.y
            
            var decreasedHeight = 0.0
            for _ in 0..<numberOfExcesses {
                let viewController = monthViewControllerList.removeFirst()
                decreasedHeight += viewController.view.height
                viewController.removeFromParent()
                viewController.view.removeFromSuperview()
                
                currentMinMonthOffset += 1
            }
            updateScrollerViewTopConstraint()
            updateContentSize()
            
            scrollView.contentOffset = CGPoint(x: 0, y: contentOffsetY - decreasedHeight)
        }
        
        numberOfExcesses = currentMaxMonthOffset - currentViewController.dataSource.offset - removeThreshold
        if numberOfExcesses > 0 {
            for _ in 0..<numberOfExcesses {
                let viewController = monthViewControllerList.removeLast()
                viewController.removeFromParent()
                viewController.view.removeFromSuperview()
                
                currentMaxMonthOffset -= 1
            }
            updateContentSize()
        }
    }
    
    private func initializeContentOffset() {
        guard !monthViewControllerList.isEmpty else { return }
        
        var initialContentOffset = 0.0
        let currenMonth = AMonth(byAdding: 0)
        monthViewControllerList.forEach { viewController in
            if viewController.dataSource < currenMonth {
                initialContentOffset += viewController.view.height
            }
        }
        scrollView.contentOffset = CGPoint(x: 0, y: initialContentOffset)
    }
    
    private func getCurrentMonthViewController() -> MonthViewController? {
        let contentOffsetY = scrollView.contentOffset.y
        var offset = 0.0
        for viewController in monthViewControllerList {
            if offset >= contentOffsetY {
                return viewController
            }
            offset += viewController.view.height
        }
        return nil
    }
    
    private func updateContentSize() {
        view.layoutIfNeeded()
        var contentHeight = 0.0
        monthViewControllerList.forEach { viewController in
            contentHeight += viewController.view.height
        }
        scrollView.contentSize = CGSize(width: scrollView.width, height: contentHeight)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        createMoreMonthViewControllersIfNeed()
        removeMonthViewControllersIfNeed()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        createMoreMonthViewControllersIfNeed()
        removeMonthViewControllersIfNeed()
    }
}

