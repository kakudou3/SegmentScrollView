//
//  CustomTableViewCell.swift
//  SegmentScrollView
//
//  Created by Akimichi Tanei on 2018/11/06.
//  Copyright © 2018 kakudooo. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("this method should not called")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.loadView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print("reuse !!!!!!!")
    }
    
    private func loadView() {
        
    }
}
