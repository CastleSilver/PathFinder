//
//  SearchViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/17.
//

import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: width - 20, height: 30))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: textField)
    }
}
