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
    
    var imgThum:UIImagePickerController!
    var presenter:ArticlePresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Add article"
        imgThum=UIImagePickerController()
        imgThum.delegate=self
        presenter=ArticlePresenter()
        presenter?.delegate=self
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
        print("202")
        presenter?.postArticle(titleArt: titleArticle.text!, descriptionArt: descriptionArticle.text, imgLink: "https://pbs.twimg.com/profile_images/689302419952422912/KhGmx7aj_400x400.jpg")
    }

    @IBAction func cancelPress(_ sender: UIBarButtonItem) {
        _=navigationController?.popViewController(animated: true)
    }
}

extension AddArticleViewController:ArticlePresenterProtocol{
    
    func startFetchArticle() {
        //
    }
    
    func responseData(_ data: [Article], method: String, index: Int) {
        _=navigationController?.popViewController(animated: true)
    }
    
    func responseDataError() {
        //
    }
    
}
