//
//  mapViewModel.swift
//  trareco WatchKit Extension
//
//  Created by shou on 2021/08/15.
//

import Foundation

final class MapViewModel: ObservableObject {
    func get(completion: @escaping (Any?) -> Void) {
        let url = "http://localhost:4000/api/maps"
        
        let jwt = UserDefaults.standard.string(forKey: "token") ?? ""
        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "GET"
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request)
        {  (data: Data?, response: URLResponse?, error: Error?) in
            guard let _ = data, let response = response as? HTTPURLResponse else {
                print("No data or No response.")
                return
            }
            if response.statusCode == 200 {
                if let data = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                        let maps = responseJSON.map { (map) -> [String: Any] in return map as! [String: Any]}
                        UserDefaults.standard.set(maps.count, forKey: "count")
                        DispatchQueue.main.async { completion(maps) }
                    } catch let error {
                        print(error)
                    }
                }
            } else {
                print("Status Code: \(response.statusCode)")
                if (response.statusCode == 401) { UserDefaults.standard.set("", forKey: "token") }
                DispatchQueue.main.async { completion([]) }
            }
        }
        task.resume()
    }
}
