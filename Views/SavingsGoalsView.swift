//
//  SavingsGoalsView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData

struct SavingsGoalsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var goals: [SavingsGoal]
    
    @State private var showingAddGoal = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.11, green: 0.11, blue: 0.12)
                    .ignoresSafeArea()
                
                if goals.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "target")
                            .font(.system(size: 60))
                            .foregroundStyle(.white.opacity(0.3))
                        
                        Text("No Savings Goals")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.6))
                        
                        Text("Set a goal to start saving!")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.4))
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(goals) { goal in
                                GoalCard(goal: goal)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            deleteGoal(goal)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Savings Goals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
            }
        }
    }
    
    private func deleteGoal(_ goal: SavingsGoal) {
        HapticManager.shared.deleteHaptic()
        modelContext.delete(goal)
        try? modelContext.save()
    }
}

struct GoalCard: View {
    let goal: SavingsGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: goal.iconName)
                    .font(.title2)
                    .foregroundStyle(Color.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    if let deadline = goal.deadline {
                        Text("Due: \(deadline.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.green)
                        .font(.title2)
                }
            }
            
            // Progress
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("$\(Int(goal.currentAmount))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.green)
                    
                    Text("/ $\(Int(goal.targetAmount))")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: geometry.size.width * goal.progressPercentage, height: 8)
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)
                
                Text("\(Int(goal.progressPercentage * 100))% complete")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.16))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
        )
    }
}

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var targetAmount = ""
    @State private var selectedIcon = "dollarsign.circle.fill"
    @State private var hasDeadline = false
    @State private var deadline = Date()
    
    private let icons = [
        "dollarsign.circle.fill",
        "car.fill",
        "house.fill",
        "airplane",
        "cart.fill",
        "gift.fill",
        "briefcase.fill",
        "graduationcap.fill"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    TextField("Goal Name", text: $name)
                    
                    HStack {
                        Text("$")
                        TextField("Target Amount", text: $targetAmount)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section("Icon") {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(icons, id: \.self) { icon in
                            Button(action: { selectedIcon = icon }) {
                                Image(systemName: icon)
                                    .font(.title)
                                    .foregroundStyle(selectedIcon == icon ? Color.green : Color.gray)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        Circle()
                                            .fill(selectedIcon == icon ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                                    )
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Toggle("Set Deadline", isOn: $hasDeadline)
                    
                    if hasDeadline {
                        DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveGoal()
                    }
                    .disabled(name.isEmpty || targetAmount.isEmpty)
                }
            }
        }
    }
    
    private func saveGoal() {
        guard let amount = Double(targetAmount), amount > 0 else { return }
        
        let goal = SavingsGoal(
            name: name,
            targetAmount: amount,
            deadline: hasDeadline ? deadline : nil,
            iconName: selectedIcon
        )
        
        modelContext.insert(goal)
        try? modelContext.save()
        
        HapticManager.shared.successHaptic()
        dismiss()
    }
}

#Preview {
    SavingsGoalsView()
        .modelContainer(for: SavingsGoal.self, inMemory: true)
}
