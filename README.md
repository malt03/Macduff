# Macduff

I used [Kingfisher](https://github.com/onevcat/Kingfisher) as reference. Great thanks to onevcat !

[![Build Status](https://travis-ci.org/malt03/Macduff.svg?branch=master)](https://travis-ci.org/malt03/Macduff)
[![Coverage Status](https://coveralls.io/repos/github/malt03/Macduff/badge.svg?branch=master)](https://coveralls.io/github/malt03/Macduff?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![License](https://img.shields.io/github/license/malt03/Macduff.svg)

Macduff is a library for downloading, caching and displaying images on SwiftUI.  
You can create ProgressView or ErrorView, and customize ImageView.  

## Usage

```swift
struct ContentView: View {
    @State var imageURL = URL(string: "http://example.com/image")
    var body: some View {
      RemoteImage(with: imageURL)
    }
}
```

This is all you need to do!  
Of course, if the imageURL is updated, the displayed image will also be updated.

## Requirements
- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Xcode 11.0+

## Installation

### [Carthage](https://github.com/Carthage/Carthage)

- Insert `github "malt03/Macduff"` to your Cartfile.
- Run `carthage update`.
- Link your app with `Macduff.framework` in `Carthage/Build`.

### [CocoaPods](https://github.com/cocoapods/cocoapods)

- Insert `pod 'Macduff'` to your Podfile.
- Run `pod install`.

## Advanced Example
- Set cornerRadius and frame on RemoteImage.
- Custom placeholders for downloading and errors.
- Custom view for displaying image.
- Blur downloaded image.
- Print log when the task finished.

```swift
struct ContentView: View {
    @State var imageURL = URL(string: "http://example.com/image")
    var body: some View {
        RemoteImage(
            with: imageURL,
            imageView: { Image(uiImage: $0).resizable().rotationEffect(.degrees(180)) },
            loadingPlaceHolder: { ProgressView(progress: $0) },
            errorPlaceHolder: { ErrorView(error: $0) },
            config: Config.init(transition: .scale, imageProcessor: GaussianBlurImageProcessor()),
            completion: { (status) in
                switch status {
                case .success(let image): print("success! imageSize:", image.size)
                case .failure(let error): print("failure... error:", error.localizedDescription)
                }
            }
        ).frame(width: 100, height: 100, alignment: .center).cornerRadius(50)
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
struct ErrorView: View {
    let error: Error
    var body: some View {
        ZStack {
            Rectangle().fill(Color.red)
            Text(error.localizedDescription).font(Font.system(size: 8))
        }
    }
}
```

