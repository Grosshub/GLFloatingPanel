//
//  GLFloatingPanelController.swift
//  GLFloatingPanel
//
//  Created by Alexey Gross on 10/09/2019.
//

import UIKit

/// A view controller that specializes in managing a Floating Panel View
open class GLFloatingPanelController: UITableViewController {
    
    public weak var dataSource: GLFloatingPanelDataSource? {
        willSet {
            if let contentView = newValue?.contentViewController().view, let transparentView = newValue?.transparentViewController()?.view {
                dataSourceHas.contentView = contentView
                dataSourceHas.transparentView = transparentView
            }
        }
    }
    
    public weak var delegate: GLFloatingPanelDelegate? {
        willSet {
            if let contentMinOriginY = newValue?.contentViewMinOriginY(),
                let contentViewHeight = newValue?.contentViewHeight(),
                let transparentViewHeight = newValue?.transparentViewHeight() {
                
                delegateHas.contentMinOriginY = contentMinOriginY
                delegateHas.contentViewHeight = contentViewHeight
                delegateHas.transparentViewHeight = transparentViewHeight
            }
        }
    }
    
    public override var tableView: UITableView! {
        willSet {
            newValue.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            newValue.delegate = self
            newValue.dataSource = self
        }
    }
    
    fileprivate var lastContentOffset: CGFloat = 0.0
    
    fileprivate struct DataSourceHas {
        var contentView: UIView = UIView()
        var transparentView: UIView?
    }
    
    fileprivate struct DelegateHas {
        var contentMinOriginY: CGFloat = UIScreen.main.bounds.height / 3
        var contentViewHeight: CGFloat = UIScreen.main.bounds.height
        var transparentViewHeight: CGFloat = UIScreen.main.bounds.height - UIScreen.main.bounds.height / 3
    }
    
    private unowned var contentViewController: UIViewController?
    private var dataSourceHas: DataSourceHas = DataSourceHas()
    private var delegateHas: DelegateHas = DelegateHas()
    private var transparentCell: GLTransparentCellView!
    private var contentCell: GLContentCellView!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GLCellIndex.allCases.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "\(indexPath.row)"
        
        if indexPath.row == GLCellIndex.transparent.rawValue {
            
            if transparentCell == nil {
                transparentCell = GLTransparentCellView(style: .default, reuseIdentifier: cellId)
            }
            
            transparentCell.backgroundButton.addTarget(self, action: #selector(transparentCellTap), for: .touchUpInside)

            transparentCell.backgroundColor = .clear
            if let transparentView = dataSourceHas.transparentView {
                transparentCell.contentView.addSubview(transparentView)
                transparentCell.clipsToBounds = true
            }
            
            return transparentCell
            
        } else if indexPath.row == GLCellIndex.content.rawValue {
            
            if contentCell == nil {
                contentCell = GLContentCellView(style: .default, reuseIdentifier: cellId)
            }
            contentCell.backgroundColor = .clear
            contentCell.contentView.addSubview(dataSourceHas.contentView)
            contentCell.clipsToBounds = true
            return contentCell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: cellId)
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    // MARK: - UITableViewDelegate
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == GLCellIndex.transparent.rawValue {
            return delegateHas.transparentViewHeight
            
        } else if indexPath.row == GLCellIndex.content.rawValue {
            return delegateHas.contentViewHeight
        }
        return 0.0
    }

    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    public override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
     
        if let delegate = delegate {
            delegate.contentViewWillScroll(scrollView: scrollView)
        }
    }
    
    // MARK: - Observer
       
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
        if let tableView = object as? UITableView {

            let offset = tableView.contentOffset.y
//            print("\(#function) at \((#file as NSString).lastPathComponent) offset: \(offset)")

            let direction: GLScrollDirection
            if (lastContentOffset < offset) {
                direction = .up
            } else if (lastContentOffset > offset) {
                direction = .down
            } else {
                direction = .didNotMove
            }
            lastContentOffset = offset
            
            if let delegate = delegate {
                
                let bounceLimit = delegateHas.transparentViewHeight / 2
                if (offset < bounceLimit) {
                    tableView.bounces = true
                } else {
                    tableView.bounces = false
                }
                
                delegate.contentViewDidScroll(scrollView: tableView, direction: direction)
            }
        }
    }
    
    // MARK: - UIButton events
    
    @objc func transparentCellTap() {
        
        if let delegate = delegate {
            delegate.transparentAreaTouched()
        }
    }
}
