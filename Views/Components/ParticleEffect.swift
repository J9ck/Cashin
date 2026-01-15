//
//  ParticleEffect.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI

/// Particle effect for balance increases/decreases
struct ParticleEffect: View {
    let isPositive: Bool
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                Particle(isPositive: isPositive)
                    .offset(
                        x: randomX(),
                        y: animate ? randomY() : 0
                    )
                    .opacity(animate ? 0 : 1)
                    .scaleEffect(animate ? 2 : 0.5)
                    .animation(
                        .easeOut(duration: 0.8)
                            .delay(Double(index) * 0.05),
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
        CGFloat.random(in: -30...30)
    }
    
    private func randomY() -> CGFloat {
        isPositive ? CGFloat.random(in: -80...(-40)) : CGFloat.random(in: 40...80)
    }
}

struct Particle: View {
    let isPositive: Bool
    
    var body: some View {
        Circle()
            .fill(
                isPositive ?
                Color.green.opacity(0.6) :
                Color.red.opacity(0.4)
            )
            .frame(width: 6, height: 6)
            .blur(radius: 1)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ParticleEffect(isPositive: true)
    }
}
