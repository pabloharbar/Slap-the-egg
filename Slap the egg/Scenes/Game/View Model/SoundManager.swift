//
//  SoundManager.swift
//  Slap the egg
//
//  Created by Luísa Bacichett Trabulci on 09/02/22.
//

import AVKit
import SwiftUI

class SoundsManager {
    
    static let instance = SoundsManager()
    
    var player: AVAudioPlayer?
    enum SoundOption: String {
        case faceSlap
        case mouthPop
        case eggCrush
        case frying
        
    }
    
    func playSound(sound: SoundOption, soundEnabled: Bool) {
        if !soundEnabled {
            return
        }
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else {return}
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
        
    }
}


struct SoundManager: View {
    
    var body: some View {
        VStack(spacing: 40) {
            Button("Play sound 1") {
                SoundsManager.instance.playSound(sound: .faceSlap, soundEnabled: true)
            }
            Button("Play sound2") {
                SoundsManager.instance.playSound(sound: .mouthPop, soundEnabled: true)
            }
        }
    }
}

struct SoundManager_Previews: PreviewProvider {
    static var previews: some View {
        SoundManager()
    }
}
