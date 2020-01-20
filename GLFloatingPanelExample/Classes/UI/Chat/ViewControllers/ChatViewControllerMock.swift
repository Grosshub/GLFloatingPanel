//
//  ChatViewControllerMock.swift
//  GLFloatingPanelExample
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit

class ChatViewControllerMock: UIViewController {
    
    var chatView: ChatView
    var cellCount = 30
    weak var delegate: ChatProtocol?
    
    init() {
        
        let chatViewFrame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: ContentSizing.contentViewHeight)
        chatView = ChatView(frame: chatViewFrame)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatView.tableView.delegate = self
        chatView.tableView.dataSource = self
    }
}

extension ChatViewControllerMock: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellID")
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.text = "Message \(indexPath.row + 1)"
        cell.textLabel?.textColor = .white
        
        return cell
    }
}

extension ChatViewControllerMock: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let delegate = delegate {
            delegate.chatDidScroll(scrollView: scrollView)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            delegate.chatMessageDidTouched()
        }
    }
}
