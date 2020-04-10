//
//  ARCarPlateRecognitionViewController.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 26.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import UIKit
import ARKit

class ARCarPlateRecognitionViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.debugOptions = .showFeaturePoints
        sceneView.showsStatistics = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()

               // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        sceneView.session.pause()
    }

}

// MARK: ARSCNViewDelegate
extension ARCarPlateRecognitionViewController: ARSCNViewDelegate {

}
