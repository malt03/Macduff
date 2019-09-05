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
    init() {
        Config.default = Config(cacheTTL: 10)
    }
    
    var body: some View {
        List {
            RemoteImage(with: SlowLena(id: 1))
                .frame(width: 50, height: 50, alignment: .center)
            RemoteImage(with: SlowLena(id: 2), placeHolder: { ActivityIndicator() })
                .frame(width: 50, height: 50, alignment: .center)
            RemoteImage(with: SlowLena(id: 3), loadingPlaceHolder: { ProgressView(progress: $0) }, errorPlaceHolder: { _ in EmptyView() })
                .frame(width: 50, height: 50, alignment: .center)
            RemoteImage(with: SlowLena(id: 4), imageView: { RotateImage(image: $0) }, loadingPlaceHolder: { ProgressView(progress: $0) }, errorPlaceHolder: { _ in EmptyView() })
                .frame(width: 50, height: 50, alignment: .center)
            RemoteImage(with: ErrorProvider(), loadingPlaceHolder: { ProgressView(progress: $0) }, errorPlaceHolder: { ErrorView(error: $0) })
                .frame(width: 50, height: 50, alignment: .center)
        }
    }
}

struct RotateImage: View {
    @State var spin = false
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .rotationEffect(.degrees(180))
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

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.red)
            Text(error.localizedDescription).font(Font.system(size: 8))
        }
    }
}

struct ErrorProvider: ImageProvider {
    enum Errors: Error {
        case foo
    }
    
    let cacheKey = ""
    
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {
        for i in 0..<10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(i) / 10) {
                progress(Float(i) / 10)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            failure(Errors.foo)
        }
    }
}

struct RemoteImageInitializersView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageInitializersView()
    }
}
