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

/**
    The object that represents a section in a table view.
*/
public class TableSection: NSObject {

    internal private(set) var rows: NSMutableArray

    /**
        The table view that this section is bound to.
    
        - Warning: This property will be set internally when the section is added to a TableViewModel. Do not try to set this manually.
    */
    public internal(set) var tableView: UITableView?
    
    /**
     The table view model that this section belongs to.
        
     - Warning: This property will be set internally when the section is added to a TableViewModel. Do not try to set this manually.
    */
    public internal(set) weak var tableViewModel: TableViewModel?

    /// The row animation that will be displayed when rows are inserted or removed.
    public var rowAnimation: UITableViewRowAnimation

    /// A UIView instance that will be displayed as the header view of the section.
    public var headerView: UIView?
    
    /// Height of the header view.
    public var headerHeight: Float = 0
    
    /**
        Header title of the section.
     
        - Remark: When this property is set without setting the header height, it will set the header height to 30.

        - Warning: If the headerView property is set, this title will not be shown.
     */
    public var headerTitle: String? = nil {
        didSet {
            if headerHeight == 0 {
                headerHeight = Float(30)
            }
        }
    }

    /**
        Initializes the TableSection.
    */
    public init(rowAnimation: UITableViewRowAnimation = UITableViewRowAnimation.Fade) {
        rows = NSMutableArray()
        self.rowAnimation = rowAnimation

        super.init()

        addObserver(self, forKeyPath: "rows", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: "rows")
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String:AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let indexSet: NSIndexSet = change?[NSKeyValueChangeIndexesKey] as? NSIndexSet else {
            return
        }

        guard let tableViewModel = self.tableViewModel else {
            return
        }

        guard let kind: NSKeyValueChange = NSKeyValueChange(rawValue: change?[NSKeyValueChangeKindKey] as! UInt) else {
            return
        }

        guard let tableView = self.tableView else {
            return
        }

        let sectionIndex = tableViewModel.indexOfSection(self)

        var indexPaths = Array<NSIndexPath>()
        indexSet.enumerateIndexesUsingBlock {
            (idx, _) in

            let indexPath: NSIndexPath = NSIndexPath(forRow: idx, inSection: sectionIndex)
            indexPaths.append(indexPath)
        }

        tableView.beginUpdates()
        switch kind {
        case .Insertion:
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
        case .Removal:
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
        default:
            return
        }
        tableView.endUpdates()
    }

    /**
        Adds a row to the section.

        - Parameters:
            - row: The row to be added.
    */
    public func addRow(row: TableRowProtocol) {
        assignTableSectionOfRow(row)
        observableRows().addObject(row)
    }

    /**
        Adds multiple rows to the section.
     
        - Parameters:
            - rowsToAdd: Array of rows to be added.
     
        - Remark: Use this method instead of adding rows one by one in a loop. It performs remarkably better.
    */
    public func addRows(rowsToAdd: Array<TableRowProtocol>) {
        rowsToAdd.forEach(assignTableSectionOfRow)
        let rowObjects = rowsToAdd.map {
            row in
            return row as AnyObject
        }
        let rowsProxy = self.observableRows()
        let range = NSMakeRange(self.rows.count, rowObjects.count)
        let indexes = NSIndexSet(indexesInRange: range)
        rowsProxy.insertObjects(rowObjects, atIndexes: indexes)
    }

    /**
        Inserts a row at the given index.
     
        - Parameters:
            - row: The row to be added.
            - atIndex: Index at which the row will be added.
     */
    public func insertRow(row: TableRowProtocol, atIndex index: Int) {
        assignTableSectionOfRow(row)
        observableRows().insertObject(row, atIndex: index)
    }

    /**
        Removes a row from the section.
     
        - Parameters:
            - row: The row to be removed.
    */
    public func removeRow(row: TableRowProtocol) {
        removeTableSectionOfRow(row)
        observableRows().removeObject(row)
    }

    /**
        Removes multiple rows.
     
        - Parameters:
            - rowsToRemove: Array of rows that will be removed.

        - Remark: Use this method instead of removing rows one by one in a loop. It performs remarkably better.
    */
    public func removeRows(rowsToRemove: Array<TableRowProtocol>) {
        rowsToRemove.forEach(removeTableSectionOfRow)
        let rowsProxy = self.observableRows()
        let indexes = NSMutableIndexSet()
        for row in rowsToRemove {
            let index = self.indexOfRow(row)
            indexes.addIndex(index)
        }
        rowsProxy.removeObjectsAtIndexes(indexes)
    }

    /**
        Removes all rows from the section.

        - Remark: Use this method instead of adding rows one by one in a loop. It performs remarkably better.
    */
    public func removeAllRows() {
        let allRows = self.rows.map {
            row in
            return row as! TableRowProtocol
        }
        allRows.forEach(removeTableSectionOfRow)
        let rowsProxy = self.observableRows()
        let range = NSMakeRange(0, rowsProxy.count)
        let indexes = NSIndexSet(indexesInRange: range)
        rowsProxy.removeObjectsAtIndexes(indexes)
    }

    // Returns number of rows in the section.
    public func numberOfRows() -> Int {
        return rows.count
    }

    /// Returns the row object at given index.
    public func rowAtIndex(index: Int) -> TableRowProtocol {
        return rows.objectAtIndex(index) as! TableRowProtocol
    }

    /// Returns the index of row object.
    public func indexOfRow(row: TableRowProtocol) -> Int {
        return rows.indexOfObject(row)
    }

    private func assignTableSectionOfRow(row: TableRowProtocol) {
        row.tableSection = self
    }

    private func removeTableSectionOfRow(row: TableRowProtocol) {
        guard self.indexOfRow(row) != NSNotFound else {
            return
        }
        row.tableSection = nil
    }

    private func observableRows() -> NSMutableArray {
        return mutableArrayValueForKey("rows")
    }

    /**
        Returns an immutable NSArray object contains all rows added to the section.
     
        - Warning: Do not try to modify this array, use add, insert and remove methods instead.
    */
    public func allRows() -> NSArray {
        return rows
    }
}
