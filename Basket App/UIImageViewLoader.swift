//
//  UIImageViewLoader.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 05.07.2021.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class UIImageViewLoader: UIImageView {
    var imageURL: URL?
    let activityIndicator = UIActivityIndicatorView()
    var errorLabel: UILabel = {
        $0.textColor = .systemRed
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel()) {
        didSet {
            errorLabel.isHidden = errorLabel.text == nil
        }
    }

    func loadImage(with url: URL) {
        activityIndicator.color = .darkGray

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true

        imageURL = url

        image = nil
        activityIndicator.startAnimating()

        // извлекает изображение, если оно уже есть в кеше
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"

        // изображение не доступно в кеше ... поэтому получение его по URL ...
        let dataTask = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self?.activityIndicator.stopAnimating()
                    self?.errorLabel.text = error?.localizedDescription
                })
                return
            }

            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    self?.errorLabel.text = nil
                    if self?.imageURL == url {
                        self?.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self?.activityIndicator.stopAnimating()
            })
        })
        
        dataTask.resume()
    }
}
