//
//  SubjectListController.swift
//  iQuiz
//
//  Created by Admin on 2/22/19.
//  Copyright © 2019 Conner Gillette. All rights reserved.
//

import UIKit

class SubjectListController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
  @IBOutlet weak var subject_list: UITableView!
  @IBOutlet weak var toolbar: UIToolbar!
  
  let subjects : [String] = ["Mathematics", "Marvel Super Heroes", "Science"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    subject_list.delegate = self
    subject_list.dataSource = self
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Subject", for: indexPath) as! SubjectListCell
    
    cell.setLabelText(subjects[indexPath.item])
    cell.setDescriptionText("Description " + String(indexPath.item))
    cell.setIconPath();
    
    return cell
  }
  
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return subjects.count
  }
  
  @IBAction func settingsPressed(_ sender: Any) {
    let alert = UIAlertController(title: "Settings", message: "Settings go here.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
      NSLog("The \"OK\" alert occured.")
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  
}

class SubjectListCell : UITableViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var description_label: UILabel!
  @IBOutlet weak var icon: UIImageView!
  
  var label_text : String = ""
  var description_text : String = ""
  var icon_path : UIImage = UIImage(named: "star_icon")!
  
  func setLabelText (_ text : String) {
    self.label_text = text
    self.label.text = text
  }
  
  func setDescriptionText (_ text : String) {
    self.description_text = text
    self.description_label.text = text
  }
  
  func setIconPath () {
    icon.image = icon_path
  }
}
