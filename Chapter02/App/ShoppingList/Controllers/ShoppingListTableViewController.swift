import UIKit

class ShoppingListTableViewController: BaseTableViewController {
  
  var lists: [ShoppingList] = [ShoppingList].load() {
    didSet {
      lists.save()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Shopping Lists"
    
    navigationController?.navigationBar.prefersLargeTitles = true
    
    navigationItem.rightBarButtonItems?.append(editButtonItem)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func didSelectAdd(_ sender: UIBarButtonItem) {
    requestInput(title: "Shopping list name",
                 message: "Enter name for the new shopping list:",
                 handler: { (listName) in
                  let listCount = self.lists.count;
                  let list = ShoppingList(name: listName, items: [], onUpdate: self.lists.save)
                  self.lists.append(list)
                  self.tableView.insertRows(at: [IndexPath(row: listCount, section: 0)], with: .top)
    })
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lists.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
    
    let list = lists[indexPath.row]
    cell.textLabel?.text = list.name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      lists.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    lists.swapAt(fromIndexPath.row, to.row)
  }
  
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationViewController = segue.destination as? ItemTableViewController {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let list = lists[indexPath.row]
        destinationViewController.list = list
      }
    }
  }
}


