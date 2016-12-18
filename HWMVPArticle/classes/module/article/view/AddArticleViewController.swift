//
//  AddArticleViewController.swift
//  HWMVPArticle
//
//  Created by Pha Vansa on 12/16/16.
//  Copyright © 2016 Vansa Pha. All rights reserved.
//

import UIKit

class AddArticleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var thumnailImg: UIImageView!
    @IBOutlet weak var titleArticle: UITextField!
    @IBOutlet weak var descriptionArticle: UITextView!
    var main=MainViewController()
    
    var myActivityIndicator : UIActivityIndicatorView!
    var imgThum:UIImagePickerController!
    var presenter:ArticlePresenter?
    var id:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Add/Edit"
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        //myActivityIndicator.startAnimating()
        imgThum=UIImagePickerController()
        imgThum.delegate=self
        presenter=ArticlePresenter()
        presenter?.delegate=self
        if let i=id {
            if i>0{
                presenter?.fetchArticleById(id: id!)
            }
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func loadImage(_ sender: UIButton) {
        present(imgThum, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img=info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.thumnailImg.image=img
        }
        imgThum.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postPress(_ sender: UIBarButtonItem) {
        view.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
        self.presenter?.uploadImage(img: self.thumnailImg)
    }

    @IBAction func cancelPress(_ sender: UIBarButtonItem) {
        _=navigationController?.popViewController(animated: true)
    }
    
}

extension AddArticleViewController:ArticlePresenterProtocol{
    func startFetchArticle() {
        view.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
    }
    func responseImageURL(resImgUrl: String) {
        print("Upload image successfully!")
        if self.id==nil{
            self.presenter?.postArticle(titleArt: self.titleArticle.text!, descriptionArt: self.descriptionArticle.text!, imgLink: resImgUrl)
        }else{
            self.presenter?.updateArticle(titleArt: self.titleArticle.text!, descriptionArt: self.descriptionArticle.text!, imgLink: resImgUrl, id: self.id!)
        }
    }
    func responseData(_ data: [Article], method: String, index: Int) {
        switch method {
        case "GET":
            DispatchQueue.main.async {
                self.thumnailImg.downloadedFrom(link: data[0].image)
                self.titleArticle.text=data[0].title
                self.descriptionArticle.text=data[0].description
                self.myActivityIndicator.stopAnimating()
            }
        case "POST":
            print("Posted")
            myActivityIndicator.stopAnimating()
            DispatchQueue.main.async {
                _=self.navigationController?.popViewController(animated: true)
            }
        case "PUT":
            print("Updated")
            myActivityIndicator.stopAnimating()
            DispatchQueue.main.async {
                _=self.navigationController?.popViewController(animated: true)
            }
        default:
            break;
        }
    }
    func responseDataError() {
        //
    }
}













