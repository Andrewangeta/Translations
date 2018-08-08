//
//  ViewController.swift
//  Translations
//
//  Created by Andrew Edwards on 8/4/18.
//  Copyright © 2018 HelixBooking. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var blockingView: BlockingView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func spinToWin() {
        blockingView = BlockingView(frame: view.bounds, secure: true)
        view.addSubview(blockingView)
    }
    
    @IBAction func complete() {
        blockingView.stopAnimating(completion: .up)
    }
}

final class BlockingView: UIView {
    var loadingView: LoadingView!
    
    init(frame: CGRect, secure: Bool) {
        super.init(frame: frame)
        backgroundColor = .white
        alpha = 0.6
        loadingView = LoadingView(frame: CGRect(origin: CGPoint(x: bounds.width/2, y: bounds.height/2),
                                                size: CGSize(width: 100, height: 100)), secure: secure)
        loadingView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        addSubview(loadingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init required for decoder")
    }
    
    func stopAnimating(completion: LoadingCompletionType) {
        loadingView.stopAnimating()
        switch completion {
        case .none:
            removeFromSuperview()
        case .up:
            loadingView.checkView.animateCompletionUp()
            // 2.5 seconds because it takes 0.3 seconds to animate the check in and another 2.0 seconds to animate the check up and away.
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
                self.removeFromSuperview()
            }
        }
    }
}

final class LoadingView: UIView {
    var checkView: CheckView!
    
    init(frame: CGRect, secure: Bool = false) {
        super.init(frame: frame)
        setupLoadingIndicator(secure)
        checkView = CheckView(frame: CGRect(origin: bounds.origin, size: CGSize(width: 100, height: 100)))
        addSubview(checkView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init required for decoder")
    }
    
    let loadingLayer = CAShapeLayer()
    
    var loadingEndAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = 10000
        group.animations = [animation]
        
        return group
    }
    
    var loadingStartAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 0
        animation.beginTime = 0.5
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = 10000
        group.animations = [animation]
        
        return group
    }
    
    var loadingRotationAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 2
        animation.repeatCount = 10000
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    private func setupLoadingIndicator(_ secure: Bool) {
        loadingLayer.lineWidth = 5
        loadingLayer.fillColor = nil
        loadingLayer.strokeColor = UIColor.black.cgColor
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // set the radius to be the smallest of the height or width/2 and add extra padding from the line width so it'll be perfectly spherical
        let radius = min(bounds.width, bounds.height) / 2 - loadingLayer.lineWidth/2
        
        // Pi/2 is 90 degrees so -90 degrees is our starting point
        let startAngle = CGFloat(-(CGFloat.pi/2))
        
        // end angle is gonna be -90 + 180 so from -90 to +90.
        let endAngle = startAngle + CGFloat(CGFloat.pi * 2)
        
        // draw the circle
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // set the center of the loading layer to the center of the view itself
        loadingLayer.position = center
        
        loadingLayer.path = path.cgPath
        
        // show the lock if we need to
        if secure {
            let imageView = UIImageView(image: UIImage(named: "locked"))
            // set the width and height to the current views size minus 45 so it fits nicely inside of the loading view.
            imageView.frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width - 45, height: bounds.height - 45))
            imageView.center = center
            addSubview(imageView)
        }
        
        layer.addSublayer(loadingLayer)
        
        loadingLayer.add(loadingEndAnimation, forKey: "strokeEnd")
        loadingLayer.add(loadingStartAnimation, forKey: "strokeStart")
        loadingLayer.add(loadingRotationAnimation, forKey: "rotation")
    }
    
    func stopAnimating() {
        loadingLayer.removeAnimation(forKey: "strokeEnd")
        loadingLayer.removeAnimation(forKey: "strokeStart")
        loadingLayer.removeAnimation(forKey: "rotation")
        for view in subviews where view is UIImageView {
            view.removeFromSuperview()
        }
    }
}

final class CheckView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init required for decoder")
    }

    let checkLayer = CAShapeLayer()

    var checkPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.size.width * 0.22, y: frame.size.height * 0.50))
        path.addLine(to: CGPoint(x: frame.width * 0.38, y: frame.size.height * 0.68))
        path.addLine(to: CGPoint(x: frame.width * 0.76, y: frame.size.height * 0.33))
        return path
    }

    var checkAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.3
        return animation
    }

    func setupCheckView() {
        checkLayer.strokeColor = UIColor.black.cgColor
        checkLayer.fillColor = nil
        checkLayer.lineWidth = 5.0
        checkLayer.path = checkPath.cgPath
        layer.addSublayer(checkLayer)
    }

    func animateTaskCompletion() {
        setupCheckView()
        checkLayer.add(checkAnimation, forKey: nil)
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
            self.superview!.superview!.center = CGPoint(x: 270, y: 150)
            self.superview!.superview!.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }, completion: { complete in
            UIView.animate(withDuration: 0.5, animations: {
                self.superview!.superview!.alpha = 0.0
            }, completion: nil)
        })
    }

    func animateCompletionUp() {
        setupCheckView()
        checkLayer.add(checkAnimation, forKey: nil)
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
            self.superview!.center = CGPoint(x: self.superview!.center.x, y: self.superview!.center.y - 550.0)
        }, completion: { (complete) in
            UIView.animate(withDuration: 0.5, animations: {
                self.superview!.superview!.alpha = 0.0
            }, completion: nil)
        })
    }
}

public enum LoadingCompletionType {
    case none
    case up
}
