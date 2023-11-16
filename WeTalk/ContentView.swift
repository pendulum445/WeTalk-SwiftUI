//
//  ContentView.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/11/13.
//

import SwiftUI

struct ContentView: View {

    @State private var selection = 0

    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor(named: "BW_BG_93")
    }
    
    var body: some View {
        TabView(selection: $selection) {
            let images = ["chat", "contacts", "discover", "me"]
            let tabs = ["微信", "通讯录", "发现", "我"]
            
            ForEach(0..<4) { index in
                ChatListView()
                    .tabItem {
                        Image(selection == index ? "bottom_bar_\(images[index])_filled" : "bottom_bar_\(images[index])")
                        
                        Text(tabs[index])
                    }
                    .tag(index)
            }
        }
        .tint(.brand100)
    }
}

#Preview {
    ContentView()
}
