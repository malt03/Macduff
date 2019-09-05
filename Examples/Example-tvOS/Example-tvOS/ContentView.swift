//
//  ContentView.swift
//  Example
//
//  Created by Koji Murata on 2019/09/03.
//

import SwiftUI
import Macduff

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ImagesView()) { Text("Show Images") }
            }.navigationBarTitle("Macduff")
        }
    }
}

struct ImagesView: View {
    @State private var randomImages = (0..<50).map { RandomImageModel(id: $0) }
    
    var body: some View {
        List(randomImages) { (image) in
            HStack {
                RemoteImage(source: image.url, loadingPlaceHolder: { (progress) -> ProgressView in
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
        }.navigationBarTitle("Images")
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

struct RandomImageModel: Identifiable {
    let id: Int
    var url: URL { return URL(string: "https://picsum.photos/200/100?random=\(id)")! }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
