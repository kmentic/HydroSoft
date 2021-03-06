//
//  ViewController.swift
//  HydroSoft
//
//  Created by Filip Kment on 01.06.18.
//  Copyright © 2018 Filip Kment. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]() {
        didSet {
            posts.sort(by: {$0.date > $1.date})
            tableView.reloadData()
        }
    }
    let userDefaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        loadPosts()
    
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordCells.self)
       
    }
    
    func savePosts() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: posts)
        userDefaults.set(encodedData, forKey: "posts")
        userDefaults.synchronize()
    }
    
    func removePosts() {
        userDefaults.removeObject(forKey: "posts")
        userDefaults.synchronize
    }
    
    func getData() {
        Service.sharedInstance.getRecords { (posts) in
            for post in posts {
                self.posts = self.posts.filter({$0.name != post.name})
                self.posts.append(post)
            }
            self.tableView.reloadData()
        }
    }
    
    func loadPosts() {
        if let decoded  = userDefaults.object(forKey: "posts") as? Data {
            if let decodedPosts = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Post] {
                posts = decodedPosts
                getData()
                tableView.reloadData()
            }
        } else {
            getData()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destation = segue.destination as? RecordViewController {
            if let post = sender as? Post {
                destation.post = post
            }
            destation.delegate = self
        }
        
    }
    
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowRecord", sender: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
}

extension ViewController: RecordVCProtocol {
    func saveAndSend(post: Post) {
        Service.sharedInstance.upload(Record: post) {
            self.loadPosts()
        }
    }
    
    func edited(post: Post) {
        if let index = posts.index(where: { $0.id == post.id}) {
            posts.remove(at: index)
            posts.append(post)
            removePosts()
            savePosts()
            tableView.reloadData()
        }
    }
    
    func saved(post: Post) {
        posts.append(post)
        removePosts()
        savePosts()
        tableView.reloadData()
    }
    
    
}
    
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as RecordCells
         cell.configureCell(post: posts[indexPath.row])
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowRecord", sender: posts[indexPath.row])
    }
}


