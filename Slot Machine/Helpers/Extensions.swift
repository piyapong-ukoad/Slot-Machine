//
//  Extensions.swift
//  Slot Machine
//
//  Created by Piyapong Ukoad on 31/10/2567 BE.
//

import SwiftUI

extension Text {
    func scoreLabelStyle() -> Text {
        self
            .foregroundStyle(Color.white)
            .font(.system(size: 10, weight: .bold, design: .rounded))
    }
    
    func scoreNumberStyle() -> Text {
        self
            .foregroundStyle(Color.white)
            .font(.system(.title, design: .rounded))
            .fontWeight(.heavy)
    }
}
