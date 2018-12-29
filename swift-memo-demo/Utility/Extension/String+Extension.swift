//
//  String+Extension.swift
//  swift-memo-demo
//
//  Created on 2018/12/08.
//  Copyright © 2018 . All rights reserved.
//

import Foundation

extension String {
    
    /// Stringを行ごとの配列にして返すメソッド
    var lines: [String] {
        var lines = [String]()
        self.enumerateLines { (line, _) -> () in
            lines.append(line)
        }
        return lines
    }
}
