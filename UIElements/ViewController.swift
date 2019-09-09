//
//  ViewController.swift
//  UIElements
//
//  Created by Евгений Полянский on 09.09.2019.
//  Copyright © 2019 Евгений Полянский. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var selectedElement : UIView?
    
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
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.locale = Locale(identifier: "ru_Ru")
        }
    }
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet var allObjects: [UIView]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldForPicker: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = String(slider.value)

        choiceUIElement()
        createToolbar()
    }

    func choiceUIElement() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        textFieldForPicker.inputView = elementPicker
        // Customization
        
        elementPicker.backgroundColor = .brown
        
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        textFieldForPicker.inputAccessoryView = toolbar
        
        // Customization
        toolbar.tintColor = .white
        toolbar.barTintColor = .brown
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    @IBAction func switchAction(_ sender: UISwitch) {
        for element in allObjects {
            element.isHidden = sender.isOn
        }
        if sender.isOn {
            switchLabel.text = "Отобразить все элементы"
        } else {
            switchLabel.text = "Скрыть все элементы"
        }
    }
    
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allObjects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: type(of: allObjects[row]))
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldForPicker.text = String(describing: type(of: allObjects[row]))
        
        for element in allObjects {
            element.isHidden = element == allObjects[row] ? false : true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerViewLabel = UILabel()
        
        if let currentLabel = view as? UILabel {
            pickerViewLabel = currentLabel
        } else {
            pickerViewLabel = UILabel()
        }
        pickerViewLabel.textColor = .white
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 23)
        pickerViewLabel.text = String(describing: type(of: allObjects[row]))
        return pickerViewLabel
    }
}

extension UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
