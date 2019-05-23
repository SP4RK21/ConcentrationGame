//
//  ConcetrationThemeChooserViewController.swift
//  ConcentrationGame
//
//  Created by SP4RK on 12/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

class ConcetrationThemeChooserViewController: UIViewController {
    
    private var themes = ["Animals" : "🦊🐻🐼🐨🐯🦁🐸🐵🐲🐙",
                          "Faces": "😊😅😍😇😉🙃🤬😱😴🤔",
                          "Food": "🍏🥝🍊🍋🍌🍉🍇🍓🍑🥭",
                          "Sweets": "🍭🍬🍫🍪🍩🍦🧁🍰🎂🍧",
                          "Sport": "⚽️🏀🥌🛹🏆🎱🥏🏓🥅⛳️",
                          "Transport": "🚗🚎🏎🛸🚀🛶🚄🛳✈️🚲"
    ]
    
    @IBAction func chooseTheme(_ sender: Any) {
        if let cvc = lastSeguedController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var lastSeguedController: ConcentrarionViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("lol")
        if segue.identifier == "Choose Theme" {
            print("boop")
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrarionViewController {
                    cvc.theme = theme
                    lastSeguedController = cvc
                }
            }
        }
    }
}
