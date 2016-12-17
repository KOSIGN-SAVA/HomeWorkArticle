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
//        main.postArticleFromMain(titleArti: titleArticle.text!, descArti: descriptionArticle.text!, imgArti: "https:static-secure.guim.co.uk/sys-images/Guardian/Pix/pictures/2013/12/10/1386683878775/POL-POT-006.jpg")
//        _=navigationController?.popViewController(animated: true)
        
        presenter?.postArticle(titleArt: titleArticle.text!, descriptionArt: descriptionArticle.text!, imgLink: "http://i2.mirror.co.uk/incoming/article8372768.ece/ALTERNATES/s810/Pogba-United-main.jpg")
        //_=navigationController?.popViewController(animated: true)
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
//        let sender=UIBarButtonItem()
//        cancelPress(sender)
        DispatchQueue.main.async {
            _=self.navigationController?.popViewController(animated: true)
        }
        print("ff")
    }
    func responseDataError() {
        //
    }
}













