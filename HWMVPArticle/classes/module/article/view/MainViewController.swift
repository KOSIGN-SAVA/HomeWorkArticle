//
//  MainViewController.swift
//  HWMVPArticle
//
//  Created by Vansa Pha on 12/14/16.
//  Copyright © 2016 Vansa Pha. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var presenter:ArticlePresenter?
    var articles:[Article]=[]
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        presenter=ArticlePresenter()
        presenter?.delegate=self
        presenter?.fetchArticle()
    }

}

extension MainViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell=tableView.dequeueReusableCell(withIdentifier: "idarticle", for: indexPath) as? ArticleCell{
            cell.articleTitle.text=articles[indexPath.row].title
            cell.articleDate.text=articles[indexPath.row].createDate
            cell.articleDescription.text=articles[indexPath.row].description
            cell.articleThumnail.downloadedFrom(link: articles[indexPath.row].image)
            return cell
        }
        return UITableViewCell()
    }
    
}

extension MainViewController:ArticlePresenterProtocol{
    
    func startFetchArticle() {
        //start
    }
    
    func responseData(_ data: [Article]) {
        articles.append(contentsOf: data)
        tableView.reloadData()
    }
    
    func responseDataError() {
        //error
    }
    
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
