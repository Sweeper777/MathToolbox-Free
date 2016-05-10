/*

Copyright (c) 2016 Tunca Bergmen <tunca@bergmen.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

import Foundation
import UIKit

/// Protocol to represent a table row. You implement this protocol to create rows that has a custom behavior. If you are not planning to add custom behavior, we encourage you to use the TableRow class instead.
public protocol TableRowProtocol: class, AnyObject {

    /// Returns the cell that this row contains.
    func cellForTableView(tableView: UITableView) -> UITableViewCell?

    /// Returns the height of cell.
    func heightForCell() -> CGFloat

    /// Called when the row is selected.
    func select()

    /// If set to true, deselects the row when it is selected.
    var shouldDeselectAfterSelection: Bool { get }

    /// Table section that this row belongs to.
    var tableSection: TableSection? { get set }
}

/// The object that represents a table row.
public class TableRow: TableRowProtocol {
    private let cellIdentifier: String
    private var bundle: NSBundle?
    private var configureClosure: ((cell:UITableViewCell) -> ())?
    private var onSelectionClosure: ((row:TableRow) -> ())?

    /// The cell instance this row contains.
    public private(set) var cell: UITableViewCell?
    
    /**
        The table section that this row belongs to.
     
        - Warning: This property will be set internally when the row is added to a TableSection. Do not try to set this manually.
    */
    public weak var tableSection: TableSection?
    
    /// Height of the row.
    public var height: Float?

    /// If set to true, deselects the row when it is selected. Default value of this property is `true`.
    public var shouldDeselectAfterSelection: Bool = true

    /// Custom user object to tag this row. This property is optional.
    public var userObject: AnyObject?

    /**
        Initializes the row.
        
        - Parameters: 
            - cellIdentifier: Either the reuse identifier of a reusable cell defined in a TableView using the interface builder, or name of an XIB file that contains one and only one UITableViewCell object.
            - inBundle: [Optional] This is the bundle that the XIB file is in. Default is nil.
    */
    public init(cellIdentifier: String, inBundle bundle: NSBundle? = nil) {
        self.cellIdentifier = cellIdentifier
        self.bundle = bundle
    }

    /// Returns the cell that this row contains.
    public func cellForTableView(tableView: UITableView) -> UITableViewCell? {
        self.cell = loadCellForTableView(tableView)

        callConfigureCellClosure()

        guard let cell = self.cell else {
            return nil
        }

        if self.height == nil {
            self.height = Float(cell.frame.height)
        }

        return cell
    }

    /// Returns the height of cell.
    public func heightForCell() -> CGFloat {
        if let height = self.height {
            return CGFloat(height)
        }

        return 44
    }

    /// Called when the row is selected.
    public func select() {
        if let closure = onSelectionClosure {
            closure(row: self)
        }
    }

    /**
        Adds a closure which is called when a cell will be displayed. Use this closure to display your custom data in the cell.
    */
    public func configureCell(closure: (cell:UITableViewCell) -> ()) {
        configureClosure = closure
        callConfigureCellClosure()
    }

    /**
        Adds a closure which will be called when a user selects the cell. Use this to implement custom behavior when the cell is selected.
    */
    public func onSelect(closure: (row:TableRow) -> ()) {
        onSelectionClosure = closure
    }

    private func callConfigureCellClosure() {
        guard let closure = self.configureClosure else {
            return
        }

        guard let cell = self.cell else {
            return
        }

        closure(cell: cell)
    }

    private func loadCellForTableView(tableViewOrNil: UITableView?) -> UITableViewCell? {
        let tableView: UITableView
        if tableViewOrNil == nil {
            tableView = UITableView()
        } else {
            tableView = tableViewOrNil as UITableView!
        }

        let dequeued = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if dequeued != nil {
            return dequeued
        } else {
            let nib: UINib = UINib(nibName: cellIdentifier, bundle: bundle)
            tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
            return cell
        }
    }
}

