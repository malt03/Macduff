//
//  ImagesView.swift
//  Example-iOS
//
//  Created by Koji Murata on 2019/09/06.
//  Copyright © 2019 Koji Murata. All rights reserved.
//

import SwiftUI
import Macduff

struct ImagesView: View {
    @State private var randomImages = (0..<50).map { RandomImageModel(id: $0) }
    
    var body: some View {
        List(randomImages) { (image) in
            HStack {
                RemoteImage(with: image.url, loadingPlaceHolder: { (progress) -> ProgressView in
                    return ProgressView(progress: progress)
                }, errorPlaceHolder: { _ in
                    Rectangle().fill(Color.red)
                })
                    .scaledToFill()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipped()
                    .cornerRadius(4)
                Text(image.url.absoluteString).font(Font.system(.subheadline))
            }
        }.navigationBarTitle("Images", displayMode: .inline)
    }
}

struct ProgressView: View {
    let progress: Float
    
    var body: some View {
        return GeometryReader { (geometry) in
            ZStack(alignment: .bottom) {
                Rectangle().fill(Color.gray)
                Rectangle().fill(Color.green)
                    .frame(width: nil, height: geometry.frame(in: .global).height * CGFloat(self.progress), alignment: .bottom)
            }
        }
    }
}

fileprivate struct RandomImageModel: Identifiable {
    let id: Int
    var url: URL { return URL(string: "https://picsum.photos/200/100?random=\(id)")! }
}
