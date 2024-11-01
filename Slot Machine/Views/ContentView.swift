//
//  ContentView.swift
//  Slot Machine
//
//  Created by Piyapong Ukoad on 31/10/2567 BE.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    let haptic = UINotificationFeedbackGenerator()
    @State private var showingInfoView: Bool = false
    @State private var highscore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels: Array = [0, 1, 2]
    @State private var isActiveBel10: Bool = true
    @State private var isActiveBel20: Bool = false
    @State private var isShowingModal: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModel: Bool = false
    var symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    // MARK: - Function
    // Spin the Reels
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0..<symbols.count)
        })
        playSound(sound: "spin", type: "mp3")
        haptic.notificationOccurred(.success)
    }
    // Check the Winning
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[2] == reels[0] {
            // Player Wins
            playerWins()
            // New High Score
            if coins > highscore {
                newHighscore()
            } else {
                playSound(sound: "win", type: "mp3")
            }
        } else {
            // Player Loses
            playerLoses()
        }
    }
    func playerWins() {
        coins += betAmount * 10
    }
    func newHighscore() {
        highscore = coins
        UserDefaults.standard.set(highscore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    func playerLoses() {
        coins -= betAmount
    }
    func activateBet20() {
        betAmount = 20
        isActiveBel20 = true
        isActiveBel10 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptic.notificationOccurred(.success)
    }
    func activateBet10() {
        betAmount = 10
        isActiveBel10 = true
        isActiveBel20 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptic.notificationOccurred(.success)
    }
    // Game is Over
    func isGameOver() {
        if coins <= 0 {
            isShowingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - Background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPruple")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            // MARK: - Interface
            VStack(alignment: .center, spacing: 5) {
                // MARK: - Header
                LogoView()
                Spacer()
                
                // MARK: - Score
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    Spacer()
                    HStack {
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                // MARK: - Slot Machine
                VStack(alignment: .center, spacing: 0) {
                    // MARK: - Reel #1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: animatingSymbol)
                            .onAppear {
                                animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            }
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        // MARK: - Reel #2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: animatingSymbol)
                                .onAppear {
                                    animatingSymbol.toggle()
                                }
                        }
                        
                        Spacer()
                        
                        // MARK: - Reel #3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingSymbol)
                                .onAppear {
                                    animatingSymbol.toggle()
                                }
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    // MARK: - Spin Button
                    Button(action: {
                        withAnimation {
                            animatingSymbol = false
                        }
                        spinReels()
                        withAnimation {
                            animatingSymbol = true
                        }
                        checkWinning()
                        isGameOver()
                    }) {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                }
                
                // MARK: - Footer
                Spacer()
                
                HStack {
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            activateBet20()
                        }) {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundStyle(isActiveBel20 ? Color.yellow : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBel20 ? 0 : 20)
                            .opacity(isActiveBel20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBel10 ? 0 : -20)
                            .opacity(isActiveBel10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            activateBet10()
                        }) {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundStyle(isActiveBel10 ? Color.yellow : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }
                }
            }
            // MARK: - Button
            .overlay(alignment: .topLeading) {
                // Reset
                Button(action: {
                    resetGame()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .modifier(ButtonModifier())
                }
            }
            .overlay(alignment: .topTrailing) {
                // Info
                Button(action: {
                    showingInfoView = true
                }) {
                    Image(systemName: "info.circle")
                        .modifier(ButtonModifier())
                }
            }
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $isShowingModal.wrappedValue ? 5 : 0, opaque: false)
            
            // MARK: - Popup
            if $isShowingModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                        .ignoresSafeArea(.all)
                    VStack(spacing: 0) {
                        Text("Game Over")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            Text("Bad luck! You lost all of your coins. \nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                animatingModel = false
                                isShowingModal = false
                                activateBet10()
                                coins = 100
                            }) {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .tint(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundStyle(Color("ColorPink"))
                                    )
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity(animatingModel ? 1 : 0)
                    .offset(y: animatingModel ? 0 : -100)
                    .animation(.bouncy, value: animatingModel)
                    .onAppear {
                        animatingModel = true
                    }
                }
            }
        } //: ZStack
        .sheet(isPresented: $showingInfoView) {
            InfoVIew()
        }
    }
}

#Preview {
    ContentView()
}
