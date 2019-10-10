//
//  OnboardingViewController.swift
//  NAMU_Torch
//
//  Created by Danil Kurilo on 9/11/19.
//  Copyright © 2019 Danil Kurilo. All rights reserved.
//

import UIKit
import OnboardKit

class OnboardingViewController: UIViewController {
    
    static let shared = OnboardingViewController()
        
    lazy var onboardingPages: [OnboardPage] = {
        let pageOne = OnboardPage(title: "",
                                  imageName: "onboardPH",
                                  description: "Вітаємо у НАМУ, музеї левів! Цей AR-додаток допоможе тобі самостійно ознайомитись з експозицією першого поверху.",
                                  advanceButtonTitle: "")
        
        let pageTwo = OnboardPage(title: "",
                                  imageName: "onboardPH",
                                  description: "Але саме леви музею стануть твоїми провідниками. Почни йти за слідами лева, щоб розпочати екскурсію!",
                                  advanceButtonTitle: "")
        
        let pageThree = OnboardPage(title: "",
                                    imageName: "onboardPH",
                                    description: "Наведи камеру на картину та тисни на цифри, щоб відкрити цікаві факти про експонат.",
                                    advanceButtonTitle: ""
                                    )
        
        let pageFour = OnboardPage(title: "",
                                   imageName: "onboardPH",
                                   description: "Щоб продовжити екскурсію натисни «Далі» та знову прямуй за левовим слідом до наступного експонату.",
                                   advanceButtonTitle: ""
                                   )
        
        let pageFive = OnboardPage(title: "", imageName: "onboardPH", description: "Якщо ти відкриєш всі цифри на картинах, в останній залі зможеш побачити секретні фонди НАМУ!", advanceButtonTitle: "Почати!")
        
        return [pageOne, pageTwo, pageThree, pageFour, pageFive]
    }()
    

    func createOnboardingVC() -> OnboardViewController {
        let tintColor = UIColor(red: 0, green: 0.64, blue: 0.14, alpha: 1)
        let mediumTextFont = UIFont(name: "NAMU-1960", size: 14.0)!
        
        let actionButtonStyling: OnboardViewController.ButtonStyling = { button in
            button.setTitleColor(UIColor(red: 0, green: 0.64, blue: 0.14, alpha: 1), for: .normal)
            button.titleLabel?.font = UIFont(name: "NAMU-1960", size: 24.0)!
            //button.backgroundColor = UIColor(red: 0.04, green: 0.57, blue: 0.15, alpha: 1)
            //button.layer.cornerRadius = 7
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 172).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            
        }
        
        let appearanceConfiguration = OnboardViewController.AppearanceConfiguration(tintColor: tintColor, textColor: .black, backgroundColor: .white, imageContentMode: .scaleAspectFit, textFont: mediumTextFont, advanceButtonStyling: actionButtonStyling)
       
        let onboardingVC = OnboardViewController(pageItems: onboardingPages, appearanceConfiguration: appearanceConfiguration, completion: {
            UserDefaults.standard.set(true, forKey: "OnboardingComplete")
            print("onboarding complete")
        })
        
        return onboardingVC
       
    }

    
}
