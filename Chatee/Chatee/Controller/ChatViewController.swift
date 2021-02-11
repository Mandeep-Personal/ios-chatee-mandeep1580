
import UIKit

class ChatViewController: UIViewController{
  
  var messages : [String] = []
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
      
        // Do any additional setup after loading the view.
    }

}

extension ChatViewController: UITableViewDelegate,
                               UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return messages.count
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell")
    // cell.stuff = messages [indexPath.row].thing
    cell?.textLabel?.text = "Hellow"
    return cell!
  }
  
}
