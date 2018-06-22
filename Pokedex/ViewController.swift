//
//  ViewController.swift
//  Pokedex
//
//  Created by Karson Chau on 2018-06-15.
//  Copyright © 2018 Karson Chau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var inputErrLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 40
        submitButton.layer.cornerRadius = submitButton.bounds.height / 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // dismiss keyboard when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func textFieldChanged(_ sender: Any) {
        inputError()
    }
    
    @IBAction func submitButtonTouched(_ sender: Any) {
        
        //check input
        if numberField.text?.isEmpty ?? true {
            self.inputErrLabel.isHidden = false
        }
        else if Int(numberField.text!)! > 151 {
            self.inputErrLabel.isHidden = false
        }
        else {
            performSegue(withIdentifier: "showPokemon", sender: nil)
            self.inputErrLabel.isHidden = true
        }
    }
    
    func inputError() {
        /*
        let alert = UIAlertController(title: "Empty input", message: "Please enter a number from 1 - 151.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        */
        
        if numberField.text?.isEmpty ?? true {
            self.inputErrLabel.isHidden = false
        }
        else if Int(numberField.text!)! > 151 {
            self.inputErrLabel.isHidden = false
        }
        else {
            self.inputErrLabel.isHidden = true
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? PokemonViewController else {return}
        vc.id = Int(numberField.text!)!
        
        // clear the number field before seque
        numberField.text = ""
        // dismiss the keyboard as well.
        self.view.endEditing(true)
    }
}

