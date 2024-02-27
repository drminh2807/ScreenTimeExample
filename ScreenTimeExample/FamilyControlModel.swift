//
//  FamilyControlModel.swift
//  screen_time_api_ios
//
//  Created by Kei Fujikawa on 2023/10/11.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings
import NotificationCenter

class FamilyControlModel: ObservableObject {
    static let shared = FamilyControlModel()

    private init() {
        selectionToDiscourage = savedSelection ?? FamilyActivitySelection()
    }

    private let store = ManagedSettingsStore()
    private let userDefaultName = "group.com.drminh.ScreenTimeExample"
    private let userDefaultsKey = "ScreenTimeSelection"
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()

    var selectionToDiscourage = FamilyActivitySelection() {
        willSet {
            self.saveSelection(selection: newValue)
        }
    }

    func authorize() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    func encourageAll() {
        store.shield.applications = []
        store.shield.applicationCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(
                []
            )
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(
                []
            )
    }
    
    func restrict() {
        guard let savedSelection else { return }
        print ("got here \(savedSelection)")

        let applications = savedSelection.applicationTokens
        let categories = savedSelection.categoryTokens

        print ("applications \(applications)")
        print ("categories \(categories)")

        store.shield.applications = applications.isEmpty ? nil : applications

        store.shield.applicationCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(
                categories
            )
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(
                categories
            )
    }
    
    func schedulingRestrictions() {
        guard let savedSelection else { return }
        let center = DeviceActivityCenter()

        // Stops existing monitoring. You may or may not need this
        // depend on exactly what you're doing.

        center.stopMonitoring()

        let activity = DeviceActivityName("MyApp.ScreenTime")
        let eventName = DeviceActivityEvent.Name(UUID().uuidString)
        let timeLimitMinutes = 5
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
            repeats: true
        )
        let event = DeviceActivityEvent(
            applications: savedSelection.applicationTokens,
            categories: savedSelection.categoryTokens,
            webDomains: savedSelection.webDomainTokens,
            threshold: .init(minute: timeLimitMinutes)
        )
        
        do {
            try center.startMonitoring(
                activity,
                during: schedule,
                events: [
                    eventName: event
                ]
            )
        } catch {
            print(error)
        }
    }

    func saveSelection(selection: FamilyActivitySelection) {
        let defaults = UserDefaults(suiteName: userDefaultName)
        defaults?.set(
            try? encoder.encode(selection),
            forKey: userDefaultsKey
        )
    }
    
    var savedSelection: FamilyActivitySelection? {
        let defaults = UserDefaults(suiteName: userDefaultName)

        guard let data = defaults?.data(forKey: userDefaultsKey) else {
            return nil
        }

        return try? decoder.decode(
            FamilyActivitySelection.self,
            from: data
        )
    }
    
    func showLocalNotification(title: String) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let error {
                print(error)
            }
        }
    }
}
