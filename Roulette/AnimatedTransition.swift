//
//  AnimatedTransition.swift
//  PandaClean
//
//  Created by Toshiaki Nakamura on 2016/08/25.
//  Copyright © 2016年 Toshiaki Nakamura. All rights reserved.
//

import UIKit

class AnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = false
    var image = UIImage()
    var rect = CGRectZero
    var center = CGPointZero
    var target = UIViewController()
    
    private let imageView = UIImageView()
    private let durationPresent = 1.6
    private let durationDismiss = 0.3
    private let keyTransitionAnime = "transitionAnime"
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        if self.presenting {
            return self.durationPresent
        } else {
            return self.durationDismiss
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fvc = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let tvc = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fv = fvc?.view
        let tv = tvc?.view
        let cv = transitionContext.containerView()
        
        guard let fromVC = fvc, fromView = fv, toView = tv, containerView = cv else {
            return
        }
        let inframe = transitionContext.initialFrameForViewController(fromVC)
        let outframe = CGRectOffset(inframe, 0, CGRectGetHeight(inframe))
        
        if self.presenting {
            containerView.addSubview(toView)
            let animeGroup = self.setupAnimation(toView)
            
            self.imageView.image = self.image
            self.imageView.frame = self.rect
            containerView.addSubview(self.imageView)
            
            toView.alpha = 0.0
            UIView.animateWithDuration(
                self.transitionDuration(transitionContext),
                animations: { () -> Void in
                    self.imageView.layer.addAnimation(animeGroup, forKey: self.keyTransitionAnime)
                    toView.alpha = 0.5
                },
                completion: { (finished) -> Void in
                    toView.alpha = 1.0
                    
                    let completed = !transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(completed)
            })
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
            toView.frame = inframe
            UIView.animateWithDuration(
                self.transitionDuration(transitionContext),
                animations: { () -> Void in
                    fromView.frame = outframe
                },
                completion: { (finished) -> Void in
                    let completed = !transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(completed)
            })
        }
    }
    
    private func setupAnimation(toView: UIView) -> CAAnimationGroup {
        let moveDuration = 0.4
        let rotateEnd = 0.2
        let repeatCount: Float = 0.0
        
        // 移動する
        let x = self.center.x
        let heightStatusBar = UIApplication.sharedApplication().statusBarFrame.size.height
        let topHeight = heightStatusBar
        let y = self.center.y + topHeight
        let fromValuePosition = CGPointMake(x, y)
        let toValuePosition = toView.center
        let animeMove = CABasicAnimation(keyPath: "position")
        animeMove.fromValue = NSValue(CGPoint: fromValuePosition)
        animeMove.toValue  = NSValue(CGPoint: toValuePosition)
        animeMove.duration = moveDuration
        animeMove.autoreverses = false
        animeMove.repeatCount = repeatCount
        animeMove.fillMode = kCAFillModeForwards
        
        // 回転する
        var fromValue = 0.0
        var toValue = 3600 * M_PI / 180
        let animeRotate = CABasicAnimation(keyPath: "transform")
        animeRotate.fromValue = fromValue
        animeRotate.toValue = toValue
        animeRotate.duration = self.durationPresent - moveDuration - rotateEnd
        animeRotate.autoreverses = false
        animeRotate.repeatCount = repeatCount
        animeRotate.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)
        animeRotate.beginTime = moveDuration
        
        // フェードインする
        fromValue = 0.5
        toValue = 1.0
        let animeFadein = CABasicAnimation(keyPath: "opacity")
        animeFadein.fromValue = fromValue
        animeFadein.toValue   = toValue
        animeFadein.duration  = self.durationPresent - moveDuration
        animeFadein.autoreverses = false
        animeFadein.repeatCount = repeatCount
        animeFadein.beginTime = moveDuration
        
        // 上のアニメーションをグループ化して実行する
        let animeGroup = CAAnimationGroup()
        animeGroup.animations = [animeMove, animeRotate, animeFadein]
        animeGroup.duration = self.durationPresent
        animeGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animeGroup.removedOnCompletion = false
        animeGroup.delegate = self
        animeGroup.fillMode = kCAFillModeForwards
        
        return animeGroup
    }
    
    // MARK: - オーバーライドメソッド
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("アニメーション終わり")
        let transitionAnime = self.imageView.layer.animationForKey(self.keyTransitionAnime)
        if anim == transitionAnime {
            self.imageView.layer.removeAllAnimations()
            self.imageView.removeFromSuperview()
        }
    }
}
