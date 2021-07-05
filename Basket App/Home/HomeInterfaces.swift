//
//  HomeInterfaces.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 02.07.2021.
//  Copyright (c) 2021 Extended Team. All rights reserved.
//
//  VIPER Module
//

import UIKit

protocol HomeWireframeInterface: WireframeInterface {
    func openProducts(with items: [Item])
}

protocol HomeViewInterface: ViewInterface {
    func data(from data: BasketData)
}

protocol HomePresenterInterface: PresenterInterface {
    func didLoadData()
    func onLoadData(from data: BasketData)
    func didPerform(to products: [Item])
}

protocol HomeInteractorInterface: InteractorInterface {
    func loadData()
}
