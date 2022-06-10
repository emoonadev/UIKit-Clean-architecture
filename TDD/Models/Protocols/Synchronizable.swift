//
// Created by Mickael Belhassen on 05/05/2022.
//

import Foundation

protocol Synchronizable {
    func serverSyncing() async throws
    func notifySynced()
}

