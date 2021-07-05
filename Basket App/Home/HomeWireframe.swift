//
//  HomeWireframe.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 02.07.2021.
//  Copyright (c) 2021 Extended Team. All rights reserved.
//
//  VIPER Module
//

import UIKit

final class HomeWireframe: BaseWireframe<HomeViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = HomeViewController()
        super.init(viewController: moduleViewController)

        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
        interactor.presenter = presenter
    }

}

// MARK: - Extensions -

extension HomeWireframe: HomeWireframeInterface {
    func openProducts(with items: [Item]) {
        viewController.navigate(.products(items))
    }
}
