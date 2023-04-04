//
//  ResultViewController.swift
//  PathFinder
//
//  Created by tmoney on 2023/04/03.
//

import UIKit
import Lottie

class ResultViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startAddress: UILabel!
    @IBOutlet weak var arrivalAddress: UILabel!
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    var route = Route.shared
    var start: String = ""
    var arrival: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add lottie animation
        lottieView!.contentMode = .scaleAspectFill
        lottieView!.loopMode = .loop
        lottieView!.play()
        startAddress.text = start
        arrivalAddress.text = arrival
//        routeSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func routeSetting() {
        print(route.startAddress)
        startAddress.text = route.startAddress
        arrivalAddress.text = route.arrivalAddress
    }
}
