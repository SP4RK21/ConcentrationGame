//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by SP4RK on 06/05/2019.
//  Copyright © 2019 SP4RK. All rights reserved.
//

import UIKit

class ConcentrarionViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairs: numberOfPairs)
    
    var numberOfPairs: Int {
        return (visibleCardButtons.count + 1) / 2
    }
    
    private var currentTopic = -1
    var theme: String? {
        didSet {
            emojiPool = theme ?? ""
            restartGame()
        }
    }
    
    private var emojiPool: String = ""
    var cardBackColor: UIColor = #colorLiteral(red: 1, green: 0.5960345864, blue: 0.2194521129, alpha: 1)
    var backgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter {!$0.superview!.isHidden}
    }
    
    
    override func viewDidLoad() {
        game.delegate = self
        load()
        updateViewFromModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    private func load() {
        view.backgroundColor = backgroundColor
        emojiPool = theme ?? ""
        if countLabel != nil && playButton != nil && visibleCardButtons != nil {
            countLabel.textColor = cardBackColor
            scoreLabel.textColor = cardBackColor
            playButton.backgroundColor = cardBackColor
            playButton.titleLabel?.textColor = view.backgroundColor
            for button in visibleCardButtons {
                button.backgroundColor = cardBackColor
            }
        }
    }
    
    @IBAction private func cardPress(_ sender: UIButton) {
        if let index = visibleCardButtons.firstIndex(of: sender) {
            game.pressCard(at: index)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateViewFromModel()
    }
    
    func updateLabels() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth :  5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5960345864, blue: 0.2194521129, alpha: 1)
        ]
        let attributedScoreString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact  ? "Score\n \(game.score)" : "Score: \(game.score)",
            attributes: attributes)
        let attributedFlipString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact  ? "Flips\n \(game.flipCount)" : "Flips: \(game.flipCount)",
            attributes: attributes)
        
        if visibleCardButtons != nil {
            scoreLabel.attributedText = attributedScoreString
            countLabel.attributedText = attributedFlipString
        }
    }
    
    private func updateViewFromModel() {
        for index in visibleCardButtons.indices {
            updateLabels()
            let button = visibleCardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                if (card.isMatched) {
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5960345864, blue: 0.2194521129, alpha: 0) : cardBackColor
                    button.setTitle("", for: UIControl.State.normal)
                }
            } else {
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5960345864, blue: 0.2194521129, alpha: 0) : cardBackColor
                button.setTitle("", for: UIControl.State.normal)
            }
        }
    }
    
    @IBAction private func playAgainButton(_ sender: UIButton) {
        restartGame()
    }
    
    private func restartGame() {
        load()
        cardEmoji.removeAll()
        game = Concentration(numberOfPairs: numberOfPairs)
        game.delegate = self
        updateViewFromModel()
    }
    
    private var cardEmoji = [Card : String]()
    
    private func emoji(for card: Card) -> String {
        let emoji = cardEmoji[card]
        if emoji == nil {
            if (!emojiPool.isEmpty) {
                let stringIndex = emojiPool.index(emojiPool.startIndex, offsetBy: emojiPool.count.arc4random)
                cardEmoji[card] = String(emojiPool.remove(at: stringIndex))
            } else {
                cardEmoji[card] = "?"
            }
        }
        return cardEmoji[card]!
    }
}

extension  Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

extension ConcentrarionViewController : ConcentrarionDelegate {
    func didModifyCards() {
        updateViewFromModel()
    }
}

