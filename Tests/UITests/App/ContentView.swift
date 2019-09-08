//
//  ContentView.swift
//  App
//
//  Created by Koji Murata on 2019/09/09.
//

import SwiftUI
import Macduff

struct ContentView: View {
    @State private var provider: Provider?
    
    private func goNextStep() {
        if !TestStep.goNext() { return }
        switch TestStep.current {
        case .initial:             provider = nil
        case .creatingProvider:    provider = Provider()
        case .progressingProvider: provider?.progress?(0.5)
        case .success:             provider?.success?(ProvidingImage(image: image, originalData: nil))
        case .removingProvider:    provider = nil
        case .recreatingProvider:  provider = Provider()
        }
    }
    
    private let image = #imageLiteral(resourceName: "Lena")
    
    enum TestStep: Int {
        static var current = TestStep.initial
        static func goNext() -> Bool {
            guard let next = TestStep(rawValue: current.rawValue + 1) else { return false }
            current = next
            return true
        }
        
        case initial
        case creatingProvider
        case progressingProvider
        case success
        case removingProvider
        case recreatingProvider
    }
    
    var body: some View {
        VStack {
            Button(action: { self.goNextStep() }, label: { Text("Next") })
            RemoteImage(
                with: provider,
                loadingPlaceHolder: { ProgressView(progress: $0) },
                errorPlaceHolder: { ErrorView(error: $0) }
            ).frame(width: 100, height: 100, alignment: .center)
        }
    }
}

private final class Provider: ImageProvider {
    var cacheKey: String { "dummy" }
    
    var progress: ((Float) -> Void)?
    var success: ((ProvidingImage) -> Void)?
    var failure: ((Error) -> Void)?
    
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {
        self.progress = progress
        self.success = success
        self.failure = failure
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
