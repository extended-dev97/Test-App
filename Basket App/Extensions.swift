//
//  Extensions.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 02.07.2021.
//
//  Impoterd from Extended Kit by nullpointer97
//

import Foundation
import UIKit

public protocol ViewConfigurable: AnyObject {
    func setupTable()
}

public class GlobalRouter {
    public static let `default`: IsRouter = DefaultRouter()
}

public protocol Navigation { }

public protocol AppNavigation {
    func viewControllerForNavigation(navigation: Navigation) -> UIViewController
    func navigate(_ navigation: Navigation, from: UIViewController, to: UIViewController)
}

public protocol IsRouter {
    func setup(from appNavigation: AppNavigation)
    func navigate(_ navigation: Navigation, from: UIViewController)
    func didNavigate(block: @escaping (Navigation) -> Void)
    var appNavigation: AppNavigation? { get }
}

public extension UIViewController {
    func navigate(_ navigation: Navigation) {
        GlobalRouter.default.navigate(navigation, from: self)
    }
}

public class DefaultRouter: IsRouter {
    public var appNavigation: AppNavigation?
    var didNavigateBlocks = [((Navigation) -> Void)] ()
    
    public func setup(from appNavigation: AppNavigation) {
        self.appNavigation = appNavigation
    }
    
    public func navigate(_ navigation: Navigation, from: UIViewController) {
        if let toVC = appNavigation?.viewControllerForNavigation(navigation: navigation) {
            appNavigation?.navigate(navigation, from: from, to: toVC)
            for b in didNavigateBlocks {
                b(navigation)
            }
        }
    }
    
    public func didNavigate(block: @escaping (Navigation) -> Void) {
        didNavigateBlocks.append(block)
    }
}

// Injection helper
public protocol Initializable { init() }
open class RuntimeInjectable: NSObject, Initializable {
    public required override init() {}
}

public func appNavigationFromString(_ appNavigationClassString: String) -> AppNavigation {
    let appNavClass = NSClassFromString(appNavigationClassString) as! RuntimeInjectable.Type
    let appNav = appNavClass.init()
    return appNav as! AppNavigation
}

enum BasketNavigation: Navigation {
    case products([Item])
    case product(Item)
}

struct BasketAppNavigation: AppNavigation {
    func viewControllerForNavigation(navigation: Navigation) -> UIViewController {
        if let navigation = navigation as? BasketNavigation {
            switch navigation {
            case .products(let items):
                let controller = ProductViewController(items: items)
                controller.title = items[0].productType.rawValue
                return controller
            case .product(let item):
                let controller = DescriptionViewController(model: item)
                controller.title = item.name
                return controller
            }
        }
        return UIViewController()
    }

    func navigate(_ navigation: Navigation, from: UIViewController, to: UIViewController) {
      from.navigationController?.pushViewController(to, animated: true)
    }
}

extension UIViewController {
    func navigate(_ navigation: BasketNavigation) {
        navigate(navigation as Navigation)
    }
}

class Downloader {
    class func load(url: URL, completion: @escaping (URL?) -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"

        let dataTask = session.downloadTask(with: request) { url, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Success: \(statusCode)")
            }
            if let url = url {
                completion(url)
            } else {
                completion(nil)
            }
        }
        dataTask.resume()
    }
}

extension Data {
    var prettyString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }

        return prettyPrintedString
    }
}
