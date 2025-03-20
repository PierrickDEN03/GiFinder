//
//  ViewController.swift
//  GiFinder
//
//  Created by Loic Babolat on 20/03/2025.
//

import UIKit
import SwiftyGif

class ViewController: UIViewController, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>// You can also set it with an URL pointing to your gif
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! Cell

        if let image = try? UIImage(imageName: images[indexPath.row]) {
            cell.gifImageView.setImage(image, manager: gifManager, loopCount: -1)
        } else if let url = URL.init(string: images[indexPath.row]) {
            let loader = UIActivityIndicatorView.init(style: .white)
            cell.gifImageView.setGifFromURL(url, customLoader: loader)
        } else {
            cell.gifImageView.clear()
        }

        return cell
    }
    

    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var gifImageCell: UITableViewCell!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

