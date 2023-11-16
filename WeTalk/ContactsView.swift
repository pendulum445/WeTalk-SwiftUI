//
//  ContactsView.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/11/16.
//

import Alamofire
import SwiftUI
import URLImage

struct ContactsView: View {
    
    @ObservedObject var viewModel = ContanctsViewModel()
    
    init() {
        self.viewModel.requestData()
    }
    
    var body: some View {
        VStack {
            NavigationBarView(title: "通讯录", firstRightButtonImageName: "nav_bar_search", secondRightButtonImageName: "nav_bar_add")
                .background(.BW_BG_93)
            
            if self.viewModel.groupedFriendInfo.keys.count > 0 {
                List {
                    ForEach(self.viewModel.groupedFriendInfo.keys.sorted(), id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(self.viewModel.groupedFriendInfo[key]!, id: \.id) { friendInfo in
                                ContactCell(avatarUrl: friendInfo.avatarUrl ?? "error", title: friendInfo.displayName())
                            }
                        }
                    }
                }
                .background(.white)
                .listStyle(PlainListStyle())
            }
            
            Spacer()
        }
    }
}

struct ContactCell: View {
    var avatarUrl: String
    var title: String
    
    var body: some View {
        HStack {
            URLImage(URL(string: self.avatarUrl)!) { error, retry in
                Image("default_avatar")
            } content: { image, info in
                image
            }
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            Spacer()
                .frame(width: 8)
            
            ZStack(alignment: .leading) {
                Text(title)
                    .font(Font.custom("PingFang SC", size: 17))
                    .foregroundColor(.black.opacity(0.9))
                
                Color.black
                    .opacity(0.1)
                    .frame(height: 0.5)
                    .offset(y: 28)
            }
        }
        .listRowSeparator(.hidden)
    }
}

class ContanctsViewModel: ObservableObject {
    @Published var groupedFriendInfo: [String: [FriendInfo]] = [:]
    private var sectionLetters: [String] = []
    
    func requestData() {
        AF.request("https://mock.apifox.cn/m1/2415634-0-default/contacts?userId=<userId>").responseDecodable(of: FriendListResponse.self) { response in
            switch response.result {
            case .success(let friendListResponse):
                self.groupDataByFirstLetter(data: friendListResponse.data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func groupDataByFirstLetter(data: [FriendInfo]) {
        for it in data {
            var firstLetter = self.firstLetterOf(string: it.displayName())
            if !("A"..."Z").contains(firstLetter) {
                firstLetter = "#"
            }
            if self.groupedFriendInfo[firstLetter] == nil {
                self.groupedFriendInfo[firstLetter] = []
            }
            self.groupedFriendInfo[firstLetter]?.append(it)
        }
        for it in self.groupedFriendInfo.keys {
            self.sectionLetters.append(it)
        }
        self.sectionLetters.sort()
    }
    
    private func firstLetterOf(string: String) -> String {
        let mutableString = NSMutableString(string: string) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let convertedString = mutableString as String
        let firstCharacter = convertedString.prefix(1)
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z]", options: [])
        let isAlphabetic = regex.firstMatch(in: String(firstCharacter), options: [], range: NSRange(location: 0, length: firstCharacter.utf16.count)) != nil
        if !isAlphabetic {
            return "#"
        }
        return String(firstCharacter).uppercased()
    }
}

#Preview {
    ContactsView()
}
