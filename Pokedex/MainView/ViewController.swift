//
//  ViewController.swift
//  Pokedex
//
//  Created by Karson Chau on 2018-06-15.
//  Copyright © 2018 Karson Chau. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var inputErrLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberField.delegate = self
        
        // Make the button rounded by setting corner radius
        submitButton.layer.cornerRadius = submitButton.bounds.height / 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Limit the characters in the text field.
    // Less user error
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 3
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    // dismiss keyboard when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func textFieldChanged(_ sender: Any) {
        _ = inputError()
    }
    
    @IBAction func submitButtonTouched(_ sender: Any) {
        // check input before performing segue
        if inputError() {
            performSegue(withIdentifier: "showPokemon", sender: nil)
        }
    }
    
    func inputError() -> Bool{
        
        // Check if input is empty
        if numberField.text?.isEmpty ?? true {
            self.inputErrLabel.isHidden = false
        }
        else if Int(numberField.text!)! > 151 {
            // if input is greater than 151
            self.inputErrLabel.isHidden = false
        }
        else {
            self.inputErrLabel.isHidden = true
            return true
        }
        return false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? PokemonViewController else {return}
        vc.id = Int(numberField.text!)!
        
        // clear the number field before segue
        numberField.text = ""
        // dismiss the keyboard as well.
        self.view.endEditing(true)
    }
}

