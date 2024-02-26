//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by Doan Van Minh on 26/02/2024.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        ShieldConfiguration(
            title: .init(text: "It's time for learning English", color: .white),
            primaryButtonLabel: .init(text: "Unlock", color: .white)
        )
    }
}
