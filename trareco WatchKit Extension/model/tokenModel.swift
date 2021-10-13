//
//  tokenModel.swift
//  trareco WatchKit Extension
//
//  Created by shou on 2021/08/15.
//

import Foundation

final class TokenModel: ObservableObject {
    func post(token: String, completion: @escaping (String?) -> Void) {
        let url = "http://localhost:4000/api/sign_in"
        var params = Dictionary<String, String>()
        var request = URLRequest(url: URL(string: url)!)
        params["token"] = token
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.dataTask(with: request)
        { (data: Data?, response: URLResponse?, error: Error?) in
            guard let _ = data, let response = response as? HTTPURLResponse else {
                print("No data or No response.")
                DispatchQueue.main.async { completion("auth error")}
                return
            }
            if response.statusCode == 200 {
                if let data = data {
                    do {
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            DispatchQueue.main.async { completion("authenticated") }
                            UserDefaults.standard.set(responseJSON["token"], forKey: "token")
                        }
                    }
                }
            } else {
                print("Status Code: " + String(response.statusCode))
                DispatchQueue.main.async { completion("auth error")}
            }
        }
        task.resume()
    }
    
    func refresh() {
        // need implement refresh_token api
        let url = "http://localhost:4000/api/users/refresh_token"
        let jwt = UserDefaults.standard.string(forKey: "token") ?? ""
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")

        
        let task = URLSession.shared.dataTask(with: request)
        { (data: Data?, response: URLResponse?, error: Error?) in
            guard let _ = data, let response = response as? HTTPURLResponse else {
                print("No data or No response.")
                return
            }
            if response.statusCode == 200 {
                if let data = data {
                    do {
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            UserDefaults.standard.set(responseJSON["token"], forKey: "token")
                        }
                    }
                }
            } else {
                print("Status Code: " + String(response.statusCode))
            }
        }
        task.resume()
    }
}
