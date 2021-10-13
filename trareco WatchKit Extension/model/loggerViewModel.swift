//
//  loggerViewModel.swift
//  trareco WatchKit Extension
//
//  Created by shou on 2021/08/15.
//

import Foundation
import Combine
import CoreLocation

class LoggerViewModel: NSObject, ObservableObject{
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var manager = CLLocationManager()
    private var mapId: Int = 0
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.allowsBackgroundLocationUpdates = true
        self.manager.distanceFilter = 100
    }
    
    func post() {
        let url = "http://localhost:4000/api/points"
        let jwt = UserDefaults.standard.string(forKey: "token") ?? ""
        let uuid = UserDefaults.standard.string(forKey: "uuid") ?? ""
        var request = URLRequest(url: URL(string: url)!)
        var params = Dictionary<String, Any>()
        params["lat"] = userLatitude
        params["lng"] = userLongitude
        params["map_id"] = mapId

        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        request.addValue(uuid, forHTTPHeaderField: "UUID")
        
        let task = URLSession.shared.dataTask(with: request){
            (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("no data or no response")
                return
            }
            
            if response.statusCode == 200 {
                print(data)
            } else {
                print("intenal server error: \(response.statusCode)\n")
                if (response.statusCode == 401) { UserDefaults.standard.set("", forKey: "token") }
            }
        }
        task.resume()
    }
    
    func startLogger() {
        let url = "http://localhost:4000/api/maps"
        let jwt = UserDefaults.standard.string(forKey: "token") ?? ""
        var request = URLRequest(url: URL(string: url)!)
        var params = Dictionary<String, Any>()
        params["name"] = "map \(UserDefaults.standard.integer(forKey: "count"))"

        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data: Optional?, response: URLResponse?, error: Error?) in
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("no data or no response")
                return
            }
            if response.statusCode == 200 {
                if let data = data {
                    do {
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            UserDefaults.standard.set(responseJSON["id"], forKey: "mapId")
                        }
                    }
                }
            } else {
                print("intenal server error: \(response.statusCode)\n")
                if (response.statusCode == 401) { UserDefaults.standard.set("", forKey: "token") }
            }
        }
        task.resume()
    }
}

extension LoggerViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        mapId = UserDefaults.standard.integer(forKey: "mapId")
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        post()
    }
}
