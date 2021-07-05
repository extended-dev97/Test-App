//
//  DescriptionViewController.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 05.07.2021.
//

import UIKit

class DescriptionViewController: UIViewController {
    @IBOutlet weak var itemImageView: UIImageViewLoader!
    @IBOutlet weak var itemTextView: UITextView!
    
    var modelItem: Item?

    init(model: Item) {
        modelItem = model
        super.init(nibName: "DescriptionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemImageView.layer.cornerRadius = 12
        itemImageView.layer.borderWidth = 0.4
        if #available(iOS 13.0, *) {
            itemImageView.layer.borderColor = UIColor.secondaryLabel.cgColor
        } else {
            itemImageView.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if let item = modelItem {
            itemImageView.loadImage(with: item.url)
            itemTextView.text = item.info
        } else {
            print("Model not found (404)!")
        }
    }
}
