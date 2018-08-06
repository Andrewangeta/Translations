//
//  ViewController.swift
//  Translations
//
//  Created by Andrew Edwards on 8/4/18.
//  Copyright © 2018 HelixBooking. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var viewcheck: CompletionTaskView!
//    var checkPath: UIBezierPath = UIBezierPath()
//    var checkLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func remove(_ sender: Any) {
        for view in view.subviews where view is CompletionTaskView {
           view.removeFromSuperview()
        }
    }
    
    @IBAction func animate() {
        viewcheck = CompletionTaskView(frame: CGRect(origin: CGPoint(x: view.frame.width * 0.40, y: view.frame.height * 0.40), size: CGSize(width: 100, height: 100)))
        viewcheck.backgroundColor = .red
        viewcheck.layer.cornerRadius = viewcheck.frame.size.width/2
        view.addSubview(viewcheck)
        viewcheck.animateTaskCompletion()
        
//        UIView.animate(withDuration: 2.0, animations: 1.0, completion: {
//            //.origin = CGPoint(x: 120, y: 150)
//        }
//        DispatchQueue.main.async {
                // = CGAffineTransform(translationX: 120.0, y: -100.0)
                //self.viewcheck.transform.// = CGAffineTransform(scaleX: 0.2, y: 0.2)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            CATransaction.begin()
//            CATransaction.setAnimationDuration(1)
//            self.viewcheck.layer.position = CGPoint(x: 270.0, y: 150.0)
//            self.viewcheck.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
//            CATransaction.commit()
//        }

//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0.0
//        animation.toValue = 1.0
//        animation.beginTime = 0.0
//        animation.duration = 1.0
        
//        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
//        scaleAnimation.fromValue = [1,1,1]
//        scaleAnimation.toValue = [0.2,0.2,0.2]
//        scaleAnimation.beginTime = 1.0
//        scaleAnimation.duration = 1.0
//
//        let positionAnimation = CABasicAnimation(keyPath: "position")
//        positionAnimation.fromValue = [checkLayer.position.x, checkLayer.position.y]
//        positionAnimation.toValue = [checkView.center.x + 80, checkView.center.y - 50]
//        positionAnimation.beginTime = 1.0
//        positionAnimation.duration = 1.0
//
//        let drawAndScale = CAAnimationGroup()
//        drawAndScale.animations = [animation, scaleAnimation, positionAnimation]
//        drawAndScale.duration = 2.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            CATransaction.begin()
//            CATransaction.setAnimationDuration(1)
//            self.checkLayer.position = CGPoint(x: self.checkView.center.x, y: self.checkView.center.y)
//            self.checkLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
//            CATransaction.commit()
//        }
//        checkLayer.add(animation, forKey: nil)
//        checkView.layer.addSublayer(checkLayer)
        
//        checkLayer.position = CGPoint(x: checkView.center.x + 80, y: checkView.center.y - 50)
//        checkLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
    }
}

final class CompletionTaskView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    var checkPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.size.width * 0.10, y: frame.size.height * 0.50))
        path.addLine(to: CGPoint(x: frame.width * 0.40, y: frame.size.height * 0.80))
        path.addLine(to: CGPoint(x: frame.width * 0.70, y: frame.size.height * 0.20))
        return path
    }
    
    var checkAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.3
        return animation
    }
    
    func setup() {
        let checkLayer = CAShapeLayer()
        checkLayer.strokeColor = UIColor.black.cgColor
        checkLayer.fillColor = nil
        checkLayer.lineWidth = 3.0
        checkLayer.path = checkPath.cgPath
        layer.addSublayer(checkLayer)
        checkLayer.add(checkAnimation, forKey: nil)
    }
    
    func animateTaskCompletion() {
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
            self.center = CGPoint(x: 120, y: 150)
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)//.scaledBy(x: 0.2, y: 0.2)
        }, completion: { complete in
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0.0
            }, completion: nil)
        })
    }
}
