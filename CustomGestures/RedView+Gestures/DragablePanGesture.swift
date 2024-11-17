//
//  RedPanGesture.swift
//  CustomGestures
//
//  Created by Александр Рахимов on 12.11.2024.
//

import UIKit

final class DragablePanGesture: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let point = touch.location(in: self.view?.superview)
        guard let view = self.view as? DragableView else { return }
        
        view.currentSelfPosition = CGPoint(x: point.x - view.center.x, y: point.y - view.center.y)
        
        UIView.animate(withDuration: 0.3) {
            view.layer.transform = CATransform3DIdentity
            view.layer.transform = CATransform3DScale(view.layer.transform, 1.2, 1.2, 1.2)
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(1.0)
        }
        
        let vibroGenerator = UIImpactFeedbackGenerator(style: .medium)
        vibroGenerator.prepare()
        vibroGenerator.impactOccurred()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        let point = touch.location(in: self.view?.superview)
        guard let view = self.view as? DragableView else { return }
        guard let currentSelfPosition = view.currentSelfPosition else { return }
        
        view.center.x = point.x - currentSelfPosition.x
        view.center.y = point.y - currentSelfPosition.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        guard let superView = self.view?.superview else { return }
        guard let view = self.view as? DragableView else { return }
        
        let velocity = self.velocity(in: superView)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200
        let slideFactor = 0.1 * slideMultiplier
        
        
        var finalPoint = CGPoint(x: view.center.x + (velocity.x * slideFactor), y: view.center.y + (velocity.y * slideFactor))
        
        finalPoint.x = min(
            max(finalPoint.x, superView.bounds.minX + view.frame.width / 2.0),
            superView.bounds.maxX - view.frame.width / 2.0
        )
        finalPoint.y = min(
            max(finalPoint.y, superView.bounds.minY + superView.safeAreaInsets.top + view.frame.height),
            superView.bounds.maxY - superView.safeAreaInsets.bottom - view.frame.height
        )

        UIView.animate(
          withDuration: Double(slideFactor * 2),
          delay: 0,
          options: .curveEaseOut,
          animations: {
              view.center = finalPoint
              view.layer.transform = CATransform3DIdentity
              view.backgroundColor = view.backgroundColor?.withAlphaComponent(0.5)
        })
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        print("touchesCancelled")
    }
    
}
