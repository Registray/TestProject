//
//  TestTableViewController.swift
//  TestProject
//
//  Created by mac on 11/23/20.
//

import UIKit

class TestTableViewController: UITableViewController {
    
    var articles: [News]? = []
    var source = "bbc-news"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles(fromSource: source)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    @IBAction func refreshControl(_ sender: UIRefreshControl) {
        fetchArticles(fromSource: source)
        sender.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    func fetchArticles(fromSource provider: String) {
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=\(provider)&apiKey=37f88db8934f4d4a8a94ee7fc50f310b")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            
            self.articles = [News]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let article = News()
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String, let description = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.descrip = description
                            article.title = title
                            article.url = url
                            article.imageURL = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.articles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "web") as WebViewController
        
        webVC.url = self.articles?[indexPath.item].url
        
        self.present(webVC, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! NewsTableViewCell
        
        cell.titleLabel.text = self.articles?[indexPath.item].title
        cell.descriptionLabel.text = self.articles?[indexPath.item].descrip
        cell.authorLabel.text = self.articles?[indexPath.item].author
        
        let imageData = self.articles?[indexPath.item].imageURL
        
        if imageData != nil {
            cell.newsImageView?.downloadImage(from: imageData!)
            cell.descriptionLabel.sizeToFit()
            cell.authorLabel.sizeToFit()
            
            cell.newsImageView.layer.cornerRadius = 10
            cell.backgroundColor = .systemGray3
            
        }
        
        return cell
    }
    
    let menuMenager = MenuManager()
    @IBAction func menuActionButton(_ sender: Any) {
        
        menuMenager.openMenu()
        menuMenager.mainVC = self
        
    }
    
    let countryManager = CountryManager()
    @IBAction func countryActionButton(_ sender: Any) {
        countryManager.openCountry()
        countryManager.myMainVC = self
    }
    
    
    
}


extension UIImageView {
    
    func downloadImage(from url: String) {
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
