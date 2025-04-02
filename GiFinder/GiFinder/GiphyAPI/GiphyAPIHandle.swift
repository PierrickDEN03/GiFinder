import Foundation
import Photos

// Création d'une classe pour  la gestion de l'appel API
class GiphyAPIHandle {
    
    // Objet static créé à l'intérieur avec des attributs définis, pour être utilisé dans tout le  projet
    static var shared = GiphyAPIHandle(api_key: ProcessInfo.processInfo.environment["API_KEY"], limit: 15)
    
    let api_key: String
    let limit: Int
    // Gif  qui est renvoyé lorsqu'il n'y a pas ou plus de résultat
    init(api_key: String?, limit: Int) {
        if api_key == nil {
            print("la clef d'API n'est pas défini")
            self.api_key = ""
        }else{
            self.api_key = api_key!
        }
        self.limit = limit
    }
    
    func call(queryStr: String, offset: Int = 0) async -> ([String], Bool) {
        let data = await self.fetch(queryStr: queryStr, offset: offset)
        if(data != nil && data!.data != []){
            let dataImages = data!.data
                var tempImages: [String] = []
            for img in dataImages{
                tempImages.append(img.images.fixed_height.url)
            }
            return (tempImages, isTotalCount(data!.pagination!))
        }else{
            return ([], true)
        }
    }
    
    private func fetch(queryStr: String, offset: Int) async -> Response? {
        var giphyData: Response?
        var components = URLComponents(string: "https://api.giphy.com/v1/gifs/search")
        components!.queryItems = [
            URLQueryItem(name: "api_key", value: self.api_key),
            URLQueryItem(name: "q", value: queryStr),
            URLQueryItem(name: "limit", value: String(self.limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        
        do{
            let (data, response) = try await URLSession.shared.data(from: components!.url!)
            if let responseHtpp = response as? HTTPURLResponse{
                let decoder = JSONDecoder()
                giphyData = try decoder.decode(Response.self, from: data)
                if responseHtpp.statusCode != 200{
                    print("Error \(responseHtpp.statusCode): \(giphyData!.meta.msg)")
                }
            }
        }catch{
            print("error during the API call: \(error)")
        }
        
        return giphyData
    }
    
    private func isTotalCount(_ pagination: Pagination) -> Bool{
        return pagination.offset + pagination.count == pagination.total_count
    }
    
    // MARK: - Request  and download for a gif
    func downloadAndSavePhotoGIF(from urlString: String) {
        
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
            
            if let response = response as? HTTPURLResponse {
                print("Requête réussie : \(response.statusCode)")
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

struct Meta: Codable{
    let msg: String
}

struct Pagination: Codable{
    let total_count: Int
    let count: Int
    let offset: Int
}

struct Response: Codable {
    var data: [Item]
    var meta: Meta
    var pagination: Pagination?
}
