//
//  TabController.swift
//  TopFavs
//
//  Created by Consultant on 5/12/22.
//

import UIKit
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.barTintColor = UIColor .black
        self.tabBar.isTranslucent = false
        self.tabBar.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = AlbumListViewController(viewModel: AlbumListViewModel())
        let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "inverseTop")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "top")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        tabOneBarItem.imageInsets = UIEdgeInsets(top: 95, left: 95, bottom: 95, right: 95)
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = FavsViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "favorite")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "inverseFav")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        tabTwoBarItem2.imageInsets = UIEdgeInsets(top: 105, left: 105, bottom: 105, right: 105)
        tabTwo.tabBarItem = tabTwoBarItem2
        self.viewControllers = [tabOne, tabTwo]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is AlbumListViewController {
            self.tabBar.barTintColor = UIColor .black
            
            let secondTab = viewControllers?[1] as? FavsViewController
        
            
            let firstTab = viewControllers?[0] as? AlbumListViewController
            firstTab?.albumListViewModel = secondTab?.albumListViewModel as? AlbumListViewModel ?? AlbumListViewModel()
        }
        if viewController is FavsViewController {
            let firstTab = viewControllers?[0] as? AlbumListViewController
        
            
            let secondTab = viewControllers?[1] as? FavsViewController
            secondTab?.test = "worked"
            secondTab?.albumListViewModel = firstTab?.albumListViewModel as? AlbumListViewModel ?? AlbumListViewModel()

            self.tabBar.barTintColor = UIColor .white
            self.tabBar.backgroundColor = UIColor .white
        }
    }
}
