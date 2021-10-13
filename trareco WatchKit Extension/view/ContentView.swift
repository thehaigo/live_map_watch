//
//  ContentView.swift
//  trareco WatchKit Extension
//
//  Created by shou on 2021/08/15.
//

import SwiftUI

struct ContentView: View {
    @State private var token: String = ""
    @State private var jwt: String = ""
    @ObservedObject var tokenModel = TokenModel()
    
    
    func input(i: Int) {
        if(token == "auth error") { self.token = "" }
        self.token = token + String(i)
    }
    func del() {
        self.token = String(token.dropLast())
    }
    var body: some View {
        VStack {
            if(jwt != "" || token == "authenticated") {
                MapListView()
            } else {
                Text(self.token.count == 0 ? "input token" : self.token)
                HStack{
                    Button("1", action: {input(i: 1)}).scaleEffect(0.7)
                    Button("2", action: {input(i: 2)}).scaleEffect(0.7)
                    Button("3", action: {input(i: 3)}).scaleEffect(0.7)
                }.frame(height: 30)
                HStack{
                    Button("4", action: {input(i: 4)}).scaleEffect(0.7)
                    Button("5", action: {input(i: 5)}).scaleEffect(0.7)
                    Button("6", action: {input(i: 6)}).scaleEffect(0.7)
                }.frame(height: 30)
                HStack{
                    Button("7", action: {input(i: 7)}).scaleEffect(0.7)
                    Button("8", action: {input(i: 8)}).scaleEffect(0.7)
                    Button("9", action: {input(i: 9)}).scaleEffect(0.7)
                }.frame(height: 30)
                HStack{
                    Button("del", action: del ).scaleEffect(0.7)
                    Button("0", action: {input(i: 0)}).scaleEffect(0.7)
                    Button(action: {
                        self.tokenModel.post(token: self.token) {message in self.token = message!}
                    }){
                        Text("go")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(29)
                    }.scaleEffect(0.7)
                }.frame(height: 30)

            }
        }
        .onAppear{
            self.jwt = UserDefaults.standard.string(forKey: "token") ?? ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
