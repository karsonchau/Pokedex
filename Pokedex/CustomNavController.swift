//
//  CustomNavController.swift
//  Pokedex
//
//  Created by Karson Chau on 2018-06-19.
//  Copyright © 2018 Karson Chau. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }

}
