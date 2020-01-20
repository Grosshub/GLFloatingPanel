//
//  MainViewController.swift
//  GLFloatingPanelExample
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit
import GLFloatingPanel

class MainViewController: UIViewController {
    
    private var mainView: MainView!
    private var floatingPanelController: GLFloatingPanelController
    private var chatViewController: ChatViewControllerMock      // Use any content view controller here (even Tab Bar controller)
    fileprivate var animationState: AnimationState = .finished
    fileprivate var messagePanelState: MessagePanelState = .visible
    
    fileprivate var isKeyboardVisible: Bool = false
    
    init() {
        chatViewController = ChatViewControllerMock()
        
        floatingPanelController = GLFloatingPanelController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        mainView = MainView(frame: UIScreen.main.bounds)
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Detect when chat messages scrolled
        chatViewController.delegate = self
        
        floatingPanelController.delegate = self
        floatingPanelController.dataSource = self
        floatingPanelController.tableView = mainView.contentTableView
        
        // Message panel
        mainView.messagePanelView.sendButton.addTarget(self, action: #selector(sendMessageButtonTap(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Keyboard events

    @objc func keyboardWillAppear(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if mainView.keyboardHeight == 0 {
                mainView.keyboardHeight = keyboardSize.height
            }
        }
        isKeyboardVisible = true
        
        // Reload Floating Panel controller
        floatingPanelController.delegate = self
        
        
        UIView.transition(with: mainView.contentTableView, duration: 0.1, options: .curveLinear, animations: { self.mainView.contentTableView.reloadData()
            
        }, completion: nil)
        
        mainView.setNeedsLayout()
        mainView.layoutIfNeeded()
    }

    @objc func keyboardWillDisappear() {
        
        isKeyboardVisible = false
        mainView.keyboardHeight = 0
        
        // Reload Floating Panel controller
        floatingPanelController.delegate = self
        
        UIView.transition(with: mainView.contentTableView, duration: 0.05, options: .curveLinear, animations: { self.mainView.contentTableView.reloadData()
            
        }, completion: nil)
        
        mainView.setNeedsLayout()
        mainView.layoutIfNeeded()
    }
    
    // MARK: - UIButton events
    
    @objc func sendMessageButtonTap(_ sender: UIButton) {
        
        hideKeyboard()
    }
    
    // MARK: - Private methods
    
    fileprivate func hideKeyboard() {
        mainView.messagePanelView.textView.resignFirstResponder()
    }
}

extension MainViewController: GLFloatingPanelDataSource {
    
    func contentViewController() -> UIViewController {
        chatViewController.chatView.tableView.isScrollEnabled = false
        return chatViewController
    }
    
    func transparentViewController() -> UIViewController? {
        let transparentViewControllerMock = UIViewController()
        transparentViewControllerMock.view.backgroundColor = .green
        transparentViewControllerMock.view.alpha = 0.25
        return transparentViewControllerMock
    }
}

extension MainViewController: GLFloatingPanelDelegate {
    
    func contentViewMinOriginY() -> CGFloat {
        return ContentSizing.minContentViewOriginY
    }
    
    func contentViewHeight() -> CGFloat {
        let additionalHeight = isKeyboardVisible ? -mainView.keyboardHeight : 0
        return ContentSizing.contentViewHeight + additionalHeight
    }
    
    func transparentViewHeight() -> CGFloat {
        let additionalHeight = isKeyboardVisible ? -mainView.keyboardHeight : 0
        return ContentSizing.contentViewHeight - ContentSizing.minContentViewOriginY + additionalHeight
    }
    
    func contentViewDidScroll(scrollView: UIScrollView, direction: GLScrollDirection) {
        
        // Handle floating content scrolling
        let transparentViewHeight: CGFloat = ContentSizing.contentViewHeight - ContentSizing.minContentViewOriginY
        let offset = Int(scrollView.contentOffset.y - transparentViewHeight)
        
        print("\(offset) \(-mainView.keyboardHeight)")
        
        if isKeyboardVisible {
            
            if CGFloat(offset) >= -mainView.keyboardHeight {
                chatViewController.chatView.tableView.isScrollEnabled = true
                // No need to proceed with processing when content view reached the top
                return
            } else {
                chatViewController.chatView.tableView.isScrollEnabled = false
            }

            return
            
        } else {
            if offset >= 0 {
                chatViewController.chatView.tableView.isScrollEnabled = true
                // No need to proceed with processing when content view reached the top
                return
            } else {
                chatViewController.chatView.tableView.isScrollEnabled = false
            }
        }
        
        // Handle message panel frame
        let positiveOffset = abs(offset)
        let statusBarOffset: CGFloat = 20.0
        let animationStartOffset: Int = 440
        let maxPositiveOffset: Int = Int(transparentViewHeight + statusBarOffset)
        let animationOffsetTotalScope = maxPositiveOffset - animationStartOffset
        let animationOffsetLeastScrope = maxPositiveOffset - positiveOffset
        let isOffsetInScope = animationOffsetLeastScrope < animationOffsetTotalScope ? true : false
        
        // Logs
//        print("direction \(direction == .up ? "UP":"Down") Positive offset: \(positiveOffset) least offset: \(animationOffsetLeastScrope) total scope: \(animationOffsetTotalScope) \(isOffsetInScope ? "In scope": "Out of scope")")
        
        if !isOffsetInScope && messagePanelState == .hidden {
            willShow()
        }
        
        if animationOffsetLeastScrope > animationOffsetTotalScope || animationOffsetLeastScrope <= 0 {
            // No need to animate message panel if least offset not in animation offset scope
            return
        }
        
        if direction == .up && animationState == .finished && messagePanelState == .hidden {
            willShow()
            return
        }
        if direction == .down && animationState == .finished && messagePanelState == .visible {
            willHide()
            return
        }
    }
    
    func contentViewWillScroll(scrollView: UIScrollView) {
        
    }
    
    func transparentAreaTouched() {
        hideKeyboard()
    }
}

extension MainViewController: ChatProtocol {
    
    func chatDidScroll(scrollView: UIScrollView) {
//        print("Chat scrolled: \(scrollView.contentOffset.y)")
    }
    
    func chatMessageDidTouched() {
        hideKeyboard()
    }
}

extension MainViewController: AnimatedMessagePanelProtocol {
    
    // TODO: calculate scrolling speed to make an impact on animation duration
    // the higher speed makes animation more quickly
    
    func willHide() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations:
            {
                self.animationState = .animating
          
                let maxOriginY: CGFloat = UIScreen.main.bounds.height
                
                self.mainView.messagePanelViewOriginY = maxOriginY
                self.mainView.setNeedsLayout()
                self.mainView.layoutIfNeeded()
            
        }, completion: { finished in
            self.animationState = .finished
            self.messagePanelState = .hidden
        })
    }
    
    func willShow() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations:
            { 
                self.animationState = .animating
        
                let minOriginY: CGFloat = UIScreen.main.bounds.height - self.mainView.messagePanelView.frame.size.height
                
                self.mainView.messagePanelViewOriginY = minOriginY
                self.mainView.setNeedsLayout()
                self.mainView.layoutIfNeeded()
                
        }, completion: { finished in
            self.animationState = .finished
            self.messagePanelState = .visible
        })
    }
}
