//
//  GLFloatingPanelDelegate.swift
//  GLFloatingPanel
//

import UIKit

/// Methods for managing and configuring content view in Floating Panel
public protocol GLFloatingPanelDelegate: class {
    
    /// Returns a content view minimum origin y value
    /// That means content view header will be never lower than this value
    func contentViewMinOriginY() -> CGFloat
    
    /// Define a custom height for a content view
    func contentViewHeight() -> CGFloat
    
    /// Define a custom height for a transparent view 
    func transparentViewHeight() -> CGFloat
    
    /// Notification when scroll view has been scrolled
    func contentViewDidScroll(scrollView: UIScrollView, direction: GLScrollDirection)
    
    /// Notification before the scroll view began scrolling
    func contentViewWillScroll(scrollView: UIScrollView)
    
    /// Notification when user touch transparent area
    func transparentAreaTouched()
}
