//
//  TableViewBaseViewController.swift
//  jitjatjo
//
//  Created by Diego Pais on 10/6/17.
//  Copyright © 2017 Upify. All rights reserved.
//

import UIKit

open class BaseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sections: [TableViewSectionDescriptor] = []
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        let fakeHeaderHeight = CGFloat(40)
        let fakeHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: fakeHeaderHeight))
        
        tableView.tableHeaderView = fakeHeaderView
        tableView.contentInset.top = -fakeHeaderHeight
        
        tableView.registerHeaderFooterView(DescriptableHeaderView.self)
    }
    
    open func setupUI() {
        setupTableView()
    }
    
    open func buildSections() -> [TableViewSectionDescriptor] {
        return []
    }

    open func reloadTable() {
        
        sections = buildSections()
        tableView.reloadData()
    }
    
    public func indexPath(of rowDescriptor: TableViewCellDescriptor) -> IndexPath? {
        
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.allRows.index(of: rowDescriptor) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return nil
    }
    
//    MARK: UITableViewDataSource
 
    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].rowsCount
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowDescriptor = sections[indexPath.section].row(at: indexPath.row)
        
        let cell = tableView.dequeueCell(rowDescriptor.cellType, forIndexPath: indexPath)
        
        cell.configure(with: rowDescriptor, at: indexPath)
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].row(at: indexPath.row).height
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionDescriptor = sections[section]
        
        let sectionView = tableView.dequeueHeaderFooterView(sectionDescriptor.viewType)
        
        sectionView.configure(with: sectionDescriptor)
        
        return sectionView
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].height
    }
    
//    MARK: UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowDescriptor = sections[indexPath.section].row(at: indexPath.row)
        
        rowDescriptor.onTapAction?(rowDescriptor)
    }
}
