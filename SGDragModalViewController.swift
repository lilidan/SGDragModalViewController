//
//  SGDragModalViewController.swift
//  sweet
//
//  Created by sgcy on 15/3/13.
//  Copyright (c) 2015年 sgcy. All rights reserved.
//

import UIKit
protocol SGDragModalViewControllerDelegate:class{
    func SGDragModalViewControllerGoCenter(contentView:UIView)
    func SGDragModalViewControllerGoDown(contentView:UIView)
    func SGDragModalViewControllerGoUp(contentView:UIView)
}

enum SGDragModalStatus{
    case Down,Center,Up,Moving
}
class SGDragModalViewController:NSObject,UIGestureRecognizerDelegate,UIScrollViewDelegate{
    weak var delegate:SGDragModalViewControllerDelegate?
    private var contentView:UIView!
    
    private var bgView:UIView!
    private var scrollView:UIScrollView!
    
    var status:SGDragModalStatus = .Down
    
    private let CENTER_POSTION_Y = CGFloat(300)
    private let NAVIGATIONBAR_HEIGHT = CGFloat(64)
    
    
    
    
    
    private let contentViewPanGr:UIPanGestureRecognizer!
    init(bgView:UIView,scrollView:UIScrollView,delegate:SGDragModalViewControllerDelegate? = nil) {
        super.init()
        self.bgView = bgView
        self.delegate = delegate
        self.scrollView = scrollView
        
        
        
        // set the contentView's position when go center
        CENTER_POSTION_Y = bgView.frame.size.height*2/5
        
        
        //if iOS8, use UIVisualEffectView
        if NSClassFromString("UIVisualEffectView") != nil{
             self.contentView = UIVisualEffectView(effect:UIBlurEffect(style: .Light))
        }else{
             self.contentView = UIView()
             self.contentView.backgroundColor = UIColor.whiteColor()
        }
        contentView.frame = CGRect(origin:CGPoint(x:bgView.frame.origin.x, y:bgView.frame.size.height), size:CGSize(width:bgView.frame.size.width, height:0))
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.delegate = self
        contentView.addSubview(scrollView)
        bgView.addSubview(self.contentView)
        
        contentViewPanGr = UIPanGestureRecognizer(target:self, action:"move:")
        contentViewPanGr.delegate = self
        contentView.addGestureRecognizer(contentViewPanGr)
    }
    
    
        
    private var shouldScroll = false
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 || self.status != .Up{
            scrollView.contentOffset.y = 0
            shouldScroll = false
        }else{
            shouldScroll = true
        }
    }

    private var draggedOriginalFrame:CGRect!
    private var floatItemOriginalPoint:CGPoint!
    private var scrollViewOriginalContentY:CGFloat = 0
    func move(panGr:UIPanGestureRecognizer){
        if (panGr.state == UIGestureRecognizerState.Began){
            draggedOriginalFrame=contentView.frame
            scrollViewOriginalContentY = self.scrollView.contentOffset.y
            floatItemOriginalPoint = CGPointZero
        }else if (panGr.state == UIGestureRecognizerState.Changed){
            var translation=panGr.translationInView(bgView)
            //用来传值操作
            var cFrame = draggedOriginalFrame
            var itemPoint = floatItemOriginalPoint
            let floatItemHeight = CGFloat(0)
            cFrame.origin.y += translation.y
            itemPoint.y += translation.y
            if cFrame.origin.y > bgView.frame.size.height{
                cFrame.origin.y = bgView.frame.size.height
                itemPoint.y = bgView.frame.size.height - floatItemHeight
            }else if cFrame!.origin.y < NAVIGATIONBAR_HEIGHT + floatItemHeight {
                cFrame.origin.y = NAVIGATIONBAR_HEIGHT + floatItemHeight
                itemPoint.y = NAVIGATIONBAR_HEIGHT
            }
            if !shouldScroll && scrollViewOriginalContentY <= 0{
                self.status = .Moving
                contentView.frame=cFrame
                self.setContentViewHeight()
            }
        }else if (panGr.state == UIGestureRecognizerState.Ended){
            var translation=panGr.translationInView(bgView)
            
            if !shouldScroll && scrollViewOriginalContentY <= 0{
               if contentView.frame.origin.y < CENTER_POSTION_Y{
                   if translation.y > 0{
                       self.goCenter()
                   }else if translation.y < 0{
                       self.goUp()
                   }
               }else{
                   if translation.y > 0{
                       self.goDown()
                   }else if translation.y < 0{
                       self.goCenter()
                 }
               }
            }
        }
    }
    
    
    
    func goUp(){
        self.status = .Moving
        
        let floatItemHeight = CGFloat(0)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.contentView.frame.origin = CGPoint(x: self.contentView.frame.origin.x, y:self.NAVIGATIONBAR_HEIGHT + floatItemHeight)
            self.setContentViewHeight()
            }) { (bool:Bool) -> Void in
                self.status = .Up
                self.delegate?.SGDragModalViewControllerGoUp(self.contentView)
        }
    }
    
    func goDown(){
        self.status = .Moving
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.contentView.frame.origin = CGPoint(x: self.contentView.frame.origin.x, y:self.bgView.frame.size.height)
             self.setContentViewHeight()
            }) { (bool:Bool) -> Void in
                self.status = .Down
                self.delegate?.SGDragModalViewControllerGoDown(self.contentView)
        }
        
    }
    
    func goCenter(){
         self.status = .Moving
        let floatItemHeight = CGFloat(0)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.contentView.frame.origin = CGPoint(x: self.contentView.frame.origin.x, y:self.CENTER_POSTION_Y + floatItemHeight)
            self.setContentViewHeight()
            }) { (bool:Bool) -> Void in
                self.status = .Center
                self.delegate?.SGDragModalViewControllerGoCenter(self.contentView)
        }
    }
    
    
    private func setContentViewHeight(){
        self.contentView.frame.size = CGSize(width:self.contentView.frame.size.width, height:self.bgView.frame.height - self.contentView.frame.origin.y)
        self.scrollView.frame = self.contentView.bounds
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}