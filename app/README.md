# Bone Bridge

Flutter showcase app.

## Configuration

Non configured backend will fallback to [dummyjson backend](https://dummyjson.com/docs).

Create *config.json* file.

To change default pagination sizes:
```json
{
  "paginationSizes": "10 15 50 100"
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
