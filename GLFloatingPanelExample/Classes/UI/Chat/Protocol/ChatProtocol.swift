//
//  TabBarScrollingProtocol.swift
//  GLFloatingPanelExample
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit

protocol ChatProtocol: class {
    
    func chatDidScroll(scrollView: UIScrollView)
    
    func chatMessageDidTouched()
}
