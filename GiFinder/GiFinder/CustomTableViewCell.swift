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
    
    @IBAction func touchUpOut(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    @IBAction func touchDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    @IBAction func touchUpIn(_ sender: UIButton) {
//        UIImageWriteToSavedPhotosAlbum(gifImageView.image!, nil, nil, nil)
        sender.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        downloadAndSaveGIF(from: url)
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

    func downloadAndSaveGIF(from urlString: String) {
        
        let url =  URL(string: urlString)
        if url == nil  {
            print("URL invalide")
            return
        }

        // Télécharger le GIF
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Erreur de téléchargement : \(error.localizedDescription)")
                return
            }
            
            if data == nil {
                print("Données vides")
                return
            }
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp.gif")
            
            if let response = response {
                print("Requête réussie")
                do {
                    try data!.write(to: tempURL)
                    self.saveGIFToPhotos(url: tempURL)
                } catch {
                    print("Erreur d'écriture du fichier : \(error.localizedDescription)")
                }
            }else {
                print("La requête a échoué")
                return
            }
            
            
        }.resume()
    }

    // Fonction pour passer le fichier GIF du dossier temporaire à la galerie photo
    func saveGIFToPhotos(url: URL) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, fileURL: url, options: nil)
        }) { success, error in
            if success {
                print("GIF enregistré avec succès")
            } else if let error = error {
                print("Erreur d'enregistrement : \(error.localizedDescription)")
            }
        }
    }

}
