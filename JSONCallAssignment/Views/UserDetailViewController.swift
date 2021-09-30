//
//  UserDetailViewController.swift
//  JSONCallAssignment
//
//  Created by Rishabh Etwal on 25/09/21.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var albumLabel: UILabel!

    var albumBlock: Album?
    var albumID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromAlbums(temporaryAlbumId: albumID!)
        albumLabel.text = "\(albumID ?? 0)"
    }
    
    func fetchDataFromAlbums(temporaryAlbumId: Int) {
        let url = URL(string: "http://jsonplaceholder.typicode.com/albums/\(temporaryAlbumId)")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if data != nil && error == nil {
                let decoder = JSONDecoder()
                do {
                    self.albumBlock = try decoder.decode(Album.self, from: data!)
                    print(self.albumBlock?.userID ?? 0)
                } catch {
                    print("Error while parsing JSON")
                }
                DispatchQueue.main.async {
                    self.userLabel.text = "\(self.albumBlock?.userID ?? 0)"
                }
            }
        }.resume()
    }
}
