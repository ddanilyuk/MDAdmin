//
//  BigPictureViewController.swift
//  MDAdmin
//
//  Created by Denis on 7/4/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class BigPictureViewController: UIViewController, UIScrollViewDelegate {

    var myImage: UIImage = UIImage()
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigImageView.image = myImage
        scrollView.delegate = self
    }
    
    @IBAction func swipeUP(_ sender: UISwipeGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeDOWN(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    //Mark: - enable zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return bigImageView
    }
    
    
}
