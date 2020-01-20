//
//  MessagePanelView.swift
//  GLFloatingPanelExample
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit

class MessagePanelView: UIView {
    
    var backView: UIView!
    var textViewBackgroundView: UIView!
    var sendButton: UIButton!
    var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backView = UIView(frame: .zero)
        backView.backgroundColor = .lightGray
        backView.alpha = 0.5
        addSubview(backView)
        
        textViewBackgroundView = UIView(frame: .zero)
        textViewBackgroundView.backgroundColor = .clear
        textViewBackgroundView.layer.borderColor = UIColor(red: 19, green: 32, blue: 46, alpha: 0.3).cgColor
        textViewBackgroundView.layer.borderWidth = 1.0
        textViewBackgroundView.layer.cornerRadius = 20.0
        addSubview(textViewBackgroundView)
        
        textView = UITextView(frame: .zero)
        textView.backgroundColor = .clear
        textView.text = "Message text"
        textView.textColor = .lightGray
        textView.autocorrectionType = .no
        textViewBackgroundView.addSubview(textView)
        
        sendButton = UIButton(type: .custom)
        sendButton.setImage(UIImage(named: "sendWhite"), for: .normal)
        textViewBackgroundView.addSubview(sendButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        backView.frame = CGRect(x: 0,
                                y: 0,
                                width: self.frame.size.width,
                                height: self.frame.size.height)
                
        let textViewBackgroundViewHeight: CGFloat = 40.0
        let textViewBackgroundViewLeading: CGFloat = 16.0
        let textViewBackgroundViewTopOffset: CGFloat = 8.0
        textViewBackgroundView.frame = CGRect(x: textViewBackgroundViewLeading,
                                              y: textViewBackgroundViewTopOffset,
                                              width: self.frame.size.width - textViewBackgroundViewLeading * 2,
                                              height: textViewBackgroundViewHeight)
        
        let sendButtonSize = CGSize(width: sendButton.imageView?.image?.size.width ?? 0.0, height: sendButton.imageView?.image?.size.height ?? 0.0)
        let sendButtonOriginX: CGFloat = textViewBackgroundView.frame.size.width - sendButtonSize.width - 17.0
        let sendButtonOriginY: CGFloat = (textViewBackgroundView.frame.size.height - sendButtonSize.height) / 2
        sendButton.frame = CGRect(x: sendButtonOriginX,
                                  y: sendButtonOriginY,
                                  width: sendButtonSize.width,
                                  height: sendButtonSize.height)
        
        let textViewLeading: CGFloat = 10
        let textViewTopOffset: CGFloat = 5
        let textViewOriginX: CGFloat = 16.0
        let textViewRightOffset: CGFloat = textViewBackgroundView.frame.size.width - sendButton.frame.origin.x + 4.0
        textView.frame = CGRect(x: textViewLeading,
                                y: textViewTopOffset,
                                width: textViewBackgroundView.frame.size.width - textViewOriginX - textViewRightOffset,
                                height: textViewBackgroundView.frame.size.height - textViewTopOffset * 2)
    }
}

