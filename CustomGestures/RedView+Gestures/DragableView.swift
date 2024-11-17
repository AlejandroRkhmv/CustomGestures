//
//  DragableView.swift
//  CustomGestures
//
//  Created by Александр Рахимов on 12.11.2024.
//

import UIKit

protocol DragableViewDelegate {
    
    func showHidingAlert()
    
}

final class DragableView: UIView {
    
    var delegate: DragableViewDelegate?
    
    let leftImage = UIImageView(image: UIImage(systemName: "square.grid.4x3.fill"))
    let favoritesView = FavoritesView()
    
    let dragablePanGesture = DragablePanGesture()
    let imageLongPressGesture = UILongPressGestureRecognizer()
    
    var currentSelfPosition: CGPoint?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
        setupPanGesture()
        setupLongPressGesture()
        setupLeftImage()
        setupFavoritesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLeftImage()
        layoutFavoritesView()
    }
    
    private func layoutLeftImage() {
        
        let origin = CGPoint(x: UIEdgeInsets.insets.left, y: bounds.midY - CGSize.leftImageSize.height / 2.0)
        leftImage.frame = CGRect(origin: origin, size: CGSize.leftImageSize)
    }
    
    private func layoutFavoritesView() {
        let size = favoritesView.sizeThatFits(bounds.size)
        let origin = CGPoint(x: UIEdgeInsets.insets.left + CGSize.leftImageSize.width + .spacing, y: bounds.midY - size.height / 2.0)
        favoritesView.frame = CGRect(origin: origin, size: size)
    }
    
    // MARK: - Sizing
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width =
        UIEdgeInsets.insets.left
        + CGSize.leftImageSize.width
        + .spacing
        + favoritesView.sizeThatFits(size).width
        + UIEdgeInsets.insets.right
        
        return CGSize(width: width, height: 50.0)
    }
    
    // MARK: - Setup
    
    private func setupInitialState() {
        backgroundColor = .lightGray.withAlphaComponent(0.5)
        layer.cornerRadius = 12.0
    }
    
    // MARK: - Pan
    
    private func setupPanGesture() {
        dragablePanGesture.delegate = self
        addGestureRecognizer(dragablePanGesture)
    }
    
    private func setupLeftImage() {
        leftImage.tintColor = .black
        addSubview(leftImage)
    }
    
    private func setupFavoritesView() {
        addSubview(favoritesView)
    }
    
    // MARK: - Long press
    
    private func setupLongPressGesture() {
        imageLongPressGesture.delegate = self
        imageLongPressGesture.minimumPressDuration = 1.5
        addGestureRecognizer(imageLongPressGesture)
        imageLongPressGesture.addTarget(self, action: #selector(longPress(_:)))
    }
    
    @objc
    func longPress(_ gesture: UILongPressGestureRecognizer) {
        delegate?.showHidingAlert()
        let vibroGenerator = UIImpactFeedbackGenerator(style: .medium)
        vibroGenerator.prepare()
        vibroGenerator.impactOccurred()
    }
    
    
    // MARK: - Update
    func updateFavoritesView(with buttons: [UIButton]) {
        favoritesView.updateFavoritesView(with: buttons)
    }
}

// MARK: - UIGestureRecognizer
extension DragableView: UIGestureRecognizerDelegate {
    
    // Разрешаю жестам работать вместе на DragableView
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if (gestureRecognizer is UILongPressGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer) ||
            (gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer) {
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView is UIButton {
            return false
        }
        return true
    }
}

// MARK: - UIEdgeInsets
extension UIEdgeInsets {
    
    fileprivate static let insets = UIEdgeInsets(top: 6.0, left: 10.0, bottom: 6.0, right: 10.0)
    
}

// MARK: - CGFloat
extension CGFloat {
    
    fileprivate static let spacing = 4.0
    
}

// MARK: - CGSize
extension CGSize {
    
    fileprivate static let leftImageSize = CGSize(width: 28.0, height: 28.0)
    
}
