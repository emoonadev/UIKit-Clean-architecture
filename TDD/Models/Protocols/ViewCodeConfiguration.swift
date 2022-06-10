//
// Created by Mickael Belhassen on 06/05/2022.
//

import Foundation

protocol ViewCodeConfiguration {
    func buildHierarchy()
    func setupConstraints()
    func configureViews()
}

extension ViewCodeConfiguration {
    func configureViews() {}

    func applyViewCode() {
        buildHierarchy()
        setupConstraints()
        configureViews()
    }
}
