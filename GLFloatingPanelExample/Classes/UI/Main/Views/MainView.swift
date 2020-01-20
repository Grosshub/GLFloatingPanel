//
//  MainView.swift
//  GLFloatingPanelExample
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit
import GLFloatingPanel

class MainView: UIView {
    
    var backgroundView: UIImageView!
    var contentTableView: UITableView!
    var messagePanelView: MessagePanelView!
    var messagePanelViewOriginY: CGFloat = 0.0
    var keyboardHeight: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView = UIImageView(frame: .zero)
        backgroundView.image = UIImage(named: "background")
        addSubview(backgroundView)
        
        contentTableView = UITableView(frame: .zero)
        contentTableView.backgroundColor = .clear
        contentTableView.showsVerticalScrollIndicator = false
        addSubview(contentTableView)
        
        messagePanelView = MessagePanelView(frame: .zero)
        addSubview(messagePanelView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: frame.size.width,
                                      height: frame.size.height)

        messagePanelViewOriginY = self.frame.size.height - ContentSizing.messagePanelHeight - keyboardHeight
        messagePanelView.frame = CGRect(x: 0.0,
                                        y: messagePanelViewOriginY,
                                        width: frame.size.width,
                                        height: ContentSizing.messagePanelHeight)

        let contentTableViewHeight = frame.size.height - (frame.size.height - messagePanelView.frame.origin.y)
        contentTableView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: frame.size.width,
                                        height: contentTableViewHeight)
    }
}

