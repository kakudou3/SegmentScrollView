//
//  ViewController.swift
//  SegmentScrollView
//
//  Created by Akimichi Tanei on 2018/09/25.
//  Copyright © 2018年 kakudooo. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa

protocol SegmentControllerDelegate {
    func segmentTitle() -> String
    func streachScrollView() -> UIScrollView
}

class TableViewController: UITableViewController, SegmentControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func segmentTitle() -> String {
        return "table \(self.view.tag)"
    }
    
    @objc func streachScrollView() -> UIScrollView {
        return self.tableView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

class ViewController: UIViewController {
    
    // base value
    let headerBaseHeight: CGFloat = 250
    
    var headerHeight: CGFloat {
        return self.headerBaseHeight
    }
    
    let segmentHeight: CGFloat = 44
    var originalTopInset: CGFloat = 0
    let segmentMiniTopInset: CGFloat = 0 // segment controlの固定位置
    var segmentTopInset: CGFloat = 400
    var freezenHeaderWhenReachMaxHeaderHeight: Bool = false
    
    var ignoreOffsetChanged: Bool = false
    
    let headerContentsView: CustomHeaderView = .init(frame: .zero)
    let segmentView: UISegmentedControl = .init(frame: .zero)
    
    var headerHeightConstraint: NSLayoutConstraint = .init()
    
    var controllers: [TableViewController] = []
    var currentDisplayController: TableViewController!
    var hasShownControllers: [TableViewController] = []
    
    let disposeBag: DisposeBag = .init()
    
    var disposable1: Disposable?
    var disposable2: Disposable?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let tableViewController1 = TableViewController()
        tableViewController1.tableView.backgroundColor = UIColor.green
        tableViewController1.view.tag = 1
        let tableViewController2 = TableViewController()
        tableViewController2.tableView.backgroundColor = UIColor.blue
        tableViewController2.view.tag = 2
        self.setViewControllers(viewControllers: [tableViewController1, tableViewController2])
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    func setViewControllers(viewControllers: [TableViewController]) {
        self.controllers.removeAll()
        self.controllers.append(contentsOf: viewControllers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        self.setUpLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        self.removeObserverForPageController(controller: self.currentDisplayController)
    }
}

extension ViewController {
    func setUpView() {
        //self.imageLoad()
        
        if self.view.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            self.view.preservesSuperviewLayoutMargins = true
        }
        
        self.extendedLayoutIncludesOpaqueBars = false
        
        self.headerContentsView.clipsToBounds = true
        self.view.addSubview(self.headerContentsView)
        
        self.segmentView.addTarget(self, action: #selector(ViewController.segmentControlDidChangedValue), for: UIControlEvents.valueChanged)
        
        self.view.addSubview(self.segmentView)
        
        for (index, controller) in self.controllers.enumerated() {
            let title = controller.segmentTitle()
            
            self.segmentView.insertSegment(withTitle: title, at: index, animated: false)
        }
        
        self.segmentView.selectedSegmentIndex = 0
        let controller = self.controllers[0]
        
        controller.willMove(toParentViewController: self)
        self.view.insertSubview(controller.view, at: 0)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        
        self.layoutControllerWithController(pageController: controller)
        self.addObserverForPageController(controller: controller)
        
        self.currentDisplayController = self.controllers[0]
    }
    
    func setUpLayout() {
        // header
        self.headerContentsView.translatesAutoresizingMaskIntoConstraints = false
        
        self.headerHeightConstraint = NSLayoutConstraint(item: self.headerContentsView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 1, constant: self.headerHeight)
        
        self.headerContentsView.addConstraint(self.headerHeightConstraint)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.headerContentsView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.headerContentsView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.headerContentsView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0))
        
        // segment
        self.segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: self.segmentView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.segmentView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.segmentView, attribute: .top, relatedBy: .equal, toItem: self.headerContentsView, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.segmentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 1, constant: self.segmentHeight))
    }
    
    func layoutControllerWithController(pageController: TableViewController) {
        guard let pageView = pageController.view else {
            return
        }
        
        if pageView.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            pageView.preservesSuperviewLayoutMargins = true
        }
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: pageView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: pageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
        
        guard let scrollView = self.scrollViewInPageController(controller: pageController) else {
            self.view.addConstraint(NSLayoutConstraint(item: pageView, attribute: .top, relatedBy: .equal, toItem: self.segmentView, attribute: .bottom, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: pageView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: -self.segmentHeight))
            return
        }
        
        scrollView.alwaysBounceVertical = true
        self.originalTopInset = self.headerHeight + self.segmentHeight
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        
        var bottomInset: CGFloat = 0
        if self.tabBarController?.tabBar.isHidden == false {
            bottomInset = (self.tabBarController?.tabBar.bounds.height)!
        }
        
        scrollView.contentInset = UIEdgeInsetsMake(self.originalTopInset, 0, bottomInset, 0)
        
        if !self.hasShownControllers.contains(pageController) {
            self.hasShownControllers.append(pageController)
            scrollView.setContentOffset(CGPoint(x: 0, y: -self.headerHeight - self.segmentHeight), animated: false)
        }
        
        self.view.addConstraint(NSLayoutConstraint(item: pageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: pageView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0))
    }

    func addObserverForPageController(controller: TableViewController) {
        guard let scrollView = self.scrollViewInPageController(controller: controller) else {
            return
        }
        
        self.disposable1 = Observable.zip(scrollView.rx.contentOffset.skip(1), scrollView.rx.contentOffset).subscribe(onNext: {
            
            guard let offset = $0 else {
                return
            }
            
            guard let oldOffset = $1 else {
                return
            }
            
            let offsetY = offset.y
            let oldOffsetY = oldOffset.y
            let deltaOfOffsetY = offset.y - oldOffsetY
            let offsetYWithSegment = offset.y + self.segmentHeight
            
            
            self.headerContentsView.updateScrollOffset(contentOffset: offset)
            
            
            if deltaOfOffsetY > 0 && offsetY >= -(self.headerHeight + self.segmentHeight) {
                if (self.headerHeightConstraint.constant - deltaOfOffsetY) <= 0 {
                    self.headerHeightConstraint.constant = self.segmentMiniTopInset
                } else {
                    self.headerHeightConstraint.constant -= deltaOfOffsetY
                }
                
                if self.headerHeightConstraint.constant <= self.segmentMiniTopInset {
                    self.headerHeightConstraint.constant = self.segmentMiniTopInset
                }
            } else {
                if offsetY > 0 {
                    if self.headerHeightConstraint.constant <= self.segmentMiniTopInset {
                        self.headerHeightConstraint.constant = self.segmentMiniTopInset
                    }
                } else {
                    if self.headerHeightConstraint.constant >= self.headerHeight {
                        if -offsetYWithSegment > self.headerHeight && !self.freezenHeaderWhenReachMaxHeaderHeight {
                            self.headerHeightConstraint.constant = -offsetYWithSegment
                        } else {
                            self.headerHeightConstraint.constant = self.headerHeight
                        }
                    } else {
                        if self.headerHeightConstraint.constant < -offsetYWithSegment {
                            self.headerHeightConstraint.constant -= deltaOfOffsetY
                        }
                    }
                }
            }
            
            self.segmentTopInset = self.headerHeightConstraint.constant
        })
        
        self.disposable2 = scrollView.rx.contentInset.subscribe(onNext: {
            guard let inset = $0 else {
                return
            }
            
            if fabs(inset.top - self.originalTopInset) < 2 {
                self.ignoreOffsetChanged = false
            } else {
                self.ignoreOffsetChanged = true
            }
        })
    }
    
    func scrollViewInPageController(controller: TableViewController) -> UIScrollView? {
        if controller.responds(to: #selector(TableViewController.streachScrollView)) {
            return controller.streachScrollView()
        } else if controller.view.isKind(of: UIScrollView.self) {
            return controller.view as? UIScrollView
        } else {
            return nil
        }
    }
    
    @objc func segmentControlDidChangedValue(sender: UISegmentedControl) {
        
        self.removeObserverForPageController(controller: self.currentDisplayController)
        
        let index = sender.selectedSegmentIndex
        let controller = self.controllers[index]
        
        self.currentDisplayController.willMove(toParentViewController: nil)
        self.currentDisplayController.view.removeFromSuperview()
        self.currentDisplayController.removeFromParentViewController()
        self.currentDisplayController.didMove(toParentViewController: nil)
        
        controller.willMove(toParentViewController: self)
        self.view.insertSubview(controller.view, at: 0)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        
        self.currentDisplayController = controller
        
        self.layoutControllerWithController(pageController: controller)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        let scrollView = self.scrollViewInPageController(controller: controller)
        
        if self.headerHeightConstraint.constant != self.headerHeight {
            if (scrollView!.contentOffset.y >= -(self.segmentHeight + self.headerHeight)) && (scrollView!.contentOffset.y <= -self.segmentHeight) {
                scrollView!.setContentOffset(CGPoint(x: 0, y: -self.segmentHeight - self.headerHeightConstraint.constant), animated: false)
            }
        }
        
        self.addObserverForPageController(controller: self.currentDisplayController)
        scrollView!.setContentOffset(scrollView!.contentOffset, animated: false)
    }
    
    func removeObserverForPageController(controller: TableViewController) {
        guard let _ = self.scrollViewInPageController(controller: controller) else {
            return
        }
        
        self.disposable1?.dispose()
        self.disposable2?.dispose()
    }
}

extension Reactive where Base: UIScrollView {
    var contentOffset: Observable<CGPoint?> {
        return observe(CGPoint.self, #keyPath(UIScrollView.contentOffset))
    }
    
    var contentInset: Observable<UIEdgeInsets?> {
        return observe(UIEdgeInsets.self, #keyPath(UIScrollView.contentInset))
    }
}

