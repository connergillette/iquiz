//
//  ViewController.swift
//  iQuiz
//
//  Created by Admin on 2/22/19.
//  Copyright © 2019 Conner Gillette. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let question : String = "How old am I?"
  
  @IBOutlet weak var question_label: UILabel!
  
  
  @IBOutlet weak var collection: QuestionController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    question_label.text = question
    
    collection.delegate = collection
    collection.dataSource = collection
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch(segue.identifier) {
    case "Answer":
      let source = segue.source as! ViewController
      let destination = segue.destination as! AnswerController
      destination.question = self.question
      destination.chosen_answer = collection.answer_choices[0]
      destination.correct_answer = collection.answer_choices[2]
      
    default:
      NSLog("Unknown segue identifier: \(segue.identifier)")
    }
  }
}

class QuestionController: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
  let answer_choices : [String] = ["22 years old", "23 years old", "21 years old", "29 years old"]
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerChoice", for: indexPath) as! AnswerChoiceCell
    
    cell.setText(answer_choices[indexPath.item])
    if (indexPath.item != 2) {
      cell.answer_choice.isEnabled = false
    }
    
    return cell
  }
}

class AnswerChoiceCell : UICollectionViewCell {
  
  @IBOutlet weak var answer_choice: UIButton!
  var text : String = "";
  
  func setText (_ text : String) {
    self.text = text
    answer_choice.setTitle(text, for: .normal)
  }
}

class AnswerController : UIViewController {
  var question : String = "";
  var chosen_answer : String = ""
  var correct_answer : String = ""
  
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    label.text = "You answered \(chosen_answer), and the correct answer was \(correct_answer)"
  }

}
