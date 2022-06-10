//
// Created by Mickael Belhassen on 21/03/2022.
//

import Foundation

protocol BackgroundTasksManagerService {
    func syncDataAndNotify()
}

final class BackgroundTasksManager: BackgroundTasksManagerService {
    let synchronizes: [Synchronizable]

    init(synchronizes: [Synchronizable]) {
        self.synchronizes = synchronizes
    }

}

// MARK: - Sync customers

extension BackgroundTasksManager {

    func syncDataAndNotify() {
        Task {
            do {
                for sync in synchronizes {
                    try await sync.serverSyncing()
                    sync.notifySynced()
                }
            } catch {
                // Display error?
            }
        }
    }

}
