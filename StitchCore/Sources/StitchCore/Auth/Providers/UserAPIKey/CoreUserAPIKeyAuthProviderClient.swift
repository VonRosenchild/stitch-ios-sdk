import Foundation
import MongoSwift

/**
 * A class representing the routes on the Stitch server to perform various actions related to the user API key
 * authentication provider.
 */
private final class Routes {
    /**
     * The authentication API routes that form the base of these provider routes.
     */
    private let baseRoute: String

    /**
     * Initializes the routes with a `StitchAuthRoutes` and the name of the provider.
     */
    fileprivate init(withBaseRoute baseRoute: String) {
        self.baseRoute = baseRoute
    }

    fileprivate func apiKeyRoute(forKeyId id: String) -> String {
        return "\(baseRoute)/\(id)"
    }

    fileprivate func apiKeyEnableRoute(forKeyId id: String) -> String {
        return "\(self.apiKeyRoute(forKeyId: id))/enable"
    }

    fileprivate func apiKeyDisableRoute(forKeyId id: String) -> String {
        return "\(self.apiKeyRoute(forKeyId: id))/disable"
    }
}

private let nameKey = "name"

/**
 * :nodoc:
 * A client for the user API key authentication provider which can be used to create and modify user API keys. This
 * client should only be used by an authenticatd user.
 */
open class CoreUserAPIKeyAuthProviderClient: CoreAuthProviderClient<StitchAuthRequestClient> {
    // MARK: Properties

    /**
     * The routes for the user API key CRUD operations.
     */
    private let routes: Routes

    // MARK: Initializer

    /**
     * A basic initializer, which sets the provider client's properties to the values provided in the parameters.
     */
    public init(withAuthRequestClient authRequestClient: StitchAuthRequestClient,
                withAuthRoutes authRoutes: StitchAuthRoutes) {
        let baseRoute = "\(authRoutes.baseAuthRoute)/api_keys"

        self.routes = Routes.init(withBaseRoute: baseRoute)
        super.init(withProviderName: StitchProviderType.userAPIKey.name,
                   withRequestClient: authRequestClient,
                   withBaseRoute: baseRoute)
    }

    /**
     * Creates a user API key that can be used to authenticate as the current user.
     *
     * - parameters:
     *     - withName: The name of the API key to be created.
     */
    public func createApiKey(withName name: String) throws -> UserAPIKey {
        return try self.requestClient.doAuthenticatedRequest(
            StitchAuthDocRequestBuilder()
                .with(method: .post)
                .with(document: [nameKey: name])
                .with(path: self.baseRoute)
                .withRefreshToken()
                .build()
        )
    }

    /**
     * Fetches a user API key associated with the current user.
     *
     * - parameters:
     *     - withId: The id of the API key to fetch.
     */
    public func fetchApiKey(withId id: ObjectId) throws -> UserAPIKey {
        return try self.requestClient.doAuthenticatedRequest(
            StitchAuthRequestBuilder()
                .with(method: .get)
                .with(path: self.routes.apiKeyRoute(forKeyId: id.description))
                .withRefreshToken()
                .build()
        )
    }

    /**
     * Fetches the user API keys associated with the current user.
     */
    public func fetchApiKeys() throws -> [UserAPIKey] {
        return try self.requestClient.doAuthenticatedRequest(
            StitchAuthRequestBuilder()
                .with(method: .get)
                .with(path: self.baseRoute)
                .withRefreshToken()
                .build()
        )
    }

    /**
     * Deletes a user API key associated with the current user.
     *
     * - parameters:
     *     - withId: The id of the API key to delete.
     */
    public func deleteApiKey(withId id: ObjectId) throws {
        _ = try self.requestClient.doAuthenticatedRequest(
            StitchAuthRequestBuilder()
                .with(method: .delete)
                .with(path: self.routes.apiKeyRoute(forKeyId: id.description))
                .withRefreshToken()
                .build()
        )
    }

    /**
     * Enables a user API key associated with the current user.
     *
     * - parameters:
     *     - withId: The id of the API key to enable.
     */
    public func enableApiKey(withId id: ObjectId) throws {
        _ = try self.requestClient.doAuthenticatedRequest(
            StitchAuthRequestBuilder()
                .with(method: .put)
                .with(path: self.routes.apiKeyEnableRoute(forKeyId: id.description))
                .withRefreshToken()
                .build()
        )
    }

    /**
     * Disables a user API key associated with the current user.
     *
     * - parameters:
     *     - withId: The id of the API key to disable.
     */
    public func disableApiKey(withId id: ObjectId) throws {
        _ = try self.requestClient.doAuthenticatedRequest(
            StitchAuthRequestBuilder()
                .with(method: .put)
                .with(path: self.routes.apiKeyDisableRoute(forKeyId: id.description))
                .withRefreshToken()
                .build()
        )
    }
}