//
//  Print.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//

import Foundation

func prints(_ item: @autoclosure () -> Any, separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(item(), separator: separator, terminator: terminator)
    #endif
}
