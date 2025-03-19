//
//  ViewController.swift
//  GiFinder
//
//  Created by Loic Babolat on 19/03/2025.
//

import UIKit
import Gifu

class ViewController: UIViewController {
    
    @IBOutlet weak var gifImage: GIFImageView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gifImage.prepareForReuse()
    }
    
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         gifImage.animate(withGIFNamed: "gifu-figure")
     }
    /*
     func animate() {
     gifImage.setFrameBufferSize(1)
     
     gifImage.animate(
     withGIFNamed: "gifu-figure",
     loopBlock: {
     print("Loop finished")
     })
     }
     }
     */
    
        
}
