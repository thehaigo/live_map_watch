//
//  trarecoApp.swift
//  trareco WatchKit Extension
//
//  Created by shou on 2021/08/15.
//

import SwiftUI

@main
struct trarecoApp: App {
    @ObservedObject var tokenModel = TokenModel()
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
    
    init() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        if (token != "") { tokenModel.refresh() }
        let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
        if (uuid == "") {UserDefaults.standard.set(NSUUID().uuidString, forKey: "uuid")}
    }
}
