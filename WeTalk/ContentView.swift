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
            ChatListView()
                .tabItem {
                    Image(selection == 0 ? "bottom_bar_chat_filled" : "bottom_bar_chat")
                    Text("微信")
                }
                .tag(0)
            
            ContactsView()
                .tabItem {
                    Image(selection == 1 ? "bottom_bar_contacts_filled" : "bottom_bar_contacts")
                    Text("通讯录")
                }
                .tag(1)
            
            ChatListView()
                .tabItem {
                    Image(selection == 2 ? "bottom_bar_discover_filled" : "bottom_bar_discover")
                    Text("发现")
                }
                .tag(2)
            
            ChatListView()
                .tabItem {
                    Image(selection == 3 ? "bottom_bar_me_filled" : "bottom_bar_me")
                    Text("我")
                }
                .tag(3)
        }
        .tint(.brand100)
    }
}

#Preview {
    ContentView()
}
