//
//  ChatView.swift
//  GLFloatingPanelExample
//
//  Created by Alexey Gross on 12/09/2019.
//

import UIKit

class ChatView: UIView {
    
    var tabBarHeaderView: UIView!
    var tableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tabBarHeaderView = UIView(frame: .zero)
        tabBarHeaderView.backgroundColor = .purple
        tabBarHeaderView.alpha = 0.9
        addSubview(tabBarHeaderView)

        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .purple
        tableView.alpha = 0.7
        tableView.separatorStyle = .none
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let tabBarHeaderHeight: CGFloat = 50.0
        tabBarHeaderView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: frame.size.width,
                                        height: tabBarHeaderHeight)
        
        
        tableView.frame = CGRect(x: 0,
                                 y: tabBarHeaderView.frame.origin.y + tabBarHeaderView.frame.size.height,
                                 width: frame.size.width,
                                 height: frame.size.height - tabBarHeaderView.frame.size.height)
    }
}
