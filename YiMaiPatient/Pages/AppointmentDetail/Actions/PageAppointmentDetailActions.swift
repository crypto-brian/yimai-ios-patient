//
//  PageAppointmentDetailActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import ImageViewer

public class PageAppointmentDetailActions: PageJumpActions, ImageProvider {
    var TargetView: PageAppointmentDetailBodyView? = nil
    private var DetailApi: YMAPIUtility? = nil
    private var PayApi: YMAPIUtility? = nil
    
    var TachedImageIdx: Int = 0
    public var imageCount: Int { get { return TargetView!.ImageList.count } }
    public func provideImage(completion: UIImage? -> Void) {
        if(0 == TargetView!.ImageList.count) {
            completion(nil)
        } else {
            completion(TargetView!.ImageList[0].image)
        }
    }
    public func provideImage(atIndex index: Int, completion: UIImage? -> Void) {
        completion(TargetView!.ImageList[index].image)
    }

    override func ExtInit() {
        super.ExtInit()
        
        DetailApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_DETAIL,
                                 success: DetailGetSuccess, error: DetailGetError)
        
        PayApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GOTO_PAY, success: GoToPaySuccess, error: GoToPayError)
        TargetView = self.Target as? PageAppointmentDetailBodyView
    }
    
    private func DetailGetSuccess(data: NSDictionary?) {
        print(data)
        TargetView?.LoadData(data!)
    }
    
    private func DetailGetError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func GoToPaySuccess(data: NSDictionary?) {
        let prepayInfo = data!["data"] as! [String: AnyObject]
        let req = PayReq()
        req.openID = "\(prepayInfo["appid"]!)"
        req.partnerId = "\(prepayInfo["partnerid"]!)"
        req.prepayId = "\(prepayInfo["prepayid"]!)"
        req.nonceStr = "\(prepayInfo["noncestr"]!)"
        req.timeStamp = UInt32(NSDate().timeIntervalSince1970)
        req.package = "\(prepayInfo["package"]!)"
        req.sign = "\(prepayInfo["sign"]!)"
        TargetView?.FullPageLoading.Hide()
        WXApi.sendReq(req)
    }
    
    func GoToPayError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("订单生成失败！", nav: self.NavController!)
    }
    
    public func GetDetail() {
        DetailApi?.YMGetAppointmentDetail(PageAppointmentDetailViewController.AppointmentID)
    }
    
    public func TextDetailTouched(sender: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollLeft (_: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollRight (_: UIGestureRecognizer) {
        
    }
    
    public func ImageTouched(gr: UITapGestureRecognizer) {
        let img = gr.view as! YMTouchableImageView
        let imgIdx = Int(img.UserStringData)
        let galleryViewController = GalleryViewController(imageProvider: self, displacedView: self.TargetView!.ParentView!,
                                                          imageCount: TargetView!.ImageList.count, startIndex: imgIdx!, configuration: DefaultGalleryConfiguration())
        NavController!.presentImageGallery(galleryViewController)
    }
    
    func GoToPayTouched(sender: YMButton) {
        print(PageAppointmentDetailViewController.AppointmentID)
        PayApi?.YMGetPayInfo(PageAppointmentDetailViewController.AppointmentID)
        TargetView?.FullPageLoading.Show()
    }
    
    func DefaultGalleryConfiguration() -> GalleryConfiguration {
        
        let dividerWidth = GalleryConfigurationItem.ImageDividerWidth(10)
        let spinnerColor = GalleryConfigurationItem.SpinnerColor(UIColor.whiteColor())
        let spinnerStyle = GalleryConfigurationItem.SpinnerStyle(UIActivityIndicatorViewStyle.White)
        
        let closeButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40.LayoutVal(), height: 40.LayoutVal())))
        closeButton.setImage(UIImage(named: "YMIconCloseBtn"), forState: UIControlState.Normal)
        closeButton.setImage(UIImage(named: "YMIconCloseBtn"), forState: UIControlState.Highlighted)
        let closeButtonConfig = GalleryConfigurationItem.CloseButton(closeButton)
        
//        let seeAllButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 50)))
//        seeAllButton.setTitle("显示全部", forState: .Normal)
//        let seeAllButtonConfig = GalleryConfigurationItem.SeeAllButton(seeAllButton)
        
        let pagingMode = GalleryConfigurationItem.PagingMode(GalleryPagingMode.Standard)
        
        let closeLayout = GalleryConfigurationItem.CloseLayout(ButtonLayout.PinRight(40, 40))
//        let seeAllLayout = GalleryConfigurationItem.CloseLayout(ButtonLayout.PinLeft(8, 16))
        let headerLayout = GalleryConfigurationItem.HeaderViewLayout(HeaderLayout.Center(25))
        let footerLayout = GalleryConfigurationItem.FooterViewLayout(FooterLayout.Center(25))
        
        let statusBarHidden = GalleryConfigurationItem.StatusBarHidden(true)
        
        let hideDecorationViews = GalleryConfigurationItem.HideDecorationViewsOnLaunch(false)
        
        let backgroundColor = GalleryConfigurationItem.BackgroundColor(YMColors.OpacityBlackMask)
        
        return [dividerWidth, spinnerStyle, spinnerColor, closeButtonConfig, pagingMode, headerLayout, footerLayout, closeLayout, statusBarHidden, hideDecorationViews, backgroundColor]
    }
}











