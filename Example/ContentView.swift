//
//  ContentView.swift
//  Example
//
//  Created by Koji Murata on 2019/09/03.
//

import SwiftUI
import RemoteImage

struct ContentView: View {
    @State private var randomImages = (0..<10).map { RandomImageModel(id: $0) }
    
    var body: some View {
        List(randomImages) { (image) in
            RemoteImage(source: image.url, loadingPlaceHolder: { _ in
                Spacer()
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.blue)
            }, errorPlaceHolder: { _ in
                Spacer()
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.red)
            })
        }
    }
}

struct RandomImageModel: Identifiable {
    let id: Int
    
    var url: URL { return URL(string: "https://picsum.photos/100/100?random=\(id)")! }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
