//
//  RemoteImageInitializersView.swift
//  Example-iOS
//
//  Created by Koji Murata on 2019/09/06.
//  Copyright © 2019 Koji Murata. All rights reserved.
//

import SwiftUI
import Macduff

struct RemoteImageInitializersView: View {
    var body: some View {
        List {
            RemoteImage(with: SlowLena()).frame(width: 50, height: 50, alignment: .center)
            RemoteImage(with: SlowLena(), placeHolder: { ActivityIndicator() }).frame(width: 50, height: 50, alignment: .center)
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {}
}

struct RemoteImageInitializersView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageInitializersView()
    }
}
