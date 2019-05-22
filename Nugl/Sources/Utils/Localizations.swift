// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
internal enum L10n {

  internal enum Generic {

    internal enum Alert {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "generic.alert.cancel")
      /// OK
      internal static let ok = L10n.tr("Localizable", "generic.alert.ok")

      internal enum Error {
        /// Error
        internal static let title = L10n.tr("Localizable", "generic.alert.error.title")
      }
    }
  }

  internal enum Profile {

    internal enum Button {
      /// Sign Out
      internal static let signout = L10n.tr("Localizable", "profile.button.signout")
    }
  }

  internal enum Resetpassword {
    /// Recover Password
    internal static let title = L10n.tr("Localizable", "resetPassword.title")

    internal enum Alert {

      internal enum Success {
        /// We have sent a recovery link to your email address.
        internal static let body = L10n.tr("Localizable", "resetPassword.alert.success.body")
        /// Success
        internal static let title = L10n.tr("Localizable", "resetPassword.alert.success.title")
      }
    }

    internal enum Button {
      /// Submit
      internal static let submit = L10n.tr("Localizable", "resetPassword.button.submit")
    }

    internal enum Field {
      /// Email
      internal static let email = L10n.tr("Localizable", "resetPassword.field.email")
    }

    internal enum Label {
      /// Enter your email address and a recovery link will be sent
      internal static let message = L10n.tr("Localizable", "resetPassword.label.message")
    }
  }

  internal enum Signin {

    internal enum Buttons {
      /// Recover it.
      internal static let recoverPassword = L10n.tr("Localizable", "signin.buttons.recoverPassword")
      /// Sign In
      internal static let signin = L10n.tr("Localizable", "signin.buttons.signin")
      /// Sign Up
      internal static let signup = L10n.tr("Localizable", "signin.buttons.signup")
    }

    internal enum Fields {
      /// Email
      internal static let email = L10n.tr("Localizable", "signin.fields.email")
      /// Password
      internal static let password = L10n.tr("Localizable", "signin.fields.password")
    }

    internal enum Labels {
      /// Forgot your password?
      internal static let forgotpassword = L10n.tr("Localizable", "signin.labels.forgotpassword")
      /// Don't have an account?
      internal static let noaccount = L10n.tr("Localizable", "signin.labels.noaccount")
    }
  }

  internal enum Signup {
    /// Sign Up
    internal static let title = L10n.tr("Localizable", "signup.title")

    internal enum Alert {

      internal enum Terms {
        /// I understand NUGL.com does not sell or handle marijuana or marijuana products. NUGL is a Software as a Service (SaaS) and directory that does not police licensing and compliance in any given city, state or nation, and it is my responsibility to follow these laws.
        internal static let body = L10n.tr("Localizable", "signup.alert.terms.body")
        /// Terms of Service
        internal static let title = L10n.tr("Localizable", "signup.alert.terms.title")
      }
    }

    internal enum Button {
      /// I agree to the
      internal static let agreeTerms = L10n.tr("Localizable", "signup.button.agreeTerms")
      /// Terms of Service
      internal static let openTerms = L10n.tr("Localizable", "signup.button.openTerms")
      /// Sign Up
      internal static let signUp = L10n.tr("Localizable", "signup.button.signUp")
    }

    internal enum Errors {
      /// You must agree the Terms of Service.
      internal static let mustAgreeTerms = L10n.tr("Localizable", "signup.errors.mustAgreeTerms")
      /// Passwords do not match.
      internal static let passwordsNotMatch = L10n.tr("Localizable", "signup.errors.passwordsNotMatch")
    }

    internal enum Field {
      /// Confirm Password
      internal static let confirmPassword = L10n.tr("Localizable", "signup.field.confirmPassword")
      /// Email
      internal static let email = L10n.tr("Localizable", "signup.field.email")
      /// Password
      internal static let password = L10n.tr("Localizable", "signup.field.password")
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
