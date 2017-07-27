//
//  SquareView.swift
//  VISUALOGYX
//
//  Created by Thanh-Tam Le on 10/27/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

class SquareView: UIView {
    var constraintsAdded = false
    
    var defaultWidthConstraint : NSLayoutConstraint!
    var defaultHeightConstraint : NSLayoutConstraint!
    var defaultVerticalConstraint : NSLayoutConstraint?
    var defaultHorizontalConstraint : NSLayoutConstraint?
    
    var preferredWidth : CGFloat! {
        return squareView.frame.width
    }
    
    var pendingRadius : CGFloat!
    
    let squareView = UIView()

    init() {
        super.init(frame: .zero)
        
        squareView.layer.borderColor = UIColor.yellow.cgColor
        squareView.layer.borderWidth = 1
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(overlayTapped))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target:self, action:#selector(overlayPinched))
        let panGestureRecognizer = UIPanGestureRecognizer(target:self, action:#selector(overlayPaned))
        
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        
        addGestureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(pinchGestureRecognizer)
        addGestureRecognizer(panGestureRecognizer)
        
        addSubview(squareView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            defaultWidthConstraint = squareView.autoSetDimension(.width, toSize: 100)
            defaultHeightConstraint = squareView.autoSetDimension(.height, toSize: 100)
            defaultVerticalConstraint = squareView.autoPinEdge(toSuperviewEdge: .left)
            defaultHorizontalConstraint = squareView.autoPinEdge(toSuperviewEdge: .top
            
            )
            
        }
        super.updateConstraints()
        
        var angle : Double!
        
        switch UIDevice.current.orientation {
        case .portrait:
            angle = 0
            
        case .portraitUpsideDown:
            angle = M_PI
            
        case .landscapeLeft:
            angle = M_PI_2
            
        case .landscapeRight:
            angle = -M_PI_2
            
        default:
            angle = Double.infinity
        }
        
        if angle != Double.infinity {
            UIView.animate(withDuration: 0.25, animations:{
                let transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                
                self.squareView.transform = transform
                self.layoutIfNeeded()
                }, completion: {
                    _ in
            })
        }
    }
    
    func moveSquareToCenter() {
        defaultVerticalConstraint?.constant = UIScreen.main.bounds.width / 2 - 50
        defaultHorizontalConstraint?.constant = UIScreen.main.bounds.height / 2 - 50
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
    }
    
    // touch
    
    func overlayTapped(touch: UIGestureRecognizer) {
        moveToCenter(center: touch.location(in: self))
    }
    
    func moveToCenter(center: CGPoint) {
        
        var rect = squareView.frame
        rect.origin.x = center.x - rect.size.width / 2
        rect.origin.y = center.y - rect.size.height / 2
        
        let offset : CGFloat = 40
        if rect.maxX > frame.maxX - offset && rect.minY < offset {
            return
        }
        if rect.maxX > frame.maxX - offset && rect.maxY > frame.maxY - offset {
            return
        }
        if rect.minX < offset && rect.minY < offset {
            return
        }
        if rect.minX < offset && rect.maxY > frame.maxY - offset {
            return
        }
        
        defaultHorizontalConstraint?.constant = rect.origin.y
        defaultVerticalConstraint?.constant = rect.origin.x
    }
    
    var pendingCenter : CGPoint!
    func overlayPaned(touch: UIPanGestureRecognizer) {
        switch touch.state {
        case .began:
            pendingCenter = squareView.center
            
        case .changed:
                let translation = touch.translation(in: self)
                let newCenter = CGPoint(x: pendingCenter.x + translation.x, y:
                    pendingCenter.y + translation.y)
                moveToCenter(center: newCenter)
        default:
            break
        }
    }
    
    func overlayPinched(touch: UIPinchGestureRecognizer) {
        
        switch touch.state {
        case .began:
            pendingRadius = squareView.frame.width
        case .changed:
            var rect = squareView.frame
            if rect.size.width < 20 && touch.scale < 1{
                return
            }
            if rect.size.width > 320 && touch.scale > 1 {
                return
            }
            let delta = pendingRadius * (touch.scale - 1) * 0.1
            rect.origin.x = rect.origin.x - delta / 2
            rect.origin.y = rect.origin.y - delta / 2
            rect.size.width = rect.size.width + delta
            rect.size.height = rect.size.width
            
            defaultHorizontalConstraint?.constant = rect.origin.y
            defaultVerticalConstraint?.constant = rect.origin.x
            defaultWidthConstraint.constant = rect.width
            defaultHeightConstraint.constant = rect.height
            
        default:
            break
        }
    }
    
}
