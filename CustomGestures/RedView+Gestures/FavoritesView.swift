//
//  FavoritesView.swift
//  CustomGestures
//
//  Created by Александр Рахимов on 13.11.2024.
//

import UIKit

final class FavoritesView: UIView {
    
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    private var currentButtonPosition: CGPoint?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupStackView() {
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = .spacing
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutStackView()
    }
    
    private func layoutStackView() {
        stackView.frame = bounds
    }
    
    // MARK: - Sizing
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = (CGFloat(buttons.count) * CGSize.buttonSize.width) + (CGFloat((buttons.count - 1)) * CGFloat.spacing)
        return CGSize(
            width: width,
            height: CGSize.buttonSize.height
        )
    }
    
    // MARK: - Update
    
    func updateFavoritesView(with buttons: [UIButton]) {
        // Удаляю
        for button in self.buttons {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        // Обновляю массив кнопок
        self.buttons = buttons
        
        // Добавляю новые
        for button in buttons {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            panGesture.delegate = self
            button.addGestureRecognizer(panGesture)
            
            stackView.addArrangedSubview(button)
        }
        setupActions()
    }
    
    private func setupActions() {
        for button in self.buttons {
            button.removeTarget(nil, action: nil, for: .allEvents)
            let action = UIAction { _ in
                print(button.tag)
            }
            button.addAction(action, for: .touchUpInside)
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view as? UIButton else { return }
        
        switch gesture.state {
        case .began:
            button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            let point = gesture.location(in: stackView)
            currentButtonPosition = CGPoint(x: point.x - button.center.x, y: point.y - button.center.y)
        case .changed:
            
            let point = gesture.location(in: stackView)
            guard stackView.frame.contains(point) else { return }
            guard let currentButtonPosition = currentButtonPosition else { return }
            
            
            // Обновление положения кнопки по оси X
            button.center.x = point.x - currentButtonPosition.x
            gesture.setTranslation(.zero, in: stackView)
            
            // Определяются фреймы кнопок, тех которые должны уступить место перемещаемой
            for (index, otherButton) in stackView.arrangedSubviews.enumerated() where otherButton != button {
                let buttonFrame = stackView.convert(button.frame, from: button.superview)
                let otherButtonFrame = stackView.convert(otherButton.frame, from: otherButton.superview)
                
                if abs(buttonFrame.midX - otherButtonFrame.midX) <= 5 {
                    // Изменяется порядок
                    if let currentIndex = stackView.arrangedSubviews.firstIndex(of: button) {
                        stackView.removeArrangedSubview(button)
                        stackView.insertArrangedSubview(button, at: index)
                        
                        self.buttons.swapAt(currentIndex, index)
                        stackView.layoutIfNeeded()
                        
                        // Тут нужно еще через делегат отправить уведомление на изменение порядка в массиве фабрики
                        // А в реальном проекте обносить в сторе
                    }
                    break
                }
            }
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.3) { [weak self] in
                button.transform = .identity
                self?.stackView.setNeedsLayout()
            }
        default:
            break
        }
    }
}

// MARK: -
extension FavoritesView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: panGesture.view)
            // Распознавание только при горизонтальном движении
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }
    
}

// MARK: - UIEdgeInsets
extension UIEdgeInsets {
    
    fileprivate static let insets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
    
}

// MARK: - CGSize
extension CGSize {
    
    fileprivate static let buttonSize = CGSize(width: 28.0, height: 28.0)
    
}
                                                           
// MARK: - CGFloat
extension CGFloat {
    
    fileprivate static let spacing = 4.0
    
}
