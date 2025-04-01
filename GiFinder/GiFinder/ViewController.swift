//
//  ViewController.swift
//  GiFinder
//
//  Created by Pierrick Dennemont on 24/03/2025.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    let cle_api = "2f5FBLcJV7y3LhnqWcg97Sd67UtwhSie"
    var images: [String] = []
    
    @IBOutlet weak var queryField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clic(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: false)
        Task {
            if  queryField.text != nil && queryField.text != "" {
                self.images = await giphyData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                self.showAlertEmpty()
            }
        }
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self
        }
    
    // TableView load functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
            let imageUrl = images[indexPath.row]
        cell.loadGif(from: imageUrl)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollTrueOffset = scrollView.contentOffset.y + tableView.frame.size.height
        if scrollView.contentSize.height <= scrollTrueOffset {
            print("reach bottom")
        }
    }
    
    func giphyData() async -> [String] {
        let dataImages = await giphyFetch(api_key: self.cle_api, queryStr: queryField.text!)
        // Vérifie que le tableau [Item] n'est pas nil ou vide
        if(dataImages != nil && dataImages! != [] ){
            var tempImages: [String] = []
            for img in dataImages!{
                tempImages.append(img!.images.fixed_height.url)
            }
            return tempImages
        }else{
            let nullGif = ["https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExNzVyMWhmbHU1czBsenpjNGEyeG5zdXRiMGU2bDduNGVkNWVuOWdrbCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/zLCiUWVfex7ji/giphy.gif"]
            return nullGif
        }
    }
    
    private func showAlertEmpty(){
        let alertController = UIAlertController(title: "Champs Vide", message: "Le champs de texte est vide, veuillez renseigner le style de gif que vous recherchez", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}


func giphyFetch(api_key: String, queryStr: String) async -> [Item?]? {
    var giphyData: Response?
    var components = URLComponents(string: "https://api.giphy.com/v1/gifs/search")
    components!.queryItems = [
        URLQueryItem(name: "api_key", value: api_key),
        URLQueryItem(name: "q", value: queryStr),
        URLQueryItem(name: "limit", value: "15")
    ]
    
    do{
        let (data, _) = try await URLSession.shared.data(from: components!.url!)
        let decoder = JSONDecoder()
        giphyData = try decoder.decode(Response.self, from: data)
    }catch{
        print("error during the API call: \(error)")
    }
    
    return giphyData!.data
}



// MARK: - Les Structures pour gérer la réponse de l'API

struct ImgInfo: Codable, Equatable {
    let url: String
    let width: String
    let height: String
}

struct Img: Codable, Equatable {
    let fixed_height: ImgInfo
    let fixed_width: ImgInfo
}

struct Item: Codable, Equatable {
    let alt_text: String
    let title: String
    var images: Img
}

struct Response: Codable {
    var data: [Item]
}
