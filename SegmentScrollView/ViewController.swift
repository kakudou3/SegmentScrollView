//
//  ViewController.swift
//  SegmentScrollView
//
//  Created by Akimichi Tanei on 2018/09/25.
//  Copyright © 2018年 kakudooo. All rights reserved.
//

import UIKit
import Cartography

class ViewController: UIViewController {
    
    let mainScrollView: UIScrollView = .init(frame: .zero)
    let tableView: UITableView = .init(frame: .zero)

    let contentView: UIView = .init(frame: .zero)
    let headerContentsView: UIView = .init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        constrain(self.mainScrollView) {
            $0.width == $0.superview!.width
            $0.edges == $0.superview!.edges
        }
        
        constrain(self.contentView) {
            $0.edges == $0.superview!.edges
        }
        
        constrain(self.headerContentsView) {
            $0.height == 1000
            $0.width == 100
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(self.mainScrollView.frame)
        print(self.contentView.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    func setUpView() {
        
        // main scroll view
        //self.mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.mainScrollView.backgroundColor = UIColor.green.withAlphaComponent(0.1)
        self.mainScrollView.isScrollEnabled = true
        self.mainScrollView.alwaysBounceVertical = true
        self.mainScrollView.isExclusiveTouch = true
        self.mainScrollView.delaysContentTouches = true
        self.mainScrollView.showsVerticalScrollIndicator = true
        self.mainScrollView.delegate = self
        self.view.addSubview(self.mainScrollView)
        
        // content view
        self.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        self.mainScrollView.addSubview(self.contentView)
        
        // header contents view
        self.headerContentsView.backgroundColor = UIColor.green
        self.contentView.addSubview(self.headerContentsView)
        
        // tablev view
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //self.tableView.delegate = self
        //self.tableView.dataSource = self
        //self.tableView.showsVerticalScrollIndicator = true
        //self.contentView.addSubview(self.tableView)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.mainScrollView {
            print(scrollView.contentOffset.y)
        }
        
        if scrollView == self.tableView {
            print(scrollView.contentOffset.y)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = UIColor.cyan.withAlphaComponent(0.1)
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
}
