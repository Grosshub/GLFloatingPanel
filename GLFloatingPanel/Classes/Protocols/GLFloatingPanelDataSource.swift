//
//  GLFloatingPanelDataSource.swift
//  GLFloatingPanel
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit

/// The methods adopted by the object you use to manage UI components on the Floating Panel
public protocol GLFloatingPanelDataSource: class {
    
    /// Customize the content controller view here
    /// The view from this view controller will be used in Floating Panel as a content view
    func contentViewController() -> UIViewController
    
    /// Represents the view controller content in transparent area
    /// Use this method only for debugging the transparent area
    /// Otherwise return nil 
    func transparentViewController() -> UIViewController?
}
