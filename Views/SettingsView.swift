//
//  SettingsView.swift
//  Cashin'
//
//  Created on 2025-12-03.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]
    
    @State private var selectedColorScheme: Int = 0 // 0=system, 1=light, 2=dark
    @State private var soundEffectsEnabled: Bool = true
    @State private var biometricLockEnabled: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Appearance
                Section("Appearance") {
                    Picker("Theme", selection: $selectedColorScheme) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .onChange(of: selectedColorScheme) { _, newValue in
                        updateColorScheme(newValue)
                    }
                }
                
                // MARK: - Accessibility
                Section("Accessibility") {
                    Toggle("Sound Effects", isOn: $soundEffectsEnabled)
                        .onChange(of: soundEffectsEnabled) { _, newValue in
                            updateSoundEffects(newValue)
                        }
                }
                
                // MARK: - Security
                Section("Security") {
                    Toggle("Biometric Lock", isOn: $biometricLockEnabled)
                        .onChange(of: biometricLockEnabled) { _, newValue in
                            updateBiometricLock(newValue)
                        }
                    
                    if biometricLockEnabled {
                        Text("Use Face ID or Touch ID to unlock Cashin'")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // MARK: - About
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // MARK: - Data Management
                Section("Data") {
                    Button(role: .destructive) {
                        // TODO: Implement reset functionality in future update
                        // This will reset all transactions, summaries, and settings
                    } label: {
                        Text("Reset All Data")
                    }
                    .disabled(true) // Disabled until implementation complete
                    
                    Text("Data reset feature coming in future update")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadSettings()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadSettings() {
        guard let currentSettings = settings.first else {
            // Create default settings if none exist
            let newSettings = AppSettings()
            modelContext.insert(newSettings)
            try? modelContext.save()
            return
        }
        
        selectedColorScheme = currentSettings.preferredColorScheme ?? 0
        soundEffectsEnabled = currentSettings.soundEffectsEnabled
        biometricLockEnabled = currentSettings.biometricLockEnabled
    }
    
    private func updateColorScheme(_ value: Int) {
        guard let currentSettings = settings.first else { return }
        currentSettings.preferredColorScheme = value
        try? modelContext.save()
        HapticManager.shared.selectionHaptic()
    }
    
    private func updateSoundEffects(_ value: Bool) {
        guard let currentSettings = settings.first else { return }
        currentSettings.soundEffectsEnabled = value
        try? modelContext.save()
        HapticManager.shared.selectionHaptic()
    }
    
    private func updateBiometricLock(_ value: Bool) {
        guard let currentSettings = settings.first else { return }
        currentSettings.biometricLockEnabled = value
        try? modelContext.save()
        HapticManager.shared.selectionHaptic()
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: AppSettings.self, inMemory: true)
}
