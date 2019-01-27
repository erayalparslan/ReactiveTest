//
//  ViewController.swift
//  RectiveTest
//
//  Created by Eray on 26.01.2019.
//  Copyright © 2019 Eray Alparslan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mSearchBar: UISearchBar!
    
    
    var movies = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        ref = Database.database().reference()
        
        
        
        mSearchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .filter{!$0.isEmpty}
            .debounce(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                query in
                let url = API_URL + API_KEY + "&s=" + query
                
                Alamofire.request(url).responseJSON(completionHandler: { response in
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        self.movies.removeAll()
                        
                        for movie in json["Search"] {
                            if let title = movie.1["Title"].string {
                                self.movies.append(title)
                            }
                        }
                    }
                })
                
                self.mTableView.reloadData()
        })
    }


    @IBAction func bookmarksDidTap(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "details", sender: nil)
    }
    
    
    
    
    
    
    func setDelegates(){
        mTableView.delegate   = self
        mTableView.dataSource = self
    }
    
    
    
    
 
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mTableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = movies[indexPath.row ]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        ref.child("favorites").childByAutoId().setValue(["movie_title" : selectedMovie])
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}
