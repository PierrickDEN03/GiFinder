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
    
    @IBAction func clic(_ sender: Any) {
        //UIImageWriteToSavedPhotosAlbum(gifImageView.image!, nil, nil, nil)
        let urlFormat = URL(string: url)
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, fileURL: urlFormat!, options: nil)
        }) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("GIF has saved")
            }
        }
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
