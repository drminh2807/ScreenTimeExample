//
//  DeviceActivityMonitorExtension.swift
//  DeviceMonitor
//
//  Created by Doan Van Minh on 26/02/2024.
//

import DeviceActivity
import Foundation

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        // Handle the start of the interval.
        FamilyControlModel.shared.encourageAll()
        FamilyControlModel.shared.showLocalNotification(title: "intervalDidStart")
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        print("intervalDidEnd")
        FamilyControlModel.shared.restrict()
        FamilyControlModel.shared.showLocalNotification(title: "intervalDidEnd")
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        // Handle the event reaching its threshold.
        FamilyControlModel.shared.restrict()
        FamilyControlModel.shared.showLocalNotification(title: "eventDidReachThreshold")
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        FamilyControlModel.shared.showLocalNotification(title: "intervalWillStartWarning")
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        FamilyControlModel.shared.showLocalNotification(title: "intervalWillEndWarning")
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
        FamilyControlModel.shared.showLocalNotification(title: "eventWillReachThresholdWarning")
    }
}
