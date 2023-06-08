// MainTableViewCell.swift



import UIKit

final class TableViewCell: UITableViewCell {
    private static let reuseId = "PhotoThumbnailCell"
    var onComplete: () -> Void = {}
    private let titleLabel = UILabel()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .lightGray
        return label
    }()
    
    
    private lazy var doneButton: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.onComplete()
        }
       let button = UIButton(primaryAction: action)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.tintColor = .systemGreen
        return button
    }()
    
    lazy var image: UIView = {
        let scrool = UIView()
        scrool.backgroundColor = .black
        scrool.isHidden = true
        return scrool
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(presOnButton), for: .allTouchEvents)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        setupLayout()
    }
    
    @objc func presOnButton() {
        image.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func registerWithTableView(tableView: UITableView) {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: reuseId)
    }

    static func getReusedCellFrom(tableView: UITableView, cellForItemAt indexPath: IndexPath) -> TableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? TableViewCell
        cell?.backgroundColor = .systemGray5
        cell?.layer.cornerRadius = 8
        return cell!
    }
    

    func setup(with task: ToDoTask?) {
        guard let task else { return }
        titleLabel.text = task.title
        dateLabel.text = getTextFromDate(task.date)
    }

    private func getTextFromDate(_ date: Date?) -> String  {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm/dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(doneButton)
        addSubview(editButton)
        addSubview(image)

        image.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            doneButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.leadingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -50),
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 2)
            
        ])
    }
}
