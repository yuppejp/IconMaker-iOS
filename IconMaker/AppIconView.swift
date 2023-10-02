//
//  AppIconView.swift
//  IconMaker
//
//  Created by main on 2023/10/01.
//

import SwiftUI

struct AppIconView: View {
    var systemName: String  // SF Symbolsの名前
    var color: AnyGradient  // グラデーションカラー(iOS16〜)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(color)
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(geometry.size.width * 0.15) // 余白を多めにとる(全体の15%程度)
            }
            .offset(y: -2) // 上部の余白補正
        }
    }
}

#Preview {
    VStack {
        AppIconView(systemName: "square.and.pencil.circle", color: Color.red.gradient)
            .frame(width: 150, height: 150)
        AppIconView(systemName: "tram", color: Color.green.gradient)
            .frame(width: 150, height: 150)
        AppIconView(systemName: "sailboat.fill", color: Color.blue.gradient)
            .frame(width: 150, height: 150)
    }
}
