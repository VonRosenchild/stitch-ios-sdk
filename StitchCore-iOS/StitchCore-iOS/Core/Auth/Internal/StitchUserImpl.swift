import Foundation
import StitchCore

/**
 * An implementation of `StitchUser`.
 */
internal final class StitchUserImpl: CoreStitchUserImpl, StitchUser {

    // MARK: Private Properties

    /**
     * The `StitchAuthImpl` that was authenticated as this user.
     */
    private var auth: StitchAuthImpl

    // MARK: Initializer

    /**
     * Initializes this user with its basic properties.
     */
    init(withId id: String,
         withProviderType providerType: StitchProviderType,
         withProviderName providerName: String,
         withUserProfile userProfile: StitchUserProfile,
         withAuth auth: StitchAuthImpl) {
        self.auth = auth
        super.init(id: id,
                   loggedInProviderType: providerType,
                   loggedInProviderName: providerName,
                   profile: userProfile)
    }

    // MARK: Methods

    /**
     * Links this `StitchUser` with a new identity, where the identity is defined by the credential specified as a
     * parameter. This will only be successful if this `StitchUser` is the currently authenticated `StitchUser` for the
     * client from which it was created.
     *
     * - parameters:
     *     - withCredential: The `StitchCore.StitchCredential` used to link the user to a new
     *                       identity. Credentials can be retrieved from an
     *                       authentication provider client, which is retrieved
     *                       using the `getProviderClient` method on `StitchAuth`.
     *     - completionHandler: The completion handler to call when the linking is complete.
     *                          This handler is executed on a non-main global `DispatchQueue`.
     *     - user: The current user, or `nil` if the link failed.
     *     - error: An error object that indicates why the link failed, or `nil` if the link was successful.
     */
    public func link(withCredential credential: StitchCredential,
                     _ completionHandler: @escaping (StitchUser?, Error?) -> Void) {
        self.auth.link(withCredential: credential, withUser: self, completionHandler)
    }
}