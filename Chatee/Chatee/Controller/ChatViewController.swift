
import UIKit
import FirebaseDatabase

class ChatViewController: UIViewController{
  
  var messages : [String] = []
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var messageField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func sendButtonTapped(_ sender: UIButton) {
    guard let messageText = messageField.text else {return}
    let messageDB: DatabaseReference = Database.database().reference()
    messageDB.childByAutoId().setValue(messageText) { (error, _) in
      if let err = error {
        print("Error adding message to Firebase: \(err)")
      } else {
        print("Successfully added message!")
        self.messageField.text = ""
      }
    }
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
