//
//  HomePresenter.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 02.07.2021.
//  Copyright (c) 2021 Extended Team. All rights reserved.
//
//  VIPER Module
//

import Foundation

final class HomePresenter {

    // MARK: - Private properties -

    private unowned let view: HomeViewInterface
    private let interactor: HomeInteractorInterface
    private let wireframe: HomeWireframeInterface

    // MARK: - Lifecycle -

    init(view: HomeViewInterface, interactor: HomeInteractorInterface, wireframe: HomeWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension HomePresenter: HomePresenterInterface {
    func didLoadData() {
        interactor.loadData()
    }
    
    func onLoadData(from data: BasketData) {
        view.data(from: data)
    }
    
    func didPerform(to products: [Item]) {
        wireframe.openProducts(with: products)
    }
}
