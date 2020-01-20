//
//  GLRootCellView.swift
//  GLFloatingPanel
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit

/// Root cell class for all kind of cells in Floating Panel view
class GLRootCellView: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
