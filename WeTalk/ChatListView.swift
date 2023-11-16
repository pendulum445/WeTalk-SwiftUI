//
//  ChatListView.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/11/13.
//

import Alamofire
import URLImage
import SwiftUI

func getLastChatTimeText(lastChatTime: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yy-MM-dd HH:mm:ss"
    if let date = dateFormatter.date(from: lastChatTime) {
        let calendar = Calendar.current
        let now = Date()
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "昨天"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            dateFormatter.dateFormat = "E"
            return dateFormatter.string(from: date)
        } else {
            if calendar.isDate(date, equalTo: now, toGranularity: .year) {
                dateFormatter.dateFormat = "MM月dd日"
            } else {
                dateFormatter.dateFormat = "y年MM月dd日"
            }
            return dateFormatter.string(from: date)
        }
    } else {
        return "Invalid Date"
    }
}

func getUnreadCountText(unreadCount: Int) -> String {
    if unreadCount > 99 {
        return "99+"
    } else {
        return String("\(unreadCount)")
    }
}

struct ChatListView: View {
    
    @ObservedObject var viewModel = ChatListViewModel()
    
    init() {
        self.viewModel.requestData()
    }
    
    var body: some View {
        VStack {
            NavigationBarView(title: "微信", firstRightButtonImageName: "nav_bar_search", secondRightButtonImageName: "nav_bar_add")
                .background(.BW_BG_93)
            
            NavigationView {
                if self.viewModel.models.count > 0 {
                    List(self.viewModel.models) { model in
                        ZStack {
                            ChatCell(model: model)
                            
                            NavigationLink(
                                destination: ChatDetailView().navigationBarHidden(true),
                                label: { EmptyView() }
                            ).opacity(0)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .background(.white)
                    .listStyle(PlainListStyle())
                }
            }
            
            Spacer()
        }
    }
}

struct ChatCell: View {
    
    var model: ChatCellModel
    @State var hasRead: Bool = false
    
    var body: some View {
        HStack {
            ZStack {
                URLImage(URL(string: self.model.friendInfo.avatarUrl ?? "error")!) { error, retry in
                    Image("default_avatar")
                } content: { image, info in
                    image
                }
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                
                if self.model.unreadCount > 0 && !hasRead {
                    Text(getUnreadCountText(unreadCount: self.model.unreadCount))
                        .frame(minWidth: 18)
                        .frame(height: 18)
                        .background(.red100)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                        .font(Font.custom("PingFang SC", size: 12).weight(.light))
                        .foregroundColor(.white)
                        .offset(x: 22, y: -20)
                }
            }
            
            Spacer()
                .frame(width: 12)
            
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(self.model.friendInfo.displayName())
                            .font(Font.custom("PingFang SC", size: 17))
                            .foregroundColor(.black.opacity(0.9))
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(getLastChatTimeText(lastChatTime: self.model.friendInfo.messages[self.model.friendInfo.messages.count-1].chatTime))
                            .font(Font.custom("PingFang SC", size: 12))
                            .foregroundColor(.black.opacity(0.3))
                            .lineLimit(1)
                    }
                    
                    Text(self.model.friendInfo.messages[self.model.friendInfo.messages.count-1].text)
                        .font(Font.custom("PingFang SC", size: 14))
                        .foregroundColor(.black.opacity(0.3))
                        .lineLimit(1)
                }
                
                Color.black
                    .opacity(0.1)
                    .frame(height: 0.5)
                    .offset(y: 34)
            }
        }
        .onTapGesture {
            self.hasRead = true
        }
    }
}

class ChatListViewModel: ObservableObject {
    @Published var models: [ChatCellModel] = []
    
    func requestData() {
        AF.request("https://mock.apifox.cn/m1/2415634-0-default/chatList?userId={% mock 'qq' %}").responseDecodable(of: ChatListResponse.self) { response in
            if case .success(let chatListResponse) = response.result {
                for item in chatListResponse.data {
                    self.models.append(item)
                }
            }
        }
    }
}

#Preview {
    ChatListView()
}
