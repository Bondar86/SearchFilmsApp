//
//  ViewControllerCell.swift
//  SearchFilmsApp
//
//  Created by Иван Бондаренко on 18.09.2023.
//

import UIKit

final class ViewControllerCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let labelImageInsets: CGFloat = 16
        static let labelImageWidth: CGFloat = 40
        static let labelHeaderInset: CGFloat = 30
        static let labelTextInset: CGFloat = 10
    }
    
    // MARK: - Public properties
    
    lazy var labelHeader: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = R.Fonts.systemHeading.withSize(15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var labelText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = R.Fonts.systemText.withSize(13)
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var labelImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var movieURL: Movies! {
        didSet {
            let movieURL = movieURL.posterUrl
            let queue = DispatchQueue.global(qos: .userInteractive)
            queue.async {
                guard let urlImage = URL(string: movieURL) else {return}
                URLSession.shared.dataTask(with: urlImage) {data, response, error in
                    if let data = data,
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.labelImage.image = image
                        }
                    }
                }.resume()
            }
        }
    }
    
    // MARK: - Public method
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelImage.image = nil
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    
    private func setupView() {
        contentView.addSubview(labelImage)
        contentView.addSubview(labelHeader)
        contentView.addSubview(labelText)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        labelImage.widthAnchor.constraint(equalToConstant: Constants.labelImageWidth),
        labelImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelImageInsets),
        labelImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelImageInsets),
        labelImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelImageInsets),
        
        labelHeader.leadingAnchor.constraint(equalTo: labelImage.trailingAnchor, constant: Constants.labelHeaderInset),
        labelHeader.topAnchor.constraint(equalTo: labelImage.topAnchor),
        labelHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.labelImageInsets),
        
        labelText.leadingAnchor.constraint(equalTo: labelHeader.leadingAnchor),
        labelText.topAnchor.constraint(equalTo: labelHeader.bottomAnchor, constant: Constants.labelTextInset),
        labelText.trailingAnchor.constraint(equalTo: labelHeader.trailingAnchor)
        ])
    }
}
