
import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UIViewController{
  
  var messages : [Message] = []
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var messageField: UITextField!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    messageField.delegate = self
    
    tableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "chatCell")
    
    getMessages()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
    
    tableView.addGestureRecognizer(tapGesture)
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
        self.scrollToBottom()
      }
    }
  }
  
  func scrollToBottom(){
    guard tableView.numberOfRows(inSection: 0) > 0 else {return}
    let indexPath = IndexPath(row: messages.count-1, section: 0)
    tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
  }
  
  @objc func tableViewTapped(){
    messageField.endEditing(true)
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
    if let email = Auth.auth().currentUser?.email, email == message.sender{
      
      cell.messageBodyBackground.backgroundColor = UIColor.green
      cell.senderImageView.image = UIImage(named: "stars")
    } else {
      cell.messageBodyBackground.backgroundColor = UIColor.orange
      cell.senderImageView.image = UIImage(named: "smile")
    }
    return cell
  }
  
}

extension ChatViewController: UITextFieldDelegate{
  func textFieldDidBeginEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.5) {
      self.heightConstraint.constant = 360
      self.view.layoutIfNeeded()
      self.scrollToBottom()
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.5) {
      self.heightConstraint.constant = 150
      self.view.layoutIfNeeded()
      self.scrollToBottom()
    }
  }
}

