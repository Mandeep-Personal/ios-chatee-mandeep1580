
import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UIViewController{
  
  var messages : [Message] = []
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var messageField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "chatCell")
    getMessages()
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func sendButtonTapped(_ sender: UIButton) {
    guard let messageText = messageField.text else {return}
    let messageDB: DatabaseReference = Database.database().reference().child("Messages")
    let messageDict = [
      "Sender": Auth.auth().currentUser?.email,
      "MessageBody": messageText
    
    ]
    messageDB.childByAutoId().setValue(messageDict) { (error, _) in
      if let err = error {
        print("Error adding message to Firebase: \(err)")
      } else {
        print("Successfully added message!")
        self.messageField.text = ""
      }
    }
  }
  
  func getMessages(){
    let messageDB: DatabaseReference = Database.database().reference().child("Messages")
    messageDB.observe(.childAdded) { (snapshot) in
      if let value = snapshot.value as? Dictionary<String, String>,
         let sender = value["Sender"],
         let messageBody = value["MessageBody"] {
        let message = Message(sender: sender, messageBody: messageBody)
        self.messages.append(message)
        self.tableView.reloadData()
      }
    }
  }
}

extension ChatViewController: UITableViewDelegate,
                              UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! MessageCell
    let message = messages[indexPath.row]
    cell.senderLabel.text = message.sender
    cell.messageBodyLabel.text = message.messageBody
    return cell
  }
  
}
