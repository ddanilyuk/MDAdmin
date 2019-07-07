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
        // Do any additional setup after loading the view.
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return bigImageView
    }
}
