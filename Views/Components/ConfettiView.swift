//
//  ConfettiView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI

/// Confetti animation view for celebrations
struct ConfettiView: View {
    @State private var animate = false
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece(color: colors.randomElement() ?? .blue)
                    .offset(
                        x: randomX(),
                        y: animate ? 1000 : -100
                    )
                    .rotationEffect(.degrees(animate ? 720 : 0))
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: Double.random(in: 1.5...2.5))
                            .delay(Double.random(in: 0...0.3)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
        .allowsHitTesting(false)
    }
    
    private func randomX() -> CGFloat {
        CGFloat.random(in: -200...200)
    }
}

struct ConfettiPiece: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 10, height: 10)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ConfettiView()
    }
}
