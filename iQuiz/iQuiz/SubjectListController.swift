//
//  SubjectListController.swift
//  iQuiz
//
//  Created by Admin on 2/22/19.
//  Copyright © 2019 Conner Gillette. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubjectListController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
  @IBOutlet weak var subject_list: UITableView!
  @IBOutlet weak var toolbar: UIToolbar!
  
  var subjects : [String] = []
  var descriptions : [String] = []
  var questions : [[String]] = [[]]
  var answer_choices: [[[String]]] = [[[]]]
  var correct_choices : [[Int]] = [[]]
  var quiz_data : JSON = JSON()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "https://tednewardsandbox.site44.com/questions.json")
    
    reachabilityManager?.listener = { status in
      switch status {
        
      case .notReachable:
        let alert = UIAlertController(title: "Network Unavailable", message: "The network is not available.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
          NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        if(UserDefaults.standard.object(forKey: "quiz_json") != nil) {
          self.parseJSON(JSON(UserDefaults.standard.string(forKey: "quiz_json")))
        }
      default:
        AF.request("https://tednewardsandbox.site44.com/questions.json").responseJSON {
          response in
          if let result = response.result.value {
            let json = JSON(result)
            UserDefaults.standard.set(response.result.value, forKey: "quiz_json")
            self.quiz_data = json
            print(json)
            self.parseJSON(json)
          }
        }
    }
    }
    reachabilityManager?.startListening()
    
    self.subject_list.delegate = self
    self.subject_list.dataSource = self
    
  }
  
  func parseJSON (_ json : JSON) {
    for subject in json.arrayValue {
      print(subject["title"])
      self.subjects.append(subject["title"].stringValue)
      self.descriptions.append(subject["desc"].stringValue)
      var current_questions : [String] = []
      var current_choices : [[String]] = []
      var current_correct : [Int] = []
      for question in subject["questions"].arrayValue {
        current_questions.append(question["text"].stringValue)
        current_correct.append(question["answer"].intValue)
        var current_question_choices : [String] = []
        for choice in question["answers"].arrayValue {
          current_question_choices.append(choice.stringValue)
        }
        current_choices.append(current_question_choices)
      }
      self.questions.append(current_questions)
      self.correct_choices.append(current_correct)
      self.answer_choices.append(current_choices)
      //          print(self.questions)
      //          print(self.correct_choices)
      //          print(self.answer_choices)
    }
    self.subject_list.reloadData()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Subject", for: indexPath) as! SubjectListCell
    
    cell.setLabelText(subjects[indexPath.item])
    cell.setDescriptionText(descriptions[indexPath.item])
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    var destination = segue.destination as! ViewController
    if let chosen_subject : SubjectListCell = sender as? SubjectListCell {
      let subject_index = self.subjects.index(of: chosen_subject.label_text)
      destination.questions = self.questions[subject_index! + 1]
      destination.answer_choices = self.answer_choices[subject_index! + 1]
      destination.correct_answer_choices = self.correct_choices[subject_index! + 1]
    }
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
