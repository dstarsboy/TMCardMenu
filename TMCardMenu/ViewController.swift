//
//  ViewController.swift
//  TMCardMenu
//
//  Created by Travis Ma on 8/1/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var constraintView4Leading: NSLayoutConstraint!
    @IBOutlet weak var constraintView4Top: NSLayoutConstraint!
    @IBOutlet weak var constraintView3Leading: NSLayoutConstraint!
    @IBOutlet weak var constraintView3Top: NSLayoutConstraint!
    @IBOutlet weak var constraintView2Leading: NSLayoutConstraint!
    @IBOutlet weak var constraintView2Top: NSLayoutConstraint!
    @IBOutlet weak var constraintView1Leading: NSLayoutConstraint!
    @IBOutlet weak var constraintView1Top: NSLayoutConstraint!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    private var constraintViews = [[String: AnyObject]]()
    private let spacing: CGFloat = 40
    private var lastViewedTag = 0
    private var isFullScreen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view2.alpha = 0
        view3.alpha = 0
        view4.alpha = 0
        lastViewedTag = view1.tag
        constraintViews = [
            [
                "view": view4,
                "top": constraintView4Top,
                "leading": constraintView4Leading
            ],
            [
                "view": view3,
                "top": constraintView3Top,
                "leading": constraintView3Leading
            ],
            [
                "view": view2,
                "top": constraintView2Top,
                "leading": constraintView2Leading
            ],
            [
                "view": view1,
                "top": constraintView1Top,
                "leading": constraintView1Leading
            ]
        ]
        for viewData in constraintViews {
            let v = viewData["view"] as! UIView
            let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTap(_:)))
            v.addGestureRecognizer(gesture)
        }
    }
    
    func maximizeView(_ tag: Int) {
        self.view.isUserInteractionEnabled = false
        for viewData in constraintViews {
            let v = viewData["view"] as! UIView
            if v.tag == tag {
                let leading = viewData["leading"] as! NSLayoutConstraint
                leading.constant = 0
                let top = viewData["top"] as! NSLayoutConstraint
                top.constant = 0
            } else {
                let leading = viewData["leading"] as! NSLayoutConstraint
                leading.constant = self.view.frame.width
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            for viewData in self.constraintViews {
                let v = viewData["view"] as! UIView
                if v.tag != tag {
                    v.alpha = 0
                }
            }
            }, completion: { completed in
                self.view.isUserInteractionEnabled = true
                self.view.bringSubview(toFront: self.btnMenu)
        })
        lastViewedTag = tag
        isFullScreen = true
        btnMenu.setTitle("=", for: UIControlState())
    }
    
    func viewTap(_ sender: UITapGestureRecognizer) {
        maximizeView(sender.view!.tag)
    }
    
    @IBAction func btnMenuTap(_ sender: AnyObject) {
        self.view.isUserInteractionEnabled = false
        if isFullScreen {
            isFullScreen = false
            btnMenu.setTitle("x", for: UIControlState())
            //loop once, set hidden views offscreen
            var positionY: CGFloat = 0
            for viewData in constraintViews {
                let v = viewData["view"] as! UIView
                positionY += spacing
                if v.alpha == 0 {
                    let leading = viewData["leading"] as! NSLayoutConstraint
                    leading.constant = self.view.frame.width
                    let top = viewData["top"] as! NSLayoutConstraint
                    top.constant = positionY
                }
                self.view.bringSubview(toFront: v)
                v.alpha = 1
            }
            self.view.layoutIfNeeded()
            //loop again, animate into position
            positionY = 0
            var positionX: CGFloat = 0
            var animationDelay: TimeInterval = 0
            var counter = 0
            for viewData in constraintViews {
                positionY += spacing
                positionX += spacing / 4
                let leading = viewData["leading"] as! NSLayoutConstraint
                leading.constant = positionX
                let top = viewData["top"] as! NSLayoutConstraint
                top.constant = positionY
                animationDelay += 0.1
                counter += 1
                UIView.animate(withDuration: 0.8, delay: animationDelay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                    self.view.layoutIfNeeded()
                    }, completion: { completed in
                        if counter == self.constraintViews.count {
                            self.view.isUserInteractionEnabled = true
                            self.view.bringSubview(toFront: self.btnMenu)
                        }
                })
            }
        } else {
            maximizeView(lastViewedTag)
        }
    }
    
}

