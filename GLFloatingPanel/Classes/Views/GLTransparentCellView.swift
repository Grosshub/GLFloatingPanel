//
//  GLTransparentCellView.swift
//  GLFloatingPanel
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit

/// Returns the table cell managed by the controller object
/// Represents a transparent area in table view on the top of the content view
class GLTransparentCellView: GLRootCellView {
    
    var backgroundButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundButton = UIButton(type: .roundedRect)
        addSubview(backgroundButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundButton.frame = frame
    }
}
