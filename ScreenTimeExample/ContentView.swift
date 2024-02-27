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
    
    var body: some View {
        VStack {
            Button(action: requestPermission, label: { Text("Request Permission") })
            Button("Family Activity Picker") { isPresented = true }
                .familyActivityPicker(
                    isPresented: $isPresented,
                    selection: $model.selectionToDiscourage)
            Button("Schedule") {
                model.schedulingRestrictions()
            }
            Button("Unlock") {
                model.encourageAll()
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
