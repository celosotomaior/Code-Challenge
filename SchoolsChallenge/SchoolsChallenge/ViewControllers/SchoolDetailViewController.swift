//
//  SchoolDetailViewController.swift
//  SchoolsChallenge
//
//  Created by Marcelo Sotomaior on 16/07/2021.
//

import UIKit

class SchoolDetailViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    var selectedSchool : School!

   
    var activityIndicator  = UIActivityIndicatorView()
    var textLoad = UILabel()
    var messageFrame = UIView()
    var score: [ScoreOnSAT] = []
    var grade: ScoreOnSAT!
    var school: School? {
        didSet {
            if let schooldbn = school!.dbn {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.tableView.dataSource = self
     
        registerNibs()
      
        if (selectedSchool != nil) {
            print("Selected School != nil")
            fetchSAT()
        }
        
        
        tableView.rowHeight = CGFloat(700)
        tableView.estimatedRowHeight = UITableView.automaticDimension
    
        
    }
    
    func fetchSAT() {
       
        
        self.showActivityIndicator(_sender: self)
        Networking().getScoreData { (SATscoresBySchool:[ScoreOnSAT]?,error:Error?) in
            
            if let SATscoresBySchool = SATscoresBySchool {
                self.score = []
                self.score = SATscoresBySchool
                let selectedDbn = self.selectedSchool?.dbn as! String
               self.satScoreForSchool(schoolGrades: selectedDbn)
              
            }else {
                DispatchQueue.main.async {
                self.DisplayAlert(errorDescription: (error?.localizedDescription)!)
                }
            }
            DispatchQueue.main.async {
                self.hideActiviyAndResumeTask(_sender: self)
                
            }
            
            
        }
    }
    
    func satScoreForSchool(schoolGrades: String? ) {
        
        guard schoolGrades != nil else { return }
        
        let search = score.filter { (item: ScoreOnSAT ) -> Bool in
            let element = item.dbn
            return ((element?.range(of: schoolGrades!, options: .caseInsensitive, range: nil, locale: nil)) != nil)
        }
        
        if search.count > 0 {
            
        let returnSATScore = search[0]
        
        self.selectedSchool?.satScore = ScoreOnSAT(dbn: returnSATScore.dbn!, numOfSatTestTakers: returnSATScore.numOfSatTestTakers, satCriticalReadingAvgScore: returnSATScore.satCriticalReadingAvgScore!, satMathAvgScore: returnSATScore.satMathAvgScore, satWritingAvgScore: returnSATScore.satWritingAvgScore, schoolName: returnSATScore.schoolName)
        }
    }
    
    func showActivityIndicator(_sender:Any){
        
        textLoad = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        textLoad.text = "loading SATScores "
        textLoad.textColor = UIColor.white
        textLoad.font = UIFont(name: "Avenir Next", size: 14.0)
  
        
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 200, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor.init(hexString: "#2F5D62")
        
    
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.color = UIColor.white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(textLoad)
        view.addSubview(messageFrame)
       
        //stop ignoring application
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    // MARK: - Register Nibs
    
    private func registerNibs() {
     
        self.tableView.register(UINib(nibName: DetailTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
        self.tableView.register(UINib(nibName: MapTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MapTableViewCell.reuseIdentifier)
      
    }
    
    /**
     *Hide Overview Label in Landscape
     * @param: none
     */
  
    /**
     *Hide  loading animated view and resume activity
     * @param: none
     */
    func hideActiviyAndResumeTask(_sender:Any) {
        
        self.activityIndicator.stopAnimating()
        self.messageFrame.removeFromSuperview()
        
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    

    /**
     *Display Error on screen and handle cancel action
     * @param: errorDescription string
     */
    func DisplayAlert(errorDescription:String) {
        
        let alertController = UIAlertController(title: "Cannot Load  Schools", message: errorDescription, preferredStyle: .alert)
        
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Try again", style: .cancel) { (action) in
            
            // handle cancel response here. Doing nothing will dismiss the view.
            self.fetchSAT()
            
        }
        
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        
        self.hideActiviyAndResumeTask(_sender: self)
        present(alertController, animated: true) {
            // can add  code for what happens after the alert controller has finished presenting
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        switch indexPath.row {
        case 0: return CGFloat(700)
        case 1: return CGFloat(270)
        default:
            return CGFloat(700)
        }
      
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as? DetailTableViewCell
        cell?.setUpWith(school: self.selectedSchool, score: self.selectedSchool.satScore)
        return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.reuseIdentifier, for: indexPath) as! MapTableViewCell
            cell.setUpWith(school: self.selectedSchool)
            cell.openMapToGPSButton.addTarget(self, action: #selector(SchoolDetailViewController.openMapTapped(sender:)), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - GPS Selection from Address
    
    @objc func openMapTapped(sender: UIButton) {
        let installedNavigationApps = ["Apple Maps" : "http://maps.apple.com"]
        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        for (mapName, mapAddress) in installedNavigationApps {
            let schlat = self.selectedSchool.latitude ?? "0.0"
            let schlon = self.selectedSchool.longitude ?? "0.0"
            
            guard
                let latitude = Double(schlat), let longitude = Double(schlon) else { return }

            if latitude == 0.0 && longitude == 0.0 {
                let errorAlert = AlertMessage.error(for: "Could not find latitude and longitude for the school address")
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            let button = UIAlertAction(title: mapName, style: .default) {  (action) in
                let schoolURL = URL(string: "\(mapAddress)?saddr=&daddr=\(latitude),\(longitude))&directionsmode=driving")
                if UIApplication.shared.canOpenURL(schoolURL!) {
                    UIApplication.shared.open(schoolURL!, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(button)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}
