//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Hassan Qureshi on 8/27/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

   
    @IBOutlet weak var checkUncheckImage: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var completeLineLabel: UILabel!
    @IBOutlet weak var completeLineWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 16
        bgView.dropShadow(color: UIColor(hexString: "F3F5F7")!,
                                                 opacity: 0.18, offSet: .zero, radius: 4, scale: true)
        
    }
    
    func populateData(indexPath: IndexPath) {
        let task = CoredataService.shared.fetchTask()
        taskLabel.text = task[indexPath.row].title
        checkUncheckImage.image = task[indexPath.row].isCompleted ? UIImage(named: "check") : UIImage(named: "uncheck")
        completeLineLabel.isHidden = task[indexPath.row].isCompleted ? false : true
        completeLineWidthConstraint.constant = taskLabel.intrinsicContentSize.width
        bgView.backgroundColor = task[indexPath.row].isCompleted ? UIColor(hexString: "#1F618D") : UIColor(hexString: "#EAEDED")
        taskLabel.textColor = task[indexPath.row].isCompleted ? UIColor(hexString: "ffffff") : UIColor(hexString: "#000000")
    }
}
