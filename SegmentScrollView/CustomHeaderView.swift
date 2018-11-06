//
//  CustomHeaderView.swift
//  SegmentScrollView
//
//  Created by Akimichi Tanei on 2018/11/06.
//  Copyright © 2018 kakudooo. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
    required init?(coder aDecoder: NSCoder) {
        fatalError("this method should not called")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadView()
    }
    
    private func loadView() {
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        if view == self {
            return nil
        }
        
        return view
    }
}

