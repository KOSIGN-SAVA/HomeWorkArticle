//
//  MainViewController.swift
//  HWMVPArticle
//
//  Created by Vansa Pha on 12/14/16.
//  Copyright © 2016 Vansa Pha. All rights reserved.
//

import UIKit

class MainViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    var presenter:ArticlePresenter?
    var articles:[Article]=[Article]()
    var refreshTool:UIRefreshControl!
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.presenter?.fetchArticle(page: 1, limit: 10)
    }
    
    func updateData(){
        // When Delegate from Service stop the refresh
        tableView.refreshControl?.endRefreshing()
    }
    
    func postArticleFromMain(titleArti:String, descArti:String, imgArti:String){
        print("start to post")
        presenter=ArticlePresenter()
        presenter?.delegate=self
        presenter?.postArticle(titleArt: titleArti, descriptionArt: descArti, imgLink: imgArti)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTool=UIRefreshControl()
        tableView.refreshControl?.isEnabled=true
        tableView.refreshControl=UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter=ArticlePresenter()
        presenter?.delegate=self
        presenter?.fetchArticle(page: 1, limit: 10)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            let id=self.articles[indexPath.row].id
            self.performSegue(withIdentifier: "idtupdate", sender: id)
        }
        editAction.backgroundColor = UIColor.purple
        return [deleteAction, editAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="idtupdate" {
            if let updateForm=segue.destination as? AddArticleViewController{
                if let id=sender as? Int{
                    updateForm.id=id
                }
            }
        }
    }
    
}

extension MainViewController:ArticlePresenterProtocol{
    
    func startFetchArticle() {
        print("start fetch article")
        tableView.refreshControl?.beginRefreshing()
        let timer = Timer.init(timeInterval: 10, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
        timer.fire()
    }
    
    func responseImageURL(resImgUrl: String) {
        //not use
    }
    
    func responseData(_ data: [Article], method:String, index:Int) {
        switch method {
        case "GET":
            self.articles.removeAll()
            self.articles=data
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
            print("Refreshing...")
        case "DELETE":
            print("Delete successfully! \(index)")
            tableView.reloadData()
        default:
            break
        }
    }
    
    func responseDataError() {
        print("Error get data from API.")
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
