//
//  ContentView.swift
//  ScreenTimeExample
//
//  Created by Doan Van Minh on 26/02/2024.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct ContentView: View {
    @StateObject var model = FamilyControlModel.shared
    @State var isPresented = false
    
    func requestPermission() {
        Task {
            try await FamilyControlModel.shared.authorize()
            let center = UNUserNotificationCenter.current()

            try await center.requestAuthorization(options: [.alert, .badge, .sound])
        }
    }
    
    func schedulingRestrictions() {
        let scheduleInSecond = 30
        print("Start monitor restriction, by", scheduleInSecond, "seconds")
//        
        //schedule device activity from now to n-second's
        guard let startSchedulingTime = Calendar.current.date(byAdding: .second, value: 60, to: Date()),
              let endSchedulingTime = Calendar.current.date(byAdding: .second, value: Int(scheduleInSecond), to: Date()) else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
//        print("Scheduling monitor started on ",dateFormatter.string(from: startSchedulingTime))
        print("Scheduling monitor will end on ",dateFormatter.string(from: endSchedulingTime))
//        let schedule = DeviceActivitySchedule(
//            intervalStart: Calendar.current.dateComponents([.hour, .minute], from: startSchedulingTime),
//            intervalEnd: Calendar.current.dateComponents([.hour, .minute], from: endSchedulingTime),
//            repeats: false,
//            warningTime: nil)
        guard let endSchedulingTime = Calendar.current.date(byAdding: .second, value: 30, to: Date()) else { return }
        
        let schedule = DeviceActivitySchedule(
            intervalStart: .init(hour: 1, minute: 1),
            intervalEnd: Calendar.current.dateComponents([.hour, .minute], from: endSchedulingTime),
            repeats: true,
            warningTime: nil)

        let center = DeviceActivityCenter()
        
        do {
            center.stopMonitoring()
            try center.startMonitoring(.restrictAppActivityName, during: schedule)
            print("Success Scheduling Monitor Activity")
        }
        catch {
            print("Error Scheduling Monitor Activity: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            Button(action: requestPermission, label: { Text("Request Permission") })
            Button("Family Activity Picker") { isPresented = true }
                .familyActivityPicker(
                    isPresented: $isPresented,
                    selection: $model.selectionToDiscourage)
            Button("Unlock") {
                schedulingRestrictions()
            }
        }
        .padding()
    }
}

extension DeviceActivityName {
    static let restrictAppActivityName = Self("restrictApp")
}

#Preview {
    ContentView()
}
