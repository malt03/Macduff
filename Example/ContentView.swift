//
//  ContentView.swift
//  Example
//
//  Created by Koji Murata on 2019/09/03.
//

import SwiftUI
import RemoteImage

struct ContentView: View {
    @State private var images = (0..<10).map { ImageModel(id: $0) }
    
    var body: some View {
        List(images) { (image) in
            RemoteImage(source: image.url, loadingPlaceHolder: { _ in
                Spacer()
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.blue)
            }, errorPlaceHolder: { (error) in
                Spacer()
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.red)
            })
        }
    }
}

struct ImageModel: Identifiable {
    let id: Int
    var url: URL { return URL(string: "https://picsum.photos/id/\(id)/100/100")! }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
