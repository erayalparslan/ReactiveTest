//
//  ViewController.swift
//  RectiveTest
//
//  Created by Eray on 26.01.2019.
//  Copyright © 2019 Eray Alparslan. All rights reserved.
//

import UIKit
import RxSwift





class ViewController: UIViewController {
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mSearchBar: UISearchBar!
    
    
    let movies = ["Harry Potter", "Star Wars",
                  "Lord Of The Rings", "Forrest Gump"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        
        
        
        let numbers = Variable([1,2,3,4,5,6,7,8,9,10])
        
        numbers.asObservable()
            .throttle(5, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                element in
                print(element)
        })
        numbers.value.append(600)
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
}
