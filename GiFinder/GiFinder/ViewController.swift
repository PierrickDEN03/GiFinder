//
//  ViewController.swift
//  GiFinder
//
//  Created by Pierrick Dennemont on 24/03/2025.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITableViewDataSource {
    let cle_api = "2f5FBLcJV7y3LhnqWcg97Sd67UtwhSie"
    var images: [String] = []
    
    @IBOutlet weak var queryField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clic(_ sender: Any) {
        Task {
            if  queryField.text != nil {
                await giphyData()
            }else{
                print("Le Text Field est vide")
            }
        }
    }
    
    func giphyData() async{
        let dataImages = await giphyFetch(api_key: self.cle_api, queryStr: queryField.text!)
        self.images = []
        for img in dataImages{
            self.images.append(img.images.fixed_height.url)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("your row number: \(indexPath.row)")
    }
    
}


func giphyFetch(api_key: String, queryStr: String) async -> [Item] {
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

struct ImgInfo: Codable {
    let url: String
    let width: String
    let height: String
}

struct Img: Codable {
    let fixed_height: ImgInfo
    let fixed_width: ImgInfo
}

struct Item: Codable {
    let alt_text: String
    let title: String
    var images: Img
}

struct Response: Codable {
    var data: [Item]
}
