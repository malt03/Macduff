//
//  ProgressView.swift
//  Example-iOS
//
//  Created by Koji Murata on 2019/09/06.
//  Copyright © 2019 Koji Murata. All rights reserved.
//

import SwiftUI

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
