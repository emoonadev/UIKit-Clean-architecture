//
// Created by Mickael Belhassen on 22/03/2022.
//

import Foundation

struct NCUserInfoKey: Hashable {
    let value: AnyHashable
}

struct NCUserKey: Hashable {
    let value: String
    var notificationName: NSNotification.Name { NSNotification.Name(value) }
}

extension NotificationCenter {

    static func post(_ name: NCUserKey, object: Any? = nil, userInfo: [NCUserInfoKey: Any]? = nil) {
        var finalUserInfo = [AnyHashable: Any]()

        if let userInfo = userInfo {
            userInfo.forEach { source in
                finalUserInfo[source.key.value] = source.value
            }
        }

        NotificationCenter.default.post(name: name.notificationName, object: object, userInfo: finalUserInfo)
    }

    static func addObserver(_ names: NCUserKey..., queue: OperationQueue? = nil, object: Any? = nil, action: @escaping ( [NCUserInfoKey: Any]) -> ()) {
        names.forEach { name in
            NotificationCenter.default.addObserver(forName: name.notificationName, object: object, queue: nil) { notification in
                var finalUserInfo = [NCUserInfoKey: Any]()

                if let userInfo = notification.userInfo {
                    userInfo.forEach { source in
                        finalUserInfo[NCUserInfoKey(value: source.key)] = source.value
                    }
                }

                action(finalUserInfo)
            }
        }
    }

    static func removeObserver(observer: Any, name: NCUserKey, object: Any? = nil) {
        NotificationCenter.default.removeObserver(observer, name: name.notificationName, object: object)
    }

}
