//
//  ReminderCell.swift
//  ToDoList
//
//  Created by Metehan Gürgentepe on 28.08.2024.
//

import UIKit

class ReminderCell: UITableViewCell {
    static let identifier = "ReminderCell"
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).withSize(20)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .label
        return label
    }()
    
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .label
        return label
    }()
    
    var cellViewModel: ReminderCellViewModel? {
        didSet {
            titleLabel.text = cellViewModel?.title
            dateLabel.text = cellViewModel?.date.dayAndTimeText
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-2)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
