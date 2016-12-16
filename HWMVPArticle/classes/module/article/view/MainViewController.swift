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
    
    var s:String="fdsfs"
    
    func toStandardDate(dateStr:String)->String{
        let s=NSString(string: dateStr)
        let st=s.doubleValue
        let date=Date(timeIntervalSinceReferenceDate: st)
        return "\(date)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.fetchArticle(page: 1, limit: 15)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.delegate=self
        tableView.dataSource=self
        presenter=ArticlePresenter()
        presenter?.delegate=self
        presenter?.fetchArticle(page: 1, limit: 15)
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
            cell.articleDate.text=toStandardDate(dateStr: articles[indexPath.row].createDate)
            cell.articleDescription.text=articles[indexPath.row].description
            cell.articleThumnail.downloadedFrom(link: articles[indexPath.row].image)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.presenter?.deleteArticle(id: self.articles[indexPath.row].id, index: indexPath.row)
            self.articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
        }
        editAction.backgroundColor = UIColor.purple
        return [deleteAction, editAction]
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.presenter?.deleteArticle(id: self.articles[indexPath.row].id, index: indexPath.row)
//            articles.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
//        }
//    }
    
}

extension MainViewController:ArticlePresenterProtocol{
    
    func startFetchArticle() {
        print("start fetch article")
    }
    
    func responseData(_ data: [Article], method:String, index:Int) {
        switch method {
        case "GET":
            articles.append(contentsOf: data)
            tableView.reloadData()
            print("Get data successfully!")
        case "DELETE":
            print("Delete successfully! \(index)")
            //articles.remove(at: index)
            tableView.reloadData()
        case "POST":
            print("Post successfully!")
            tableView.reloadData()
        default:
            break
        }
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
