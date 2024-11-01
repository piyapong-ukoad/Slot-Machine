//
//  ReelView.swift
//  Slot Machine
//
//  Created by Piyapong Ukoad on 31/10/2567 BE.
//

import SwiftUI

struct ReelView: View {
    var body: some View {
        Image("gfx-reel")
            .resizable()
            .modifier(ImageModifier())
    }
}

#Preview(traits: .fixedLayout(width: 220, height: 220)) {
    ReelView()
}
