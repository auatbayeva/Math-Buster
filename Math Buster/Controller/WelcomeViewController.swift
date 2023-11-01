//
//  WelcomeViewController.swift
//  Math Buster
//
//  Created by Айбану Уатбаева on 27.09.2023.
//

import UIKit

class WelcomeViewController: UIViewController{
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource:[userScoreSection] = []{
        didSet {
            print("Value of variable 'dataSource' was changed")
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: ScoreTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self, action: #selector(getUserScore), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserScore()
    }
    @objc
    func getUserScore(){
        tableView.refreshControl?.endRefreshing()
        var easyScoreList = ViewController.getAllUserScores(level: .easy)
        easyScoreList.sort(by: { $0.score > $1.score })
        let easySection = userScoreSection(list: easyScoreList, title: "Easy")
        
        var mediumScoreList = ViewController.getAllUserScores(level: .medium)
        mediumScoreList.sort(by: { $0.score > $1.score })
        let mediumSection = userScoreSection(list: mediumScoreList, title: "Medium")
        
        var hardScoreList = ViewController.getAllUserScores(level: .hard)
        hardScoreList.sort(by: { $0.score > $1.score })
        let hardSection = userScoreSection(list: hardScoreList, title: "Hard")
        
        self.dataSource = [easySection, mediumSection, hardSection]
        
        
    }
    
    func getSingleUserText(indexPath: IndexPath)->String?{
        
        let userScore: UserScore = dataSource[indexPath.section].list[indexPath.row]
        let text = "Name: \(userScore.name) Score:\(userScore.score)"
        return text
    }

}

//MARK: UITableViewDataSource & UITableViewDelegate
extension WelcomeViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as! ScoreTableViewCell
        cell.scoreTextLabel.text = getSingleUserText(indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = ScoreDetailViewController()
        viewController.text = getSingleUserText(indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
}
struct userScoreSection {
    let list: [UserScore]
    let title: String
    
}
