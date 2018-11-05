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
import Nuke
import RxNuke

class ViewController: UIViewController {
    
    let mainScrollView: UIScrollView = .init(frame: .zero)
    let tableView: UITableView = .init(frame: .zero)

    let contentView: UIView = .init(frame: .zero)
    let headerContentsView: UIView = .init(frame: .zero)
    
    let disposeBag: DisposeBag = .init()
    
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
        
        constrain(self.headerContentsView, self.tableView) { (header, table) in
            header.height == 300
            header.width == 100
            header.top == header.superview!.top
            
            table.height == self.view.bounds.height
            table.width == self.view.bounds.width
            table.top == header.bottom
            table.bottom == table.superview!.bottom
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(self.mainScrollView.frame)
        print(self.contentView.frame)
        print(self.mainScrollView.contentSize.height)
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
        self.mainScrollView.isScrollEnabled = false
        self.mainScrollView.alwaysBounceVertical = false
        //self.mainScrollView.isExclusiveTouch = true
        //self.mainScrollView.delaysContentTouches = true
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
        
        self.imageLoad()
    }
    
    private func imageLoad() {
        var configuration: URLSessionConfiguration {
            let urlCache = DataLoader.sharedUrlCache
            let conf = URLSessionConfiguration.default
            
            conf.urlCache = URLCache(memoryCapacity: urlCache.memoryCapacity, diskCapacity: urlCache.diskCapacity, diskPath: "com.github.kean.Nuke.Cache")
            conf.requestCachePolicy = .returnCacheDataElseLoad
            return conf
        }
        
        let pipeline = ImagePipeline {
            $0.dataLoader = DataLoader(configuration: configuration)
        }
        
        ImagePipeline.shared = pipeline
        
        let imageView = UIImageView(frame: .zero)
        self.view.addSubview(imageView)
        
        constrain(imageView) {
            $0.height == 100
            $0.width == 100
            $0.top == $0.superview!.top
            $0.left == $0.superview!.left
        }
        
        let urlString = "https://pbs.twimg.com/profile_images/723852223252328448/-v6zm-YP_400x400.jpg"
        
        ImagePipeline.shared.rx.loadImage(with: URL(string: urlString)!).map({ $0.image }).asObservable().bind(to: imageView.rx.image).disposed(by: self.disposeBag)
    }
}

var scrollValue: CGFloat = 0
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        if scrollView.contentOffset.y >= 334 {
            
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

// キャッシュをHTTP Headerのmax ageで管理できるように
enum HttpDiskCache {
    struct CacheControl {
        var maxAge: Int?
    }
    
    struct Header {
        var cacheControl: CacheControl?
        var date: Date?
        var expires: Date?
    }
}

extension HTTPURLResponse {
    var header: HttpDiskCache.Header {
        return HttpDiskCache.Header()
    }
}


