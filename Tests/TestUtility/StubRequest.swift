//
//  StubRequest.swift
//  MacduffTests-iOS
//
//  Created by Koji Murata on 2019/09/07.
//

import Nocilla
import XCTest

extension XCTestCase {
    func stubRequest(for url: URL, data: Data, withSize: Bool) {
        let dsl = Nocilla.stubRequest("GET", url.absoluteString as NSString)
            .andReturn(200)?
            .withBody(data as NSData)
        if withSize {
            _ = dsl?.withHeader("Content-Length", "\(data.count)")
        }
        
    }
    
    func stubRequestError(for url: URL, code: Int) {
        _ = Nocilla.stubRequest("GET", url.absoluteString as NSString)
            .andFailWithError(NSError(domain: "com.malt03.stub", code: code, userInfo: nil))
    }
}
