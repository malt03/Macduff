//
//  ContentView.swift
//  Example
//
//  Created by Koji Murata on 2019/09/03.
//

import SwiftUI
import RemoteImage

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ImagesView()) { Text("Show Images") }
            }.navigationBarTitle("RemoteImage")
        }
    }
}

struct ImagesView: View {
    @State private var randomImages = (0..<50).map { RandomImageModel(id: $0) }
    
    var body: some View {
        List(randomImages) { (image) in
            RemoteImage(source: image.url, loadingPlaceHolder: { _ in
                Rectangle().fill(Color.blue)
            }, errorPlaceHolder: { _ in
                Rectangle().fill(Color.red)
            }, fetchTrigger: .initialize).scaledToFit().frame(width: 50, height: 50, alignment: .center)
        }.navigationBarTitle("Images", displayMode: .inline)
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
