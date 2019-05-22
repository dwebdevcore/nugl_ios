

import Foundation

extension Notification.Name {

    public struct Session {
        public static let invalidToken = Notification.Name("invalidToken")
        public static let userDidSignOut = Notification.Name("userDidSignOut")
        public static let userDidSignIn = Notification.Name("userDidSignIn")
    }
}

