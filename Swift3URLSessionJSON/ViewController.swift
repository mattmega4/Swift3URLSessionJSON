//
//  ViewController.swift
//  Swift3URLSessionJSON
//
//  Created by Matthew Singleton on 4/17/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let POTTER_URL = "http://de-coding-test.s3.amazonaws.com/books.json"
  var books = [Potter]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    downloadJSON()
  }
  
  // MARK: Pull JSON
  
  func downloadJSON() {
    
    let url = URL(string: POTTER_URL)
    let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
      
      if error != nil {
        print("error")
      } else {
        do {
          if let bookData = try JSONSerialization.jsonObject(with: data!) as? [[String: String]] {
            self.books.removeAll()
            for book in bookData {
              let title = book["title"] ?? ""
              let author = book["author"] ?? ""
              let imgURL = book["imageURL"] ?? ""
              self.books.append(Potter(title: title, author: author, imageURL: imgURL))
            }
            DispatchQueue.main.sync {
              self.tableView.reloadData()
            }
          }
        }
        catch {
          print("Serialization error", error)
        }
      }
    }
    task.resume()
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "fromViewControllerToDetailVC" {
      
      if let detailsVC = segue.destination as? DetailViewController {
        
        if let pttr = sender as? Potter  {
          
          detailsVC.potterBook = pttr
          
        }
      }
    }
  }
  
  
} // End


extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return books.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PotterTableViewCell {
      
      let potter = books[indexPath.row]
      
      //MARK: Pull Image
      
      func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
          (data, response, error) in
          completion(data, response, error)
          }.resume()
      }
      
      func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
          guard let data = data, error == nil else { return }
          print(response?.suggestedFilename ?? url.lastPathComponent)
          print("Download Finished")
          DispatchQueue.main.async() { () -> Void in
            cell.imgView?.image = UIImage(data: data)
          }
        }
      }
      
      if let checkedURL = URL(string: potter.imageURL) {
        downloadImage(url: checkedURL)
      }
      
      cell.titleLabel.text = potter.title
      
      return cell
      
    } else {
      return PotterTableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let pote: Potter = books[indexPath.row]
    
    performSegue(withIdentifier: "fromViewControllerToDetailVC", sender: pote)
    
  }
  
  
}

