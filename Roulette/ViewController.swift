//
//  ViewController.swift
//  Roulette
//
//  Created by Toshiaki Nakamura on 2016/09/20.
//  Copyright © 2016年 Toshiaki Nakamura. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var announceImageView: UIImageView!
    
    private let transitionController = AnimatedTransition()
    
    // MARK: - オーバーライドメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.announceImageView.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBACtion
    @IBAction func pushAnnounceButton(sender: AnyObject) {
        self.announceImageView.hidden = true
        
        let rect = self.announceImageView.frame
        let center = self.announceImageView.center
        
        self.transitionController.image = self.announceImageView.image!
        self.transitionController.rect = rect
        self.transitionController.center = center
        self.transitionController.target = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewControllerWithIdentifier("RouletteViewController")
        nextViewController.transitioningDelegate = self
        nextViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        self.presentViewController(nextViewController, animated: true, completion: nil)
    }
    
    // MARK: - メソッド（アニメーション）
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionController.presenting = true
        return transitionController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionController.presenting = false
        return transitionController
    }
}

