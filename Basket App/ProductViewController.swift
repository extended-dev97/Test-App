//
//  ProductViewController.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 02.07.2021.
//

import Foundation
import UIKit

class ProductViewController: UIViewController, ViewConfigurable {
    var mainTable: UITableView = {
        return $0
    }(UITableView())

    var items: [Item] = []
    
    init(items: [Item]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    // Настройка таблицы
    func setupTable() {
        view.addSubview(mainTable)
        mainTable.frame = view.bounds

        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        mainTable.separatorInset = .init(top: 0, left: -UIScreen.main.bounds.width, bottom: 0, right: UIScreen.main.bounds.width)
        
        mainTable.reloadData()
    }
}

extension ProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.item].name
        cell.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return cell
    }
}

extension ProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigate(.product(items[indexPath.item]))
    }
}
