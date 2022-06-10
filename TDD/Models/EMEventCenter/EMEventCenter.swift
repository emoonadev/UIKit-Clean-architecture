//
// Created by Mickael Belhassen on 04/05/2022.
//

import Foundation

protocol EMEventCenterDelegate: AnyObject {
    func appDataSynced()
}

extension EMEventCenterDelegate {
    func appDataSynced() {}
}

protocol EventCenterService {
    func addObserver(_ delegate: EMEventCenterDelegate)
    func removeObserver(_ delegate: EMEventCenterDelegate)
    var post: EMEventCenterDelegate { get }
}

final class EMEventCenter {
    static let shared: EventCenterService = EventCenter.shared
    private init() {}
}

fileprivate final class EventCenter: EventCenterService {

    static let shared: EventCenterService = EventCenter()
    var post: EMEventCenterDelegate { EventCenter.shared as! EMEventCenterDelegate }
    private var delegates: [EMEventCenterDelegate] = []

    private init() {}

    func addObserver(_ delegate: EMEventCenterDelegate) {
        guard !delegates.contains(where: { $0 === delegate }) else { return }
        delegates.append(delegate)
    }

    func removeObserver(_ delegate: EMEventCenterDelegate) {
        guard let delegateIndex = delegates.firstIndex(where: { $0 === delegate }) else { return }
        delegates.remove(at: delegateIndex)
    }
}

extension EventCenter: EMEventCenterDelegate {

    func appDataSynced() {
        notify { $0.appDataSynced() }
    }

    private func notify<T>(_ delegate: (EMEventCenterDelegate) -> T) {
        delegates.forEach { delegate($0) }
    }

}
