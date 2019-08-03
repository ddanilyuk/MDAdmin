//
//  MergeViewController.swift
//  MDAdmin
//
//  Created by Denis on 8/2/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class MergeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mergeImage: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let procedure: Procedure = Procedure(initials: "", nameProcedure: "", dateProcedure: "", dateProcedureForUser: "", costProcedure: "", imageBeforeURL: "", imageAfterURL: "")
    
    var imageBefore = UIImage()
    var imageAfter = UIImage()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let size = CGSize(width: imageBefore.size.width, height: imageBefore.size.height + imageAfter.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)

        
        imageBefore.draw(in: CGRect(x: 0, y: 0, width: size.width, height: imageBefore.size.height))
        imageAfter.draw(in: CGRect(x: 0, y: imageBefore.size.height, width: size.width, height: imageAfter.size.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //set finalImage to IBOulet UIImageView
        mergeImage.image = newImage
        scrollView.delegate = self

        
        
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mergeImage
    }
    
    @IBAction func didPressShare(_ sender: UIBarButtonItem) {
//        let activityVC = UIActivityViewController(activityItems: [mergeImage?.image ?? UIImage()], applicationActivities: [])
//
//        activityVC.popoverPresentationController?.sourceView = view.self
//
//        self.present(activityVC, animated: true
//            , completion: nil)
//        let image: UIImage = mergeImage.image ?? UIImage()
//        //let data = mergeImage.image?.pngData()
//        var newImage = UIImage()
//
//        let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:true)
//        let unicImageName = "/merge"
//        if let url = documentDirectory?.appendingPathComponent(unicImageName) {
//
//            UIImage.saveImage(image: image, path: url)
//            if let data = try? Data(contentsOf: url) {
//
//                newImage = UIImage(data: data) ?? UIImage()
//            }
//        }


        //share(shareImage: UIImage(named: "1.jpg"))
        share(shareImage: self.mergeImage.image)

    }
    
    
    func share(shareImage: UIImage?){
        
        var objectsToShare = [AnyObject]()
        

        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }else{
            print("There is nothing to share")
        }
    }
    

}



