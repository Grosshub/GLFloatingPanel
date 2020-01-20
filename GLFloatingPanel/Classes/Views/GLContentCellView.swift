//
//  GLContentCellView.swift
//  GLFloatingPanel
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit

/// Returns the table cell managed by the controller object
/// Represents a content area in table view on the top of the content view
class GLContentCellView: GLRootCellView {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
