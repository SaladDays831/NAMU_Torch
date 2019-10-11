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
    
    let sectionItems = ["Почати екскурсію з початку", "Показати ґайд", "Картини", "Змінити мову", "3D мапа NAMU", "Як дістатися до NAMU", "Контакти", "Залишити відгук"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    

 
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentOnboardingRestartAlert() {
        let alert = UIAlertController(title: "Показати ґайд", message: "Пройти ґайд ще раз?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Так", style: UIAlertAction.Style.default, handler: { action in
            let onbVC = self.onboardingVC.createOnboardingVC()
            onbVC.modalPresentationStyle = .overFullScreen
            onbVC.presentFrom(self, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Видмина", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension OtherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sectionItems[indexPath.row]
        
        
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
            print("lang")
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