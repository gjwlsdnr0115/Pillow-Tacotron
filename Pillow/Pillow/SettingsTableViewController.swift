//
//  SettingsTableViewController.swift
//  Pillow
//
//  Created by Jinwook Huh on 2020/12/20.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var cellKSS: UITableViewCell!
    @IBOutlet weak var cellSon: UITableViewCell!
    @IBOutlet weak var cellHani: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if cellKSS.tag == indexPath.row {
            print("cell \(cellKSS.tag), kss selected")
            cellKSS.accessoryType = UITableViewCell.AccessoryType.checkmark
            cellSon.accessoryType = UITableViewCell.AccessoryType.none
            cellHani.accessoryType = UITableViewCell.AccessoryType.none
            Speaker.shared.speakerName = "kss"
            Speaker.shared.speakerId = "0"
            print(Speaker.shared.speakerId)
        } else if cellSon.tag == indexPath.row {
            print("cell \(cellSon.tag), son selected")
            cellSon.accessoryType = UITableViewCell.AccessoryType.checkmark
            cellKSS.accessoryType = UITableViewCell.AccessoryType.none
            cellHani.accessoryType = UITableViewCell.AccessoryType.none
            Speaker.shared.speakerName = "son"
            Speaker.shared.speakerId = "1"
            print(Speaker.shared.speakerId)
        } else {
            print("cell \(cellHani.tag), hani selected")
            cellHani.accessoryType = UITableViewCell.AccessoryType.checkmark
            cellSon.accessoryType = UITableViewCell.AccessoryType.none
            cellKSS.accessoryType = UITableViewCell.AccessoryType.none
            Speaker.shared.speakerName = "hani"
            Speaker.shared.speakerId = "2"
            print(Speaker.shared.speakerId)
        }
    }
}
