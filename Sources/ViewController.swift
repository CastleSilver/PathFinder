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
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add lottie animation
        animationView = .init(name: "splash-image")
        let screenBounds = UIScreen.main.bounds
        // auto layout 사용해서 지정해도 됨
        animationView!.frame = CGRect(
                                      x: -(screenBounds.width * 0.05), y: screenBounds.height * 0.4,
                                      width: screenBounds.width * 1.1, height: screenBounds.height * 0.6
                               )
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        self.view.addSubview(animationView!)
        animationView!.play()
    }


}

