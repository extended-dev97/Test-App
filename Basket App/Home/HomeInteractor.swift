//
//  HomeInteractor.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 02.07.2021.
//  Copyright (c) 2021 Extended Team. All rights reserved.
//
//  VIPER Module
//

import Foundation
import SwiftyJSON

final class HomeInteractor {
    weak var presenter: HomePresenterInterface?
    
    let jsonURL = "https://s711sas.storage.yandex.net/rdisk/ba2accdf5f817ec7c9e320244f6932e7ab3f8ce384a112b3ec0003b3d35cf1fd/60e3097c/I8_q036XCoEduDSdIbxLvzv7ta6MfmNfzTGa5SiBifxrfukLWEkIw-fGFqVhFB1qsMg3Tm7EVLlA6l-PbCd__g==?uid=0&filename=basket.json&disposition=attachment&hash=qR6Bo3E/uvxYTtWvDk5lqTXhSq6Yi0LA8ds5h1dR7hfGkXjT8WOOWXvAoZnE%2BAxoq/J6bpmRyOJonT3VoXnDag%3D%3D&limit=0&content_type=text%2Fplain&owner_uid=350220000&fsize=12108&hid=57c2a9fe908077c19fa37115305a1eba&media_type=text&tknv=v2&rtoken=aGnZr3F7tL7j&force_default=no&ycrid=na-2e3f4e32fd4488d7f734cb872f77f9b3-downloader2f&ts=5c6604f785700&s=b7a0df106c98c33bab6e97aa4f888244214fc48d31f4ec681f7812813fbf1afa&pb=U2FsdGVkX18dGqD7R7PvFmJjdtInqRcXoRaBttEEgKsY1Pg2PNCJNRHpq1O4FKrZGNParh37liLuHKeh50VZuYr2WAWIPaPZVbPKHDe7u3g"
}

// MARK: - Extensions -

extension HomeInteractor: HomeInteractorInterface {
    func loadData() {
        DispatchQueue.global(qos: .background).async {
            Downloader.load(url: URL(string: self.jsonURL)!) { [weak self] tempUrl in
                guard let url = tempUrl else { return }
                do {
                    let string = try String(contentsOf: url, encoding: .utf8)
                    let data = string.data(using: .utf8)
                    let models = try JSONDecoder().decode(BasketData.self, from: data ?? Data())
                    self?.presenter?.onLoadData(from: models)
                } catch {
                    print(error)
                }
            }
        }
    }
}
