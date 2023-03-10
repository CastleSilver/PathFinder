//
//  ViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/08.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add lottie animation
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .loop
        self.view.addSubview(animationView!)
        animationView!.play()
    }


}

