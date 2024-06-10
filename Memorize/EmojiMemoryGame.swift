//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Samuel He on 2024/5/2.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    struct MemoryGameTheme: Identifiable {
        var id: String { name }
        
        let name: String
        let emojis: [String]
        let accentColor: Color
        let symbol: String
    }

    struct EmojiMemoryGameThemes {
        static let halloween = MemoryGameTheme(name: "Halloween", emojis: ["👻", "🎃", "💀", "🕷️", "👿", "🕸️","🐙", "🐍", "😵", "🙀", "🍬", "🧺"], accentColor: .purple, symbol: "ant")
        static let animal = MemoryGameTheme(name: "Animal", emojis: ["🐶", "🐭", "🐹", "🐰", "🦊", "🐻", "🐻‍❄️", "🐨", "🦁", "🐮", "🐷", "🐵"], accentColor: .pink, symbol: "pawprint")
        static let digital = MemoryGameTheme(name: "Digital", emojis: ["⌚️", "📱", "💻", "⌨️", "🤖", "🖨️", "⏰", "🎙️", "📺", "📽️", "📻", "🧭"], accentColor: .blue, symbol: "pc")

        static let allCases: [MemoryGameTheme] = [EmojiMemoryGameThemes.animal, EmojiMemoryGameThemes.halloween, EmojiMemoryGameThemes.digital]
    }

    
    private static let defaultTheme = EmojiMemoryGameThemes.halloween
    
    private static let defaultCardPairCount = 8
        
    private static func createMemoryGame(memoryGameTheme theme: MemoryGameTheme = defaultTheme, cardPairCount: Int = defaultCardPairCount) -> MemoryGame<String> {
        let themeEmojis = theme.emojis.shuffled()
        
        return MemoryGame(numberOfPairsOfCards: min(cardPairCount, themeEmojis.count)) { themeEmojis[$0] }
    }
    
    @Published private var memoryGame = createMemoryGame()
    
    var currentColor: Color = defaultTheme.accentColor
    
    var currentTheme: MemoryGameTheme = defaultTheme
    
    var cards: Array<Card> {
        return memoryGame.cards
    }
    
    var isGameFinished: Bool { cards.allSatisfy { $0.isMatched == true } }
    
    // MARK: - Intent
    
    func choose(_ card: Card) {
        memoryGame.chooseCard(card)
    }
    
    func startNewGame() {
        memoryGame.startNewGame()
        memoryGame.score = 0
    }
    
    func changeTheme(to theme: MemoryGameTheme) {
        currentColor = theme.accentColor
        currentTheme = theme
        
        memoryGame = EmojiMemoryGame.createMemoryGame(memoryGameTheme: theme)
        print("Theme changed: \(theme.name)")
    }
    
    func getScore() -> String {
        return String(memoryGame.score)
    }
}
