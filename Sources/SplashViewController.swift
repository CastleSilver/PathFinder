//
//  ViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/03/08.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add lottie animation
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .playOnce
        view.addSubview(animationView!)
        animationView!.play()
        
        // 5초 후 메인 화면으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
    }


}

