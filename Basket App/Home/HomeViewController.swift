//
//  HomeViewController.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 02.07.2021.
//  Copyright (c) 2021 Extended Team. All rights reserved.
//
//  VIPER Module
//

import UIKit

final class HomeViewController: UIViewController, ViewConfigurable {
    var mainTable: UITableView = {
        return $0
    }(UITableView())
    
    var basket: [ProductType] = []
    var items: [Item] = []
    
    // MARK: - Public properties -

    var presenter: HomePresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        presenter.didLoadData()
    }

    // Настройка таблицы
    func setupTable() {
        title = "Продукты"
        view.addSubview(mainTable)
        mainTable.frame = view.bounds

        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        mainTable.separatorInset = .init(top: 0, left: -UIScreen.main.bounds.width, bottom: 0, right: UIScreen.main.bounds.width)
    }
    
    func data(from data: BasketData) {
        self.basket.append(contentsOf: data.response.types)
        items.append(contentsOf: data.response.items)
        
        DispatchQueue.main.async { [weak self] in
            self?.mainTable.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = basket[indexPath.row].rawValue
        cell.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didPerform(to: items.filter { $0.productType == basket[indexPath.row] })
    }
}

// MARK: - Extensions -

extension HomeViewController: HomeViewInterface {
}
