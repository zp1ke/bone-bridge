# Bone Bridge

Flutter showcase app.

## Configuration

Create *config.json* file.

To change default pagination sizes:

```json
{
  "paginationSizes": "10 15 50 100"
}
```

To change web base url:

```json
{
  "webBaseUrl": "https://domain"
}
```

### [Firebase](https://firebase.google.com/)

Copy `firebase.json` file.
Copy `google-services.json` file to `android/app` folder.

In `config.json`:

```json
{
  "firebaseWebApiKey": "TODO",
  "firebaseWebAppId": "TODO",
  "firebaseAndroidApiKey": "TODO",
  "firebaseAndroidAppId": "TODO",
  "firebaseMessagingSenderId": "TODO",
  "firebaseProjectId": "TODO",
  "firebaseAuthDomain": "TODO",
  "firebaseStorageBucket": "TODO"
}
```

### Other backends

Non configured TODOs backend will fallback to [dummyjson backend](https://dummyjson.com/docs).
Non configured Profiles or Storage backend will not enable these features.

To use authentication with [appwrite backend](https://appwrite.io/docs):

```json
{
  "appwriteProjectID": "project_id"
}
```

To use TODOs with [appwrite backend](https://appwrite.io/docs):

```json
{
  "appwriteTodosDbID": "todos_database_id",
  "appwriteTodosLotID": "todos_collection_id"
}
```

To use Profiles with [appwrite backend](https://appwrite.io/docs):

```json
{
  "appwriteProfilesDbID": "profiles_database_id",
  "appwriteProfilesLotID": "profiles_collection_id"
}
```

To use Storage with [appwrite backend](https://appwrite.io/docs):

```json
{
  "appwriteStorageBucket": "storage_bucket"
}
```
