//
//  MapListView.swift
//  trareco WatchKit Extension
//
//  Created by shou on 2021/08/15.
//

import SwiftUI

struct MapListView: View {
    @State var maps: [[String: Any]] = []
    @ObservedObject var mapViewModel = MapViewModel()
    
    var body: some View {
        List {
            NavigationLink(destination: LoggerView(id: 0, name: "new")) {
                Text("start new logging")
            }.listRowPlatterColor(Color.green)
            ForEach(0 ..< maps.count, id: \.self) { index in
                NavigationLink(
                    destination: LoggerView(id: maps[index]["id"] as! Int, name: maps[index]["name"] as! String )) {
                    Text(maps[index]["name"] as! String)
                }
            }
        }
        .onAppear{
            self.mapViewModel.get() {maps in self.maps = maps as! [[String : Any]]}
        }
    }
}

struct MapListView_Previews: PreviewProvider {
    static var previews: some View {
        MapListView()
    }
}
