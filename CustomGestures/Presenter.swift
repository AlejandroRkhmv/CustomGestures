//
//  Presenter.swift
//  CustomGestures
//
//  Created by Александр Рахимов on 12.11.2024.
//

import Foundation

enum TapGesture: Int {
    
    case oneFingerTwoTaps
    case oneFingerThreeTaps
    case twoFingersTwoTaps
    case twoFingersThreeTaps
    case notRecognized
    
}

protocol ViewControllerOutput: AnyObject {
    
    func didTap(tapGesture: TapGesture)
    func didTriggerAddFavoriteButton()
    func didTriggerRemoveFavoriteButton()
    func dragableView(isHidden: Bool)
    
}

final class Presenter: ViewControllerOutput {
    
    weak var view: (any ViewControllerInput)?
    let favoriteFactory: FavoriteFactory
    
    init(favoriteFactory: FavoriteFactory) {
        self.favoriteFactory = favoriteFactory
    }
    
    func didTap(tapGesture: TapGesture) {
        switch tapGesture {
        case .oneFingerTwoTaps:
            dragableView(isHidden: false)
        case .oneFingerThreeTaps:
            dragableView(isHidden: true)
        case .twoFingersTwoTaps:
            view?.present()
        case .twoFingersThreeTaps:
            print("qwe")
        case .notRecognized:
            break
        }
    }
    
    func didTriggerAddFavoriteButton() {
        let favoriteButtons = favoriteFactory.addNextFavorite()
        if favoriteButtons.count <= 7 {
            view?.updateFavoritesView(with: favoriteButtons)
        } else {
            //меняем лайаут
        }
    }
    
    func didTriggerRemoveFavoriteButton() {
        let updatedButtons = favoriteFactory.removeLastFavorite()
        view?.updateFavoritesView(with: updatedButtons)
    }
    
    func dragableView(isHidden: Bool) {
        view?.isDragableViewHidden(isHidden: isHidden)
    }
}
