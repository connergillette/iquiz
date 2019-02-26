//
//  ViewController.swift
//  iQuiz
//
//  Created by Admin on 2/22/19.
//  Copyright © 2019 Conner Gillette. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var questions : [String] = ["How old am I?", "What is my name?"]
  let answer_choices : [[String]] = [["22 years old", "23 years old", "21 years old", "29 years old"], ["Charlie", "Sharon", "Conner", "Hannah"]]
  let correct_answer_choices : [Int] = [2, 2]
  var question_number : Int = 0
  var numCorrect : Int = 0
  
  var chosen_answer : String = ""
  
  @IBOutlet weak var question_label: UILabel!
  
  @IBOutlet weak var collection: QuestionController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    question_label.text = questions[question_number]
    collection.answer_choices = answer_choices
    collection.correct_answer_choices = correct_answer_choices
    collection.question_number = question_number
    
    collection.delegate = collection
    collection.dataSource = collection
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  @IBAction func answerChoiceSelected(_ sender: UIButton) {
    if let text = sender.titleLabel?.text {
      chosen_answer = text
    }
    performSegue(withIdentifier: "Answer", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch(segue.identifier) {
    case "Answer":
      _ = segue.source as! ViewController
      let destination = segue.destination as! AnswerController
      destination.chosen_answer = chosen_answer
      destination.correct_answer = collection.answer_choices[question_number][correct_answer_choices[question_number]]
      destination.question_number = question_number
      destination.questions = questions
      destination.numCorrect = numCorrect
    default:
      NSLog("Unknown segue identifier: \(segue.identifier)")
    }
  }
}

class QuestionController: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
  var question_number : Int = 0
  var answer_choices : [[String]] = [[]]
  var correct_answer_choices : [Int] = []
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerChoice", for: indexPath) as! AnswerChoiceCell
    
    cell.setText(answer_choices[question_number][indexPath.item])
//    if (indexPath.item != correct_answer_choices[question_number]) {
//      cell.answer_choice.isEnabled = false
//    }
    
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
  
  var question_number : Int = 0
  var questions : [String] = []
  var numCorrect : Int = 0
  
  @IBOutlet weak var question_label: UILabel!
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(chosen_answer, correct_answer)
    if (chosen_answer.elementsEqual(correct_answer)) {
      label.text = "That's correct!"
      numCorrect += 1
    } else {
      label.text = "You answered \(chosen_answer), and the correct answer was \(correct_answer)"
    }
    
    question_label.text = questions[question_number]
  }

  @IBAction func nextButtonTouchUp(_ sender: Any) {
    if(question_number < questions.count - 1) {
      performSegue(withIdentifier: "Question", sender: self)
    } else if(question_number == questions.count - 1) {
      performSegue(withIdentifier: "Results", sender: self)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch(segue.identifier) {
    case "Results":
      let destination = segue.destination as! ResultsController
      destination.numCorrect = numCorrect
      destination.numTotal = questions.count
    case "Question":
      let destination = segue.destination as! ViewController
      destination.question_number = question_number + 1
      destination.numCorrect = numCorrect
    default:
      NSLog("Unknown segue identifier: \(segue.identifier)")
    }
  }
  
}

class ResultsController : UIViewController {
  var numCorrect : Int = 0
  var numTotal : Int = 1
  
  @IBOutlet weak var description_text: UILabel!
  @IBOutlet weak var result: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    result.text = "You scored \(numCorrect) out of \(numTotal)."
    
    switch(numTotal - numCorrect) {
    case 0:
      description_text.text = "Perfect!"
    case 1:
      description_text.text = "Almost!"
    case 2:
      description_text.text = "Not quite."
    default:
      description_text.text = "Try again!"
    }
    
  }
}
