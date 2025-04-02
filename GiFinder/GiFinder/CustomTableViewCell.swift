//
//  CustomTableViewCell.swift
//  GiFinder
//
//  Created by Pierrick Dennemont on 24/03/2025.
//

import UIKit
import Photos

class CustomTableViewCell: UITableViewCell {

    var url: String = ""
    
    @IBAction func click(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        GiphyAPIHandle.shared.downloadAndSavePhotoGIF(from: url)
    }
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    func loadGif(from url: String) {
        if let gifImage = UIImage.gifImageWithURL(url) {    //On vérifie que l'url n'est pas nil
            DispatchQueue.main.async {
                self.gifImageView.image = gifImage
                self.url = url
            }
        }
    }

    
}
