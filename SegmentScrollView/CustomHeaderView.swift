//
//  CustomHeaderView.swift
//  SegmentScrollView
//
//  Created by Akimichi Tanei on 2018/11/06.
//  Copyright © 2018 kakudooo. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa
import FontAwesomeKit

class CustomHeaderView: UIView {
    
    /*override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 0)
    }*/
    
    let headerCoverView: UIImageView = .init(frame: .zero)
    let informationView: UIView = .init(frame: .zero)
    var iconImageView: UIImageView = .init(frame: .zero)
    var followButton: UIButton = .init(frame: .zero)
    var settingButton: UIButton = .init(frame: .zero)
    var nameLabel: UILabel = .init(frame: .zero)
    var sportsEventNameLabel: UILabel = .init(frame: .zero)
    var separeteLine: UIView = .init(frame: .zero)
    let introductionTextLabel: UILabel = .init(frame: .zero)
    
    var constrainGroup: ConstraintGroup?
    
    let disposeBag: DisposeBag = .init()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("this method should not called")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    private func setupView() {
        self.clipsToBounds = true
        
        self.headerCoverView.image = UIImage.init(named: "background.jpg")
        self.headerCoverView.contentMode = .scaleAspectFill
        self.headerCoverView.clipsToBounds = true
        self.addSubview(self.headerCoverView)
        
        constrain(self.headerCoverView) {
            $0.edges == $0.superview!.edges
        }
        
        self.informationView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.addSubview(self.informationView)
        
        // blur effect
        /*let blurEffect = UIBlurEffect(style: .dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView.alpha = 0.7
        self.blurEffectView.backgroundColor = UIColor.subOverlay
        self.addSubview(self.blurEffectView)*/
        
        // icon image view
        self.iconImageView.image = UIImage.init(named: "background.jpg")
        self.iconImageView.layer.masksToBounds = true
        self.iconImageView.layer.cornerRadius = 40
        self.iconImageView.isUserInteractionEnabled = true
        //self.iconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileHeaderContetsView.onIconImageTapped(sender:))))
        self.iconImageView.layer.borderWidth = 1.0
        self.iconImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.informationView.addSubview(self.iconImageView)
        
        // favorite list button
        self.followButton.setTitle("+ フォロー", for: .normal)
        self.followButton.setTitle("", for: .selected)
        let followingIconImage = UIImage(named: "FollowingIcon")
        self.followButton.tintColor = UIColor.white
        self.followButton.setImage(nil, for: .normal)
        //self.followButton.setImage(followingIconImage?.size(size: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate), for: .selected)
        self.followButton.setTitleColor(UIColor.white, for: .normal)
        //self.followButton.backgroundColor = UIColor.mainAccent
        self.followButton.sizeToFit()
        self.followButton.contentEdgeInsets = UIEdgeInsetsMake(9, 8, 9, 8)
        self.followButton.layer.masksToBounds = true
        self.followButton.layer.cornerRadius = 2
        //self.followButton.addTarget(self, action: #selector(ProfileHeaderContetsView.onFollowButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.followButton.isHidden = true
        self.informationView.addSubview(self.followButton)
        
        // setting button
        let settingIcon = FAKFontAwesome.ellipsisHIcon(withSize: 16)
        settingIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        self.settingButton.setImage(settingIcon?.image(with: CGSize(width: 16, height: 16)), for: .normal)
        self.settingButton.setTitleColor(UIColor.white, for: .normal)
        //self.settingButton.backgroundColor = UIColor.barBackground
        self.settingButton.sizeToFit()
        self.settingButton.contentEdgeInsets = UIEdgeInsetsMake(10, 14, 10, 14)
        self.settingButton.layer.masksToBounds = true
        self.settingButton.layer.cornerRadius = 2
        //self.settingButton.addTarget(self, action: #selector(ProfileHeaderContetsView.onSettingButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.informationView.addSubview(self.settingButton)
        
        // name label
        self.nameLabel.text = "kakudooo"
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.informationView.addSubview(nameLabel)
        
        // sports event label
        self.sportsEventNameLabel.text = "Freestyle Football"
        self.sportsEventNameLabel.textColor = UIColor.white
        self.sportsEventNameLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.informationView.addSubview(sportsEventNameLabel)
        
        // separate line
        self.separeteLine.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        self.informationView.addSubview(separeteLine)
        
        self.constrainGroup = constrain(self.informationView) {
            $0.edges == $0.superview!.edges
        }
        
        // introduction text label
        self.introductionTextLabel.text = "ステータスはまだ記入されていませんステータスはまだ記入されていませんステータスはまだ記入されていませんステータスはまだ記入されていませんステータスはまだ記入されていません"
        self.introductionTextLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        self.introductionTextLabel.font = UIFont.systemFont(ofSize: 16)
        self.introductionTextLabel.numberOfLines = 0
        self.introductionTextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.introductionTextLabel.textAlignment = .left
        //self.introductionTextLabel.addLineSpacing(space: 2)
        self.introductionTextLabel.sizeToFit()
        self.introductionTextLabel.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        self.informationView.addSubview(introductionTextLabel)
        
        constrain(self.introductionTextLabel, self.iconImageView, self.followButton, self.settingButton, self.nameLabel, self.sportsEventNameLabel, self.separeteLine) { (introductionText, iconImage, follow, setting, name, sportsEvent, separeteLine) in
            iconImage.height == 80
            iconImage.width == 80
            iconImage.leading == iconImage.superview!.leadingMargin + 5
            iconImage.top == iconImage.superview!.topMargin - 10
            /*if self.isDisplayNavigation {
                iconImageView.top == iconImageView.superview!.topMargin + 20
            } else {
                iconImageView.top == iconImageView.superview!.topMargin - 10
            }*/
            
            setting.centerY == iconImage.centerY
            setting.trailing == setting.superview!.trailing - 13
            
            //self.followButtonWidthConstraint = follow.width == 100
            follow.centerY == iconImage.centerY
            follow.trailing == setting.leading - 5
            
            name.height == 20
            name.leading == iconImage.leading
            name.top == iconImage.bottom + 20
            
            sportsEvent.height == 12
            sportsEvent.leading == iconImage.leading
            sportsEvent.top == name.bottom + 5
            
            separeteLine.height == 0.5
            separeteLine.top == sportsEvent.bottom + 15
            separeteLine.leading == separeteLine.superview!.leadingMargin + 5
            separeteLine.trailing == separeteLine.superview!.trailing - 13
            separeteLine.centerX == separeteLine.superview!.centerX
            
            introductionText.height >= 16
            introductionText.top == separeteLine.bottom + 10
            introductionText.left == introductionText.superview!.leftMargin
            introductionText.right == introductionText.superview!.rightMargin
        }
    }
    
    func updateScrollOffset(contentOffset: CGPoint) {
        
        if contentOffset.y >= -294 {
            //print(contentOffset.y)
            constrain(self.informationView, replace: self.constrainGroup!) {
                $0.top == $0.superview!.top + -(contentOffset.y) - 294
                $0.bottom == $0.superview!.bottom
                $0.leading == $0.superview!.leading
                $0.trailing == $0.superview!.trailing
            }
        }
        
        if contentOffset.y < -294 {
            //print(contentOffset.y)
            constrain(self.informationView, replace: self.constrainGroup!) {
                $0.top == $0.superview!.top + -(contentOffset.y) - 294
                $0.bottom == $0.superview!.bottom
                $0.leading == $0.superview!.leading
                $0.trailing == $0.superview!.trailing
            }
        }
    }
    
    func getIntroductionLabelHeight() -> CGFloat {
        return self.introductionTextLabel.sizeThatFits(self.introductionTextLabel.frame.size).height
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
         
        if view == self || view == self.informationView {
            return nil
        }
         
        return view
    }
}
