//
//  OtherViewController.swift
//  NAMU_Torch
//
//  Created by Danil Kurilo on 9/26/19.
//  Copyright © 2019 Danil Kurilo. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let onboardingVC = OnboardingViewController.shared
    
    let sectionItems = ["Розпочати AR екскурсію з початку", "Як користуватися додатком", "Список картин", "3D модель церкви Вознесіння", "3D мапа музею", "Як дістатися до музею", "Контакти", "Залишити фідбек"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.tableFooterView = UIView()
        
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
        
        tableView.rowHeight = 80
    }
    

 
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentOnboardingRestartAlert() {
        let alert = UIAlertController(title: "Як користуватися додатком", message: "Пройти ґайд ще раз?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Так", style: UIAlertAction.Style.default, handler: { action in
            let onbVC = self.onboardingVC.createOnboardingVC()
            onbVC.modalPresentationStyle = .overFullScreen
            onbVC.presentFrom(self, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Скасувати", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension OtherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "NAMU-1960", size: 16.0)
        cell.textLabel?.text = sectionItems[indexPath.row]
        
        if indexPath.row == 3 || indexPath.row == 4 {
            cell.isUserInteractionEnabled = false
            cell.textLabel?.isEnabled = false
            cell.detailTextLabel?.isEnabled = false
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            print("start over")
        case 1:
            print("onboarding restart")
            presentOnboardingRestartAlert()
        case 2:
            print("arts")
            performSegue(withIdentifier: "toArts", sender: self)
        case 3:
            print("church 3D")
        case 4:
            print("3d map")
        case 5:
            print("how to get to NAMU")
        case 6:
            print("contacts")
        case 7:
            print("feedback")
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
