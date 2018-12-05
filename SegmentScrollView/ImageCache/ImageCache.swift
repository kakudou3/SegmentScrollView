//
//  ImageCache.swift
//  SegmentScrollView
//
//  Created by Akimichi Tanei on 2018/12/01.
//  Copyright © 2018 kakudooo. All rights reserved.
//

import Foundation
import UIKit
import Nuke
import RxNuke
import Cartography
import RxSwift
import RxCocoa

class ImageCache: UIView {
    
    let disposeBag: DisposeBag = .init()
    
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
        self.addSubview(imageView)
        
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
