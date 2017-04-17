//
//  DetailViewController.swift
//  Swift3URLSessionJSON
//
//  Created by Matthew Singleton on 4/17/17.
//  Copyright © 2017 Matthew Singleton. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var imgVw: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var authorLbl: UILabel!
  
  var potterBook: Potter?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    updateUI()
  }
  
  
  func updateUI() {
    
    
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
          self.imgVw?.image = UIImage(data: data)
        }
      }
    }
    
    if let checkedURL = URL(string: (potterBook?.imageURL)!) {
      downloadImage(url: checkedURL)
    }
    
    titleLbl.text = potterBook?.title ?? ""
    authorLbl.text = potterBook?.author ?? ""
    
  }
  
  
  @IBAction func backTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  
}
