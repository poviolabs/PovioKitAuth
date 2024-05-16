## Migration Guides

### Migration from versions < 2.0.0
* [Apple] Response field `name` is now optional.
* [All] Migrated all authenticators from promises to async/await. If you insist working with promises, do not update.

### Migration from versions < 1.4.0
* [Google] Response field `token` was renamed to `accessToken`. You'll need to handle it on the call site. Additionally, `idToken` field was added in the response.  
