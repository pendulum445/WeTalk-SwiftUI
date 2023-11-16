//
//  NavigationBarView.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/11/13.
//

import SwiftUI

struct NavigationBarView: View {
    
    var title: String
    var leftButtonImageName: String?
    var firstRightButtonImageName: String?
    var secondRightButtonImageName: String?
    var leftButtonWidth: CGFloat?
    var onClickLeftButton: () -> Void = {}
    var onClickFirstRightButton: () -> Void = {}
    var onClickSecondRightButton: () -> Void = {}
    
    var body: some View {
        ZStack {
            Text(title)
                .font(
                    Font.custom("PingFang SC", size: 17)
                        .weight(.medium)
                )
            
            HStack {
                if leftButtonImageName != nil {
                    Button(action: onClickLeftButton) {
                        Image(leftButtonImageName!)
                    }
                    .frame(width: leftButtonWidth, height: 24)
                }
                
                Spacer()
                
                if firstRightButtonImageName != nil {
                    Button(action: onClickFirstRightButton) {
                        Image(firstRightButtonImageName!)
                    }
                    .frame(width: 24, height: 24)
                }
                
                Spacer().frame(width: 16)
                
                if secondRightButtonImageName != nil {
                    Button(action: onClickSecondRightButton) {
                        Image(secondRightButtonImageName!)
                    }
                    .frame(width: 24, height: 24)
                }
            }
            .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        }
    }
}
