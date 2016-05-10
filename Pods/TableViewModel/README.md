# TableViewModel
TableViewModel lets you create your UITableView instances declaratively in Swift. You can add, insert or remove sections and rows without worrying about implementing UITableViewDelegate and UITableViewDataSource methods.

TableViewModel registers different types of cells as reusable cells in the TableView, and uses dequeueReusableCellWithIdentifier when it needs them. From a performance point of view it is not any different than manually implementing UITableViewDataSource.

TableViewModel is inspired from [DXTableViewModel](https://github.com/libdx/DXTableViewModel) but it is not a Swift implementation of DXTableViewModel. It is written from the ground up in Swift and does many things differently.

[![CI Status](http://img.shields.io/travis/tbergmen/TableViewModel.svg?style=flat)](https://travis-ci.org/tbergmen/TableViewModel)
[![Version](https://img.shields.io/cocoapods/v/TableViewModel.svg?style=flat)](http://cocoapods.org/pods/TableViewModel)
[![License](https://img.shields.io/cocoapods/l/TableViewModel.svg?style=flat)](http://cocoapods.org/pods/TableViewModel)
[![Platform](https://img.shields.io/cocoapods/p/TableViewModel.svg?style=flat)](http://cocoapods.org/pods/TableViewModel)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Examples
### Adding sections and rows:
```Swift
// Create TableViewModel
self.tableViewModel = TableViewModel(tableView:self.tableView)

// Create and add the section
let tableSection = TableSection()
tableSection.headerTitle = "Section title"
tableSection.headerHeight = 30
self.tableViewModel.addSection(tableSection)

// Create and add the row
let tableRow = TableRow(cellIdentifier:"MyCell") // Cell identifier is either the reuse identifier of a reusable cell, or name of an XIB file that contains one and only one UITableViewCell object
tableRow.userObject = "My tag" // Optional <AnyObject> property to identify the row later
tableSection.addRow(tableRow)
```

### Configuring the rows
```Swift
tableRow.configureCell {
    cell in
    let label = cell.viewWithTag(1) as! UILabel
    label.text = "Custom text"
}
```

### Selection handler
```Swift
tableRow.onSelect {
    row in
    NSLog("selected row \(row.userObject)")
}
```

### Adding, inserting and removing rows
```Swift
// Adding multiple rows
tableSection.addRows(arrayOfRows) // IMPORTANT: Notice that this performs much faster than inserting a bunch of rows one by one in a loop
// Insert a row at an index
tableSection.insertRow(newRow, atIndex:0)
// Remove a row
tableSection.removeRow(tableRow)
// Remove multiple rows
tableSection.removeRows(arrayOfRows) // IMPORTANT: Notice that this performs much faster than removing a bunch of rows one by one in a loop
// Removing all rows
tableSection.removeAllRows()
```

### Inserting removing sections
```Swift
// Insert a section at an index
tableViewModel.insertSection(newSection, atIndex:0)
// Remove section
tableViewModel.removeSection(tableSection)
// Remove all sections
tableViewModel.removeAllSections()
```

### Cell with custom sub class
```Swift
tableRow.configureCell {
    cell in
    let myCustomCell = cell as! MyCustomCell
    myCustomCell.setTitle("Custom title")
}
```

### Custom section header views
```Swift
let customHeaderView = UIView() // Can be any UIView or subclass instance
tableSection.headerView = customHeaderView
tableSection.headerHeight = customHeaderView.frame.size.height
```

### Custom row height
```Swift
tableRow.height = Float(90)
```

### Row animation for adding, inserting and removing rows
```Swift
tableSection.rowAnimation = UITableRowAnimation.Right
tableSection.addRow(newRow)
```

### Section animation for adding, inserting and removing sections
```Swift
tableViewModel.sectionAnimation = UITableRowAnimation.Fade
tableViewModel.addSection(newSection)
```

## Installation
TableViewModel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TableViewModel"
```

## Author
Tunca Bergmen, tunca@bergmen.com

## License
TableViewModel is available under the MIT license. See the LICENSE file for more info.
