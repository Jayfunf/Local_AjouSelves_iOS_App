//
//  settingView.swift
//  AjouSelves_iOS_App
//
//  Created by Minhyun Cho on 2022/03/29.
//

import SwiftUI
import Combine

var ver: String = "v0.1.3"

struct settingView: View {
    var body: some View {
        NavigationView{
            VStack {
                Button(action: {
                    print("\(UserDefaults.standard.string(forKey: "userToken"))")
                }, label: {
                    Image(systemName: "bell")
                })
                NavigationLink(
                    destination: {
                        Text("약관")
                    }, label: {
                        Text("약관")
                    })
                Text("버전: \(ver)")
            }
            .padding(-15)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    NavigationLink(
                        destination: Text("아직 알림이 없군요🔔"),
                        label: {
                            Image(systemName: "bell")
                        })
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        print("Clicked4")
                    }, label: {
                        Image("로고_PNG2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 170, height: 170, alignment: .leading)
                    })
                }
            }
        }
    }
}

struct settingView_Previews: PreviewProvider {
    static var previews: some View {
        settingView()
    }
}
