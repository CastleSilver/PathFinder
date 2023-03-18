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
        animationView!.play()
        
        // Splash 화면에서 5초 후에 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showNavigationController()
        }
    }
    
    // 5초 후에 실행될 함수
    func showNavigationController() {
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        // 현재 보여지고 있는 뷰 컨트롤러를 네비게이션 컨트롤러로 교체
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
}

