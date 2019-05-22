

import UIKit

public protocol ReusableView: class { }

extension ReusableView where Self: UIView {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}

extension UITableView {
    
    public func dequeueCell<T: UITableViewCell>(_ cellType: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! T
    }
    
    public func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as! T
    }
    
    public func register<T: UITableViewCell>(_ cellType: T.Type) {
        
        let nib = UINib(nibName: cellType.reuseIdentifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    public func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        let nib = UINib(nibName: viewType.reuseIdentifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }
    
    public func scrollToBottom(animated: Bool = true) {
        
        let lastSection = self.numberOfSections - 1
        
        if lastSection >= 0 {
            let lastRow = self.numberOfRows(inSection: lastSection) - 1
            if lastRow >= 0 {
                self.scrollToRow(at: IndexPath(item: lastRow, section: lastSection), at: .bottom, animated: animated)
            }
        }
    }
    
    public func scrollToTop(animated: Bool = true) {
        
        if self.numberOfSections > 0 {
            let rowsInsection = self.numberOfRows(inSection: self.numberOfSections)
            if rowsInsection > 0 {
                self.scrollToRow(at: IndexPath(item: 0, section: 0), at: .bottom, animated: animated)
            }
        }
    }
}

open class DescriptableTableViewCell: UITableViewCell {
    
    private(set) var indexPath: IndexPath!
    
    open func configure<RowDescriptorType: TableViewCellDescriptor>(with rowDescriptor: RowDescriptorType, at indexPath: IndexPath) {
        
        self.indexPath = indexPath
        rowDescriptor.cell = self
    }
    
    open func updateUI() {
        
    }
}

open class TableViewCellDescriptor: Equatable {
    
    private(set) var uuid: String
    
    public var height: CGFloat = 50.0
    open var cellType: DescriptableTableViewCell.Type {
        return DescriptableTableViewCell.self
    }
    open var onTapAction: ((TableViewCellDescriptor) -> ())?
    
    open fileprivate(set) var cell: DescriptableTableViewCell?
    
    public init() {
        self.uuid = UUID().uuidString
    }
    
    public static func ==(lhs: TableViewCellDescriptor, rhs: TableViewCellDescriptor) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

open class DescriptableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel?
    
    private var onTapAction: (() ->())? = nil
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    open func configure<SectionHeaderDescriptorType: TableViewSectionDescriptor>(with sectionDescriptor: SectionHeaderDescriptorType) {
        
        titleLabel?.text = sectionDescriptor.title
        onTapAction = sectionDescriptor.onTapAction
        
        if let attributedTitle = sectionDescriptor.attributedTitle {
            titleLabel?.attributedText = attributedTitle
            titleLabel?.textAlignment = sectionDescriptor.labelAligment
        }else {
            titleLabel?.text = sectionDescriptor.title
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        onTapAction?()
    }
}


open class TableViewSectionDescriptor {
    
    open var viewType: DescriptableHeaderView.Type { return DescriptableHeaderView.self }
    public var onTapAction: (() -> ())? = nil
    
    private(set) var title: String = ""
    private(set) var attributedTitle: NSAttributedString? = nil
    private(set) var labelAligment: NSTextAlignment = .left
    private(set) var uuid = UUID().uuidString
    private(set) var height: CGFloat = 20.0
    
    private var rows: [TableViewCellDescriptor] = []
    
    public var allRows: [TableViewCellDescriptor] {
        return rows
    }
    
    public var rowsCount: Int {
        return rows.count
    }
    
    public init() {
        
    }
    
    public init(title: String, height: CGFloat? = nil) {
        
        self.title = title
        
        if let height = height {
            self.height = height
        }else {
            if title.isEmpty {
                self.height = 20.0
            }else {
                self.height = 50.0
            }
        }
    }
    
    public init(attributedTitle: NSAttributedString?, labelAligment: NSTextAlignment = .left, height: CGFloat? = nil) {
        
        self.attributedTitle = attributedTitle
        self.labelAligment = labelAligment
        
        if let height = height {
            self.height = height
        }else {
            if attributedTitle == nil {
                self.height = 20.0
            }else {
                self.height = 50.0
            }
        }
    }

    public func append(row: TableViewCellDescriptor) {
        rows.append(row)
    }
    
    public func append(rows: [TableViewCellDescriptor]) {
        self.rows.append(contentsOf: rows)
    }
    
    public func insert(row: TableViewCellDescriptor, at index: Int) {
        self.rows.insert(row, at: index)
    }
    
    public func index(of row: TableViewCellDescriptor) -> Int? {
        return rows.index(of: row)
    }
    
    public func delete(row: TableViewCellDescriptor) {
        
        if let index = rows.index(of: row) {
            rows.remove(at: index)
        }
    }
    
    public func delete(rows: [TableViewCellDescriptor]) {
        
        self.rows = self.rows.filter({ !rows.contains($0) })
    }
    
    public func row(at index: Int) -> TableViewCellDescriptor {
        return rows[index]
    }
}
