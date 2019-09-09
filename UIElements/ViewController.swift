//
//  ViewController.swift
//  UIElements
//
//  Created by Евгений Полянский on 09.09.2019.
//  Copyright © 2019 Евгений Полянский. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.insertSegment(withTitle: "Third", at: 2, animated: true)
        }
    }
    @IBOutlet weak var label: UILabel! {
        didSet {
            //label.isHidden = true
            label.font = label.font.withSize(35)
            label.textAlignment = .center
            label.numberOfLines = 4
        }
    }
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.minimumTrackTintColor = .red
            slider.maximumTrackTintColor = .green
            slider.thumbTintColor = .blue
            slider.value = 1
        }
    }
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet var allObjects: [AnyObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = String(slider.value)
    }

    @IBAction func segmentChosen(_ sender: UISegmentedControl) {
        guard let segmentText = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else { return }
        label.text = "The \(segmentText) segment is selected"
        label.isHidden = false
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            label.textColor = .red
        case 1:
            label.textColor = .blue
        case 2:
            label.textColor = .yellow
        default:
            print("Something is wrong!")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
         label.text = String(sender.value)
        
        let bgColor = self.view.backgroundColor
        self.view.backgroundColor = bgColor?.withAlphaComponent(CGFloat(sender.value))
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        guard textField.text?.isEmpty == false else { return }
        if let _ = Double(textField.text!) {
            let alert = UIAlertController(title: "Wrong format", message: "Please enter your name!", preferredStyle: .alert)
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter correct Name!"
            }
            let okAction = UIAlertAction(title: "Set", style: .default, handler: { _ in
                guard let textFields = alert.textFields else { return }
                guard let name = textFields[0].text else { return }
                self.label.text = name
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            print("Error")
        } else {
            label.text = textField.text
            textField.text = nil
        }
    }
    @IBAction func chengeData(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale.init(identifier: "ru_Ru")
        label.text = dateFormatter.string(from: sender.date)
    }
    
    
}

