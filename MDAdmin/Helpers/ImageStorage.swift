//
//  ImageStorage.swift
//  MDAdmin
//
//  Created by Denis on 7/8/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class ImageStorage {

    static func getClientImage(client: Client, imageView: UIImageView) -> UIImage? {
        let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:true)
        
        if let url = documentDirectory?.appendingPathComponent(client.makeInitials()) {
            if let data = try? Data(contentsOf: url) {
                return UIImage(data: data)
            }
        }
        guard let urlToSever = URL(string: client.imageURL) else { return nil }
        URLSession.shared.dataTask(with: urlToSever, completionHandler: { (data, response, error) in

            //download hit an error so lets return out
            if let error = error {
                print(error)
                return
            }

            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    if let url = documentDirectory?.appendingPathComponent(client.makeInitials()) {
                        UIImage.saveImage(image: downloadedImage, path: url)
                    }
                    imageView.image = downloadedImage
                }
            })

        }).resume()
        return nil
    }
}
