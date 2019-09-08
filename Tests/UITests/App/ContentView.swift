//
//  ContentView.swift
//  App
//
//  Created by Koji Murata on 2019/09/09.
//

import SwiftUI
import Macduff

struct ContentView: View {
    enum Errors: Error {
        case dummy
    }
    
    @State private var sources = [nil, nil, nil, nil] as [Source?]
    
    private func goNextStep() {
        TestStep.goNext()
        switch TestStep.current {
        case .initial:                 assertionFailure()
        case .creatingProvider:        sources = (0..<4).map { _ in Source(provider: Provider(cacheKey: "success")) }
        case .progressingProvider:     sources.forEach { $0?._provider.progress?(0.5) }
        case .success:                 sources.forEach { $0?._provider.success?(ProvidingImage(image: image, originalData: nil)) }
        case .removingProvider:        sources = (0..<4).map { _ in nil }
        case .recreatingProvider:      sources = (0..<4).map { _ in Source(provider: Provider(cacheKey: "success")) }
        case .creatingFailureProvider: sources = (0..<4).map { _ in Source(provider: Provider(cacheKey: "failure")) }
        case .failure:                 sources.forEach { $0?._provider.failure?(Errors.dummy) }
        }
    }
    
    private let image = #imageLiteral(resourceName: "Lena")
    
    enum TestStep: Int {
        static var current = TestStep.initial
        static func goNext() {
            current = TestStep(rawValue: current.rawValue + 1)!
        }
        
        case initial
        case creatingProvider
        case progressingProvider
        case success
        case removingProvider
        case recreatingProvider
        case creatingFailureProvider
        case failure
    }
    
    var body: some View {
        VStack {
            Button(action: { self.goNextStep() }, label: { Text("Next") })
            RemoteImage(with: sources[0], completion: { print($0) })
                .frame(width: 50, height: 50, alignment: .center)
            RemoteImage(with: sources[1], placeHolder: { PlaceHolder() })
                .frame(width: 50, height: 50, alignment: .center)
            RemoteImage(with: sources[2], loadingPlaceHolder: { ProgressView(progress: $0) }, errorPlaceHolder: { ErrorView(error: $0) })
                .frame(width: 50, height: 50, alignment: .center)
            RemoteImage(with: sources[3], imageView: { Image(uiImage: $0).resizable() }, loadingPlaceHolder: { ProgressView(progress: $0) }, errorPlaceHolder: { ErrorView(error: $0) })
                .frame(width: 50, height: 50, alignment: .center)
        }
    }
}

private final class Source: Macduff.Source {
    var provider: ImageProvider { _provider }
    let _provider: Provider
    
    init(provider: Provider) {
        _provider = provider
    }
}

private final class Provider: ImageProvider {
    let cacheKey: String
    
    init(cacheKey: String) {
        self.cacheKey = cacheKey
    }
    
    var progress: ((Float) -> Void)?
    var success: ((ProvidingImage) -> Void)?
    var failure: ((Error) -> Void)?
    
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {
        self.progress = progress
        self.success = success
        self.failure = failure
    }
}

struct PlaceHolder: View {
    var body: some View {
        Text("PlaceHolder")
    }
}

struct ProgressView: View {
    let progress: Float
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.green)
            Text(String(progress))
        }
    }
}

struct ErrorView: View {
    let error: Error
    var body: some View {
        ZStack {
            Rectangle().fill(Color.red)
            Text(error.localizedDescription)
        }

    }
}
