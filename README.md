# BlackBeans 💰

_100% SwiftUI and Combine **finances app** with Core Data integration._

Python API in https://github.com/ricardo0100/BlackBeansAPI

### Features

- Accounts (CRUD)
- Items (CRUD)

### For The Future

- Effectivation date for Items
- Categories for Items
- Credit card support
- Graphics

### Architecture

#### MVVM
Every module follows the **MVVM** pattern with one or more Views, and one ViewModel.

#### Dependency Injection

The `ViewModel` should receive its dependencies in the `init()`. This allows `ViewModel` unit tests.
The current dependencies in the project are:

- `APIProtocol`: 
  - `API`: real implementation.
  - `APIMock` for `ViewModel` unit tests.
  - `APIPreview` for SwiftUI's previews.
- `UserSession`: 
  - `UserSession.shared`: real implementation.
  - `UserSession(userDefaults: #mockedUserDefaults)`: for `ViewModel` unit tests.
  - `UserSession.preview`: for SwiftUI's previews.
- `CoreDataController`:
  - `CoreDataController.shared`: real implementation.
  - `CoreDataController.preview`: for SwiftUI's previews.
  - `CoreDataController(inMemory: true)`: for unit tests.
  - Also the Core Data `NSManagedObjectContext`, used by SwiftUI's `@FetchedRequest` by some Views, is injected in the view hierarchy in the `BeansApp` using SwitUI's environment object.
