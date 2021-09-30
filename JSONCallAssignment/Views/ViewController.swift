//
//  ViewController.swift
//  JSONCallAssignment
//
//  Created by Rishabh Etwal on 16/09/21.
//

import UIKit

// MARK: - View Controller
class ViewController: UIViewController {
    
    var imageBlock: [Photos] = []
    @IBOutlet weak var URLCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromPhotos()
        URLCollectionView.delegate = self
        URLCollectionView.dataSource = self
    }
    
    // MARK: - Function to parse the http://jsonplaceholder.typicode.com/photos
    func fetchDataFromPhotos() {
        let url = URL(string: "http://jsonplaceholder.typicode.com/photos")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if data != nil && error == nil {
                let decoder = JSONDecoder()
                do {
                    self.imageBlock = try decoder.decode([Photos].self, from: data!)
                } catch {
                    print("Error while parsing JSON")
                }
                DispatchQueue.main.async {
                    self.URLCollectionView.reloadData()
                }
            }
        }.resume()
    }
}

// MARK: - Extension of the view controller to render the fetched data over the user interface
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageBlock.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! UrlCollectionViewCell
        cell.imageViewUrl.contentMode = .scaleAspectFill
        let linkUrl = imageBlock[indexPath.row].thumbnailURL
        cell.imageViewUrl.downloaded(from: linkUrl!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128.0, height: 128.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let vc = storyboard?.instantiateViewController(identifier: "UserDetailViewController") as? UserDetailViewController
        vc?.albumID = imageBlock[indexPath.row].albumID ?? 0
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

// MARK: - Function to downlaod images from the link into the system's memory and then render it.
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
