//
//  ContactsViewController.swift
//  NAMU_Torch
//
//  Created by Danil Kurilo on 19.10.2019.
//  Copyright © 2019 Danil Kurilo. All rights reserved.
//

import UIKit
import MessageUI

class ContactsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
    
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
    
        }
    }

    
    
    @IBAction func adressPressed(_ sender: UIButton) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
          UIApplication.shared.openURL(URL(string:
            "comgooglemaps://?daddr=National+Art+Museum+of+Ukraine,+6,+Mykhaila+Hrushevskoho+St,+Kyiv,+01001")!)
        } else {
            UIApplication.shared.openURL(URL(string:"https://goo.gl/maps/enwEkMRRYxwUiu7Q7")!)
          print("Can't use comgooglemaps://");
        }
    }
    
    
    @IBAction func phone1Pressed(_ sender: UIButton) {
        makePhoneCall(phoneNumber: "+380442781357")
    }
    
    @IBAction func phone2Pressed(_ sender: UIButton) {
        makePhoneCall(phoneNumber: "+380442787454")
    }
    
    
    @IBAction func emailPressed(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            
            let alert = UIAlertController(title: "Надіслати лист у NAMU", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Так", style: .default, handler: { (action) in
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["info@namu.kiev.ua"])
                //mail.setSubject("Poof feedback")
                
                self.present(mail, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            return
        }
    }
    
    
    @IBAction func fbButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: "https://www.facebook.com/namu.museum/") else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func instaButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: "https://www.instagram.com/kurilodanil/") else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func websiteButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: "http://namu.kiev.ua/ua/about/history.html") else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
