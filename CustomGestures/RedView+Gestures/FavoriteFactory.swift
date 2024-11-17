//
//  FavoriteFactory.swift
//  CustomGestures
//
//  Created by Александр Рахимов on 13.11.2024.
import UIKit
final class FavoriteFactory {
    
    private let imageNames = [
        "cloud.fog", 
        "rectangle.split.3x3.fill",
        "aqi.low",
        "cloud.drizzle.fill",
        "cloud.drizzle.circle",
        "cloud.bolt",
        "thermometer.variable.and.figure.circle",
        "square.and.arrow.up"
    ]
    private var favorites: [UIButton] = []
    
    func addNextFavorite() -> [UIButton] {
        let button = createButton()
        favorites.append(button)
        return favorites
    }
    
    func removeLastFavorite() -> [UIButton] {
        favorites.removeLast()
        return favorites
    }
    
    private func createButton() -> UIButton {
        let button = UIButton()

        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .clear
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.configurationUpdateHandler = { button in
            if button.isHighlighted {
                button.alpha = 0.5
            } else {
                button.alpha = 1.0
            }
        }
        button.configuration?.image = UIImage(systemName: imageNames[Int.random(in: 0...7)])
        button.configuration?.imageColorTransformer = UIConfigurationColorTransformer { _ in
            return .black
        }
        button.tag = favorites.count
        return button
    }
}

