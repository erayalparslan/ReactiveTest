//
//  FavoritesViewController.swift
//  RectiveTest
//
//  Created by Eray on 27.01.2019.
//  Copyright © 2019 Eray Alparslan. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class FavoritesViewController: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    var favoriteMovies = [String]() {
        didSet {
            self.mTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mTableView.delegate = self
        mTableView.dataSource = self
        
        
        ref.child("favorites").observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let favoriteMovieDict = child.value as? [String:String] ?? [:]
                if let favMovie = favoriteMovieDict["movie_title"] {
                    self.favoriteMovies.append(favMovie)
                }
            }
            
        }
    }
    
    


}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = favoriteMovies[indexPath.row]
        return cell!
    }
    
    
}
