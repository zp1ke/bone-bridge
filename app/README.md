# Bone Bridge

Flutter showcase app.

## Configuration

Non configured TODOs backend will fallback to [dummyjson backend](https://dummyjson.com/docs).
Non configured Profiles backend will not show the feature.

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
