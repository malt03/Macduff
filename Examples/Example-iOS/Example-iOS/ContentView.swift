//
//  ContentView.swift
//  Example-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import SwiftUI
import Macduff

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ImagesView()) { Text("Random Images") }
                NavigationLink(destination: RemoteImageInitializersView()) { Text("All Initializers") }
            }.navigationBarTitle("Macduff")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
