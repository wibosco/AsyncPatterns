//
//  ProcessTableViewCell.swift
//  AsyncPatterns
//
//  Created by Wojciech Chojnacki on 08/11/2016.
//  Copyright © 2016 chojnac.com All rights reserved.
//

import UIKit

enum ProcessState {
    case waiting
    case inprogress
    case cancelled
    case complete(success:Bool)
}

class ProcessTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title:String, state:ProcessState) {
        self.textLabel?.text = title
        switch state {
        case .waiting:
            self.detailTextLabel?.text = "waiting"
        case .inprogress:
            self.detailTextLabel?.text = "in progress"
        case .cancelled:
            self.detailTextLabel?.text = "cancelled"
        case let .complete(success):
            self.detailTextLabel?.text = success ? "success" : "failed"
        }
    }
}
