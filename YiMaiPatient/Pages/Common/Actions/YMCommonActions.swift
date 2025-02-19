//
//  YMCommonActions.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class YMCommonActions : PageJumpActions {
    
    private let PageBottomIconByCurrentPage = [
        YMCommonStrings.CS_PAGE_INDEX_NAME:[
            YMCommonStrings.CS_PAGE_INDEX_NAME:"IndexButtonHomeBlue"
        ]
    ]

    public func GoBack(sender : UITapGestureRecognizer){
        NavController?.popViewControllerAnimated(true)
    }
    
    override public func PageJumpToByImageViewSender(sender : UITapGestureRecognizer) {
        
        
        let targetView = sender.view!
        if(targetView.isKindOfClass(YMTouchableImageView)){
            let touchableView = targetView as! YMTouchableImageView
            let targetPageName = touchableView.UserStringData
            
            if(nil != self.PageBottomIconByCurrentPage[targetPageName]){
                PageCommonBottomView.BottomButtonImage = self.PageBottomIconByCurrentPage[targetPageName]!
            }
            
            if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
                DoJump(targetPageName)
            } else {
                print("page \(targetPageName) not exist")
            }
        }
    }
}