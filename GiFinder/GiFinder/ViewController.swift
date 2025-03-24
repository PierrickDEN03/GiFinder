//
//  ViewController.swift
//  GiFinder
//
//  Created by Pierrick Dennemont on 24/03/2025.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let images = [
                  "https://media.giphy.com/media/5tkEiBCurffluctzB7/giphy.gif",
                  "2.gif",
                  "https://media.giphy.com/media/5xtDarmOIekHPQSZEpq/giphy.gif",
                  "3.gif",
                  "https://media.giphy.com/media/3oEjHM2xehrp0lv6bC/giphy.gif",
                  "5.gif",
                  "https://media.giphy.com/media/l1J9qg0MqSZcQTuGk/giphy.gif",
                  "4.gif",
    ]

    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
            let imageUrl = images[indexPath.row]
        cell.loadGif(from: imageUrl)
        return cell
    }

    
    
    
}

