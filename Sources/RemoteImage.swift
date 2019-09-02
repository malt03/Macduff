//
//  RemoteImage.swift
//  RemoteImage
//
//  Created by Koji Murata on 2019/09/02.
//

import SwiftUI

struct RemoteImage {
    private var imageProvider: ImageProvider? = nil
    
    init(url: URL) {
        imageProvider = RemoteURLImageProvider(url: url)
    }
}

//extension RemoteImage: View {
//    var body: some View {
//        
//    }
//    
//    func onAppear(perform action: (() -> Void)? = nil) -> some View
//    {
//        imageProvider?.provide(progress: <#T##(Float) -> Void#>, success: <#T##(NativeImage) -> Void#>, failure: <#T##(Error) -> Void#>)
//        action?()
//        return self
//    }
//}
