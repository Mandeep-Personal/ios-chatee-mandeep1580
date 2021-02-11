import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBAction func loginTappedButton(_ sender: Any) {
    //register user thru firebase
        guard let email = emailTextField.text, let password = passwordTextField.text
        else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
          if let err = error {
            print("Error creating firebase user \(err)")
          } else {
            print {"Successfuly created user \(String(describing: user))"}
          }
        }
  }

  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
