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
    An object oriented implementation of UITableViewDataSource and UITableViewDelegate protocols.

    Use it in conjuction with TableSection and TableRow classes to create dynamic and configurable UITableView instances.
*/
public class TableViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {

    /// The table view that this section is bound to.
    public let tableView: UITableView
   
    /// The row animation that will be displayed when sections are inserted or removed.
    public var sectionAnimation: UITableViewRowAnimation

    internal private(set) var sections: NSMutableArray

    /**
        Initializes a TableViewModel with a table view.
     
        - Parameters:
            - tableView: to use with the model
    */
    public init(tableView: UITableView) {
        self.sections = NSMutableArray()
        self.tableView = tableView
        self.sectionAnimation = UITableViewRowAnimation.Fade

        super.init()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()

        addObserver(self, forKeyPath: "sections", options: NSKeyValueObservingOptions.New, context: nil)
    }

    deinit {
        removeObserver(self, forKeyPath: "sections")
    }

    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String:AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let indexSet: NSIndexSet = change?[NSKeyValueChangeIndexesKey] as? NSIndexSet else {
            return
        }

        guard let kind: NSKeyValueChange = NSKeyValueChange(rawValue: change?[NSKeyValueChangeKindKey] as! UInt) else {
            return
        }

        self.tableView.beginUpdates()
        switch kind {
        case .Insertion:
            tableView.insertSections(indexSet, withRowAnimation: self.sectionAnimation)
        case .Removal:
            tableView.deleteSections(indexSet, withRowAnimation: self.sectionAnimation)
        default:
            return
        }
        tableView.endUpdates()
    }

    /**
        Adds a section to tableView.
     
        - Parameters:
            - section: The TableSection instance that describes the section.
     */
    public func addSection(section: TableSection) {
        assignParentsToSection(section)
        observableSections().addObject(section)
    }

    /**
        Inserts a section to tableView at a given index.
     
        - Parameters:
            - section: The TableSection instance that describes the section.
            - atIndex: Index at which the section will be inserted.
     */
    public func insertSection(section: TableSection, atIndex index: Int) {
        assignParentsToSection(section)
        observableSections().insertObject(section, atIndex: index)
    }

    /**
        Removes given section from the tableView
        
        - Parameters:
            - section: The section to remove.
    */
    public func removeSection(section: TableSection) {
        guard self.indexOfSection(section) != NSNotFound else {
            return
        }

        removeParentsFromSection(section)
        observableSections().removeObject(section)
    }

    /// Removes all sections from the tableView.
    public func removeAllSections() {
        let allSections: [TableSection] = self.sections.map {
            section in
            return section as! TableSection
        }
        allSections.forEach(removeParentsFromSection)
        let sectionsProxy = self.observableSections()
        let range = NSMakeRange(0, sectionsProxy.count)
        let indexes = NSIndexSet(indexesInRange: range)
        sectionsProxy.removeObjectsAtIndexes(indexes)
    }

    private func assignParentsToSection(section: TableSection) {
        section.tableViewModel = self
        section.tableView = tableView
    }

    private func removeParentsFromSection(section: TableSection) {
        section.tableViewModel = nil
        section.tableView = nil
    }

    /**
        Returns the index of given section.

        - Parameters:
            - section: The section to return the index of.
    */
    public func indexOfSection(section: TableSection) -> Int {
        return sections.indexOfObject(section)
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionAtIndex(section).numberOfRows()
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = rowForIndexPath(indexPath)
        let cell = row.cellForTableView(tableView) as UITableViewCell!

        return cell
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowForIndexPath(indexPath).heightForCell()
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = rowForIndexPath(indexPath)

        row.select()

        if row.shouldDeselectAfterSelection {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    public func tableView(tableView: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView? {
        return self.sectionAtIndex(sectionIndex).headerView
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection sectionIndex: Int) -> CGFloat {
        return CGFloat(self.sectionAtIndex(sectionIndex).headerHeight)
    }

    public func tableView(tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
        return self.sectionAtIndex(sectionIndex).headerTitle
    }

    private func observableSections() -> NSMutableArray {
        return mutableArrayValueForKey("sections")
    }

    private func sectionAtIndex(index: Int) -> TableSection {
        return sections[index] as! TableSection
    }

    private func rowForIndexPath(indexPath: NSIndexPath) -> TableRowProtocol {
        let section = sections[indexPath.section] as! TableSection
        let row = section.rowAtIndex(indexPath.row)
        return row
    }

    /**
        Returns an immutable NSArray object contains all sections added to the model.
     
        - Warning: Do not try to modify this array, use add, insert and remove methods instead.
    */
    public func allSections() -> NSArray {
        return sections
    }
}
