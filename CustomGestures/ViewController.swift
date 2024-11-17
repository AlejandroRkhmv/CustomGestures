//
//  ViewController.swift
//  CustomGestures
//
//  Created by Александр Рахимов on 12.11.2024.
//

import UIKit

protocol ViewControllerInput: AnyObject {
    
    func isDragableViewHidden(isHidden: Bool)
    func present()
    func updateFavoritesView(with buttons: [UIButton])
    
}

final class ViewController: UIViewController {
    
    let output: ViewControllerOutput
    
    // MARK: - Gestures
    let twoTapOneFinger = UITapGestureRecognizer()
    let threeTapOneFinger = UITapGestureRecognizer()
    
    let twoTapTwoFinger = UITapGestureRecognizer()
    let threeTapTwoFinger = UITapGestureRecognizer()
    
    
    // MARK: - Views
    
    let dragableView = DragableView()
    let addFavoriteButton = UIButton()
    let removeFavoriteButton = UIButton()
    
    init(output: ViewControllerOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupGestures()
        setupAddFavoriteButton()
        setupremoveFavoriteButton()
        
        setupDragableView()
        layoutDragableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutAddFavoriteButton()
        layoutRemoveFavoriteButton()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.layoutDragableView()
        })
    }
    
    private func setupGestures() {
        twoTapOneFinger.addTarget(self, action: #selector(handleTap(_:)))
        twoTapOneFinger.numberOfTapsRequired = 2
        twoTapOneFinger.numberOfTouchesRequired = 1
        twoTapOneFinger.delegate = self
        view.addGestureRecognizer(twoTapOneFinger)
        
        threeTapOneFinger.addTarget(self, action: #selector(handleTap(_:)))
        threeTapOneFinger.numberOfTapsRequired = 3
        threeTapOneFinger.numberOfTouchesRequired = 1
        threeTapOneFinger.delegate = self
        view.addGestureRecognizer(threeTapOneFinger)
        
        twoTapTwoFinger.addTarget(self, action: #selector(handleTap(_:)))
        twoTapTwoFinger.numberOfTapsRequired = 2
        twoTapTwoFinger.numberOfTouchesRequired = 2
        twoTapTwoFinger.delegate = self
        view.addGestureRecognizer(twoTapTwoFinger)
        
        threeTapTwoFinger.addTarget(self, action: #selector(handleTap(_:)))
        threeTapTwoFinger.numberOfTapsRequired = 3
        threeTapTwoFinger.numberOfTouchesRequired = 2
        threeTapTwoFinger.delegate = self
        view.addGestureRecognizer(threeTapTwoFinger)
    }
    
    @objc
    func handleTap(_ gesture: UITapGestureRecognizer) {
        var tapGesture: TapGesture = .notRecognized

        if gesture.numberOfTapsRequired == 2 {
            if gesture.numberOfTouches == 1 {
                tapGesture = .oneFingerTwoTaps
            } else if gesture.numberOfTouches == 2 {
                tapGesture = .twoFingersTwoTaps
            }
        } else if gesture.numberOfTapsRequired == 3 {
            if gesture.numberOfTouches == 1 {
                tapGesture = .oneFingerThreeTaps
            } else if gesture.numberOfTouches == 2 {
                tapGesture = .twoFingersThreeTaps
            }
        }
        
        output.didTap(tapGesture: tapGesture)
    }
    
    // MARK: - SetupViews
    
    private func setupDragableView() {
        view.addSubview(dragableView)
        dragableView.delegate = self
        dragableView.isHidden = true
    }
    
    private func setupAddFavoriteButton() {
        view.addSubview(addFavoriteButton)
        
        var attributedTitle = AttributedString("Добавляется еще дровинг в фейвориты")
        attributedTitle.foregroundColor = .systemRed
        addFavoriteButton.configuration = .plain()
        addFavoriteButton.configuration?.attributedTitle = attributedTitle
        addFavoriteButton.configurationUpdateHandler = { button in
            if button.isHighlighted {
                button.alpha = 0.5
            } else {
                button.alpha = 1.0
            }
        }
        
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            output.didTriggerAddFavoriteButton()
        }
        addFavoriteButton.addAction(action, for: .touchUpInside)
    }
    
    private func setupremoveFavoriteButton() {
        view.addSubview(removeFavoriteButton)
        
        var attributedTitle = AttributedString("Удаляется последний дровинг из фейвориты")
        attributedTitle.foregroundColor = .systemRed
        removeFavoriteButton.configuration = .plain()
        removeFavoriteButton.configuration?.attributedTitle = attributedTitle
        removeFavoriteButton.configurationUpdateHandler = { button in
            if button.isHighlighted {
                button.alpha = 0.5
            } else {
                button.alpha = 1.0
            }
        }
        
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            output.didTriggerRemoveFavoriteButton()
        }
        removeFavoriteButton.addAction(action, for: .touchUpInside)
    }
    
    // MARK: - Layout
    
    private func layoutDragableView(with origin: CGPoint? = nil) {
        let size = dragableView.sizeThatFits(view.bounds.size)
        let originDragableView = CGPoint(x: view.center.x - size.width / 2.0, y: view.center.y - size.height / 2.0)
        
        dragableView.frame = CGRect(origin: origin ?? originDragableView, size: size)
    }
    
    private func layoutAddFavoriteButton() {
        let size = addFavoriteButton.sizeThatFits(view.bounds.size)
        addFavoriteButton.frame = CGRect(
            origin: CGPoint(
                x: (view.bounds.size.width - size.width) / 2.0,
                y: (view.bounds.size.height - size.height - 100.0)
            ),
            size: size
        )
    }
    
    private func layoutRemoveFavoriteButton() {
        let size = removeFavoriteButton.sizeThatFits(view.bounds.size)
        removeFavoriteButton.frame = CGRect(
            origin: CGPoint(
                x: (view.bounds.size.width - size.width) / 2.0,
                y: (view.bounds.size.height - size.height - 50.0)
            ),
            size: size
        )
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//            if (gestureRecognizer == twoTapOneFinger && otherGestureRecognizer == threeTapOneFinger) ||
//                (gestureRecognizer == twoTapTwoFinger && otherGestureRecognizer == threeTapTwoFinger) {
//                return true
//            }
//            return false
//        }
    
    // twoTapOneFinger или twoTapTwoFinger сработает только тогда, когда threeTapOneFinger или threeTapTwoFinger завершатся с неудачей.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(twoTapOneFinger) && otherGestureRecognizer.isEqual(threeTapOneFinger) ||
            gestureRecognizer.isEqual(twoTapTwoFinger) && otherGestureRecognizer.isEqual(threeTapTwoFinger) {
            return true
        }
        return false
    }
}

// MARK: - ViewControllerInput
extension ViewController: ViewControllerInput {
    
    func isDragableViewHidden(isHidden: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            dragableView.isHidden = isHidden
        }
    }
    
    func present() {
        let secondViewController = SecondViewController()
        let sheet = secondViewController.sheetPresentationController
        sheet?.detents = [.medium(), .large()]
        present(secondViewController, animated: true)
    }
    
    func updateFavoritesView(with buttons: [UIButton]) {
        dragableView.updateFavoritesView(with: buttons)
        let origin = dragableView.frame.origin
        layoutDragableView(with: origin)
    }
    
}

// MARK: - DragableViewDelegate
extension ViewController: DragableViewDelegate {
    
    func showHidingAlert() {
        let alert = UIAlertController(title: "Скрыть панель фейворитов?", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            self?.output.dragableView(isHidden: true)
        }))
        self.present(alert, animated: true)
    }
    
}
