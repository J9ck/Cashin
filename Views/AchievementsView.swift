//
//  AchievementsView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var achievements: [Achievement]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(sortedAchievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
                .padding()
            }
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var sortedAchievements: [Achievement] {
        achievements.sorted { first, second in
            // Unlocked achievements first
            if first.isUnlocked != second.isUnlocked {
                return first.isUnlocked
            }
            // Then by progress
            if first.progress != second.progress {
                return first.progress > second.progress
            }
            // Then by category
            return first.category.rawValue < second.category.rawValue
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.iconName)
                    .font(.system(size: 28))
                    .foregroundStyle(achievement.isUnlocked ? Color.green : Color.gray)
            }
            
            // Title
            Text(achievement.title)
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Description
            Text(achievement.achievementDescription)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Progress bar (if not unlocked)
            if !achievement.isUnlocked && achievement.progress > 0 {
                VStack(spacing: 4) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 4)
                                .cornerRadius(2)
                            
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: geometry.size.width * achievement.progress, height: 4)
                                .cornerRadius(2)
                        }
                    }
                    .frame(height: 4)
                    
                    Text("\(Int(achievement.progress * 100))%")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
            
            // Earned date
            if let earnedDate = achievement.earnedDate {
                Text(earnedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

#Preview {
    AchievementsView()
        .modelContainer(for: Achievement.self, inMemory: true)
}
