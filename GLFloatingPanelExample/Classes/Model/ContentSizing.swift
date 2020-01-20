//
//  ContentSizing.swift
//  GLFloatingPanelExample
//
//  Created by Alexey Gross on 11/09/2019.
//

import UIKit

struct ContentSizing {
    
    static let contentViewHeight: CGFloat = UIScreen.main.bounds.height - messagePanelHeight
    static let minContentViewOriginY: CGFloat = UIScreen.main.bounds.height / 5
    static let messagePanelHeight: CGFloat = 64.0
}
