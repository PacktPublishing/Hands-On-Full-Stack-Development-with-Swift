//
//  LoginTableViewController.swift
//  ShoppingList
//
//  Created by Ankur Patel on 1/15/18.
//  Copyright © 2018 Encore Dev Labs LLC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let data = UserDefaults.standard.value(forKey: String(describing: Token.self)) as? Data,
      let _ = try? PropertyListDecoder().decode(Token.self, from: data) {
      self.performSegue(withIdentifier: "showShoppingList", sender: self)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func didSelectLoginButton(_ sender: UIButton) {
    let emailPassword = "\(emailField.text!):\(passwordField.text!)"
    let base64EncodedEmailPassword = Data(emailPassword.utf8).base64EncodedString()
    request(url: "/tokens",
            httpMethod: "POST",
            httpHeaders: ["Authorization": "Basic \(base64EncodedEmailPassword)"]) {
              data, _, _ in
      do {
        let decoder = JSONDecoder()
        let token = try decoder.decode(Token.self, from: data!)
        let data = try? PropertyListEncoder().encode(token)
        UserDefaults.standard.set(data, forKey: String(describing: Token.self))
        UserDefaults.standard.synchronize()
        self.passwordField.text = ""
        self.performSegue(withIdentifier: "showShoppingList", sender: self)
      } catch {
        let alertController = UIAlertController(title: "Error Logging In", message:
          "Email or password is wrong. Please check your credentials and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true)
      }
    }
  }
  
}
