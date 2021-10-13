//
//  LoggerView.swift
//  trareco WatchKit Extension
//
//  Created by shou on 2021/08/15.
//

import SwiftUI

struct LoggerView: View, Identifiable {
    @State private var recoding: Bool = false
    @State private var pause: Bool = true
    @ObservedObject var loggerViewModel = LoggerViewModel()
    var id: Int
    let name: String
    func recordStart() {
        loggerViewModel.manager.startUpdatingLocation()
        self.pause = false
    }
    
    func recordPause() {
        loggerViewModel.manager.stopUpdatingLocation()
        self.pause = true
    }
    
    var body: some View {
        VStack {
            Text(name)
            VStack {
                if(pause) {
                    Button(action: { recordStart() }) {
                        Image(systemName: "play")
                    }.background(Color.green).cornerRadius(30)
                } else {
                    Button(action: { recordPause() }) {
                        Image(systemName: "pause")
                    }
                }
            }
            VStack {
                Text("lat: \(loggerViewModel.userLatitude)")
                Text("lng: \(loggerViewModel.userLongitude)")
            }
        }
        .onAppear{
            if(id == 0 && name == "new") {
                loggerViewModel.startLogger()
            } else {
                UserDefaults.standard.set(id, forKey: "mapId")
            }
        }
    }
}

struct LoggerView_Previews: PreviewProvider {
    static var previews: some View {
        LoggerView(id: 0, name: "new")
    }
}
