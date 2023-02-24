
## Start the app
To start your cms app you just have to return the `FlutterCms` Widget in your `runApp` method. This will automatically setup all you need to run the app.

```dart
void main() {
  runApp(
    FlutterCms(
        ...
    );
}
```

## Handle authentication
Flutter CMS is completely undependent from your used authentication method. You just have to pass a method to get the current logged in user to the `CmsAuthInfos`. If there currently is no logged in user, that method needs to return null. Based on that method Flutter CMS can check if the user is authenticated and allow/disallow specific routes.

The passed `onLogout` will be called if the user wants to logout. After this method was called, the `getLoggedInUser` method should return null. The further logout functionality and button will automatically handled.

Because there could be many different ways to login, you have to setup your login screen by yourself. This screen needs also be passed to the `CmsAuthInfos`. After you have successfully handled your login, you just have to call the given `onLoginSuccess` method. This will automatically navigate you into the Flutter Cms dashboard.

```dart
void main() {
  runApp(
    FlutterCms(
        cmsAuthInfos: CmsAuthInfos(
            getLoggedInUser: authService.getLoggedInUser,
            onLogout: authService.logout,
            loginScreenBuilder: (onLoginSuccess) => LoginScreen(onLoginSuccess: onLoginSuccess),
        ),
        ...
    );
}
```

You can optionally display informations about the logged in user. Therefore you need to set the `getCmsUserInfos`. That method will give you the currently logged in user which was returned by the `getLoggedInUser` method.

```dart
void main() {
  runApp(
    FlutterCms(
        getCmsUserInfos: (loggedInUser) => CmsUserInfos(
            name: loggedInUser.name,
            email: loggedInUser.email,
            role: loggedInUser.prefs.data["role"] == "admin" ? "Admin" : "User",
        ),
        ...
    );
}
```

## Object Structures
The main part of Flutter CMS is the content management. You can easely display, create, update and delete objects. All Flutter CMS needs for that is the data structure of your object and the methods to handle these crud operations.

To define the data structure you have to pass a method to `getCmsObjectStructures` which returns a list of `CmsObjectStructure`. The method gives you the currently logged in user so you can change the functionality based on the logged in user. The `CmsObjectStructure` needs to have a list of attributes. Every attribute must extends the `CmsAttributeStructure`. Flutter CMS gives you a number of pre defined attributes but if you need a specific new attribute, you can define it by yourself.

Not every of crud function needs to be set. If you dont pass a specific method, that functionality will automatically be disabled. As you get the current logged in user, it is possible to disable some of these crud functions for specific user.


```dart
void main() {
  runApp(
    FlutterCms(
        getCmsObjectStructures: (loggedInUser) => [
            CmsObjectStructure(
                id: "event",
                displayName: "Event",
                attributes: [
                    CmsAttributeString(
                        id: "title",
                        displayName: "Title",
                        hint: "Enter a title",
                    ),
                    CmsAttributeLocation(
                        id: "location",
                        displayName: "Location",
                        invalidValueErrorMessage: "You have to enter valid location",
                    ),
                    CmsAttributeTime(
                        id: "startingTime",
                        displayName: "Starting Time",
                        isOptional: true,
                    ),
                ],
                onCreateCmsObject: createEvent,
                onUpdateCmsObject: updateEvent,
                loadCmsObjectById: loadEventById,
                onLoadCmsObjects: loadEvents,
                onDeleteCmsObject: loggedInUser.isAdmin ? deleteEvent : null,
            ),
        ],
        ...
    );
}
```

## Cms Attribute Structure
The `id` of every `CmsAttributeStructure` inside a `CmsObjectStructure` has to be unique. Its needed to identify a `CmsAttributeValue` inside a `CmsObjectValue` which are needed in the crud functions of a `CmsObjectStructure`.
Every `CmsAttributeStructure` can be validated so that it will only be possible to pass a valid value. Just set the `validator` for that. If the user passed value is not valid the `invalidValueErrorMessage` will be displayed. So you can also handle the error message.
By default every `CmsAttributeStructure` is required. You can set the parameter `isOptional` to true if also null values should be possible. If the attribute is required and not set, the `invalidValueErrorMessage` will be displayed.
Flutter CMS has many pre defined `CmsAttributeStructure` elements. Here is a list of every existing element:

### CmsAttributeString

Example:
```dart
CmsAttributeString(
    id: "title",
    displayName: "Title",
    hint: "Enter a title",
    invalidValueErrorMessage: "You have to enter a title",
    maxLength: 15,
)
```
![Alt text](doc/CmsAttributeString.png "CmsAttributeString")

### CmsAttributeBool
The `CmsAttributeBool` is by default required and cant be set optional. By default the `defaultValue` is false.

Example:
```dart
CmsAttributeBool(
      id: "isActive",
      displayName: "Is Article active",
      canObjectBeSortedByThisAttribute: true,
)
```
![Alt text](doc/CmsAttributeBool.png "CmsAttributeBool")

### CmsAttributeInt
Example:
```dart
CmsAttributeInt(
          id: "sortOrder",
          displayName: "Sort Order",
          defaultValue: 0,
          canObjectBeSortedByThisAttribute: true,
)
```
![Alt text](doc/CmsAttributeInt.png "CmsAttributeInt")

### CmsAttributeDouble
Example:
```dart
CmsAttributeDouble(
      id: "price",
      displayName: "Price",
      hint: "12.34",
      invalidValueErrorMessage: "You have to enter valid a price",
      canObjectBeSortedByThisAttribute: true,
      validator: CmsBaseValidator.isPrice,
)
```
![Alt text](doc/CmsAttributeDouble.png "CmsAttributeDouble")

### CmsAttributeColor
The color selection widget is build upon the [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) package.

Example:
```dart
const CmsAttributeColor(
        id: "color",
        displayName: "Color",
        isOptional: true,
)
```
![Alt text](doc/CmsAttributeColor.png "CmsAttributeColor")
![Alt text](doc/CmsAttributeColorSelection.png "CmsAttributeColorPicker")

### CmsAttributeDateTime
Example:
```dart
CmsAttributeDateTime(
      id: "timestamp",
      displayName: "Created at",
      minDateTime: DateTime(2020),
      maxDateTime: DateTime.now().add(const Duration(days: 365)),
)
```
![Alt text](doc/CmsAttributeDateTime.png "CmsAttributeDateTime")

### CmsAttributeDate
Example:
```dart
CmsAttributeDate(
    id: "day",
    displayName: "Day",
    defaultValue: DateTime(2020, 12, 12),
)
```
![Alt text](doc/CmsAttributeDate.png "CmsAttributeDate")

### CmsAttributeTime
Example:
```dart
const CmsAttributeTime(
      id: "startingTime",
      displayName: "Starting Time",
      invalidValueErrorMessage: "You have to enter starting time",
    )
```
![Alt text](doc/CmsAttributeTime.png "CmsAttributeTime")

### CmsAttributeHtml
The html widget is build upon the [quill_html_editor](https://pub.dev/packages/quill_html_editor) package. Because it is an embadded web library, there could be some unwanted behavior in the UI.

Example:
```dart
const CmsAttributeHtml(
        id: "content",
        displayName: "Content",
)
```
![Alt text](doc/CmsAttributeHtml.png "CmsAttributeHtml")

### CmsAttributeImage
The image selection is build upon the [file_picker](https://pub.dev/packages/file_picker) package.

Example:
```dart
CmsAttributeImage(
    id: "image",
    displayName: "Image",
    isOptional: true,
)
```
![Alt text](doc/CmsAttributeImage.png "CmsAttributeImage")

### CmsAttributeFile
The file selection is build upon the [file_picker](https://pub.dev/packages/file_picker) package.

Example:
```dart
CmsAttributeFile(
    id: "file",
    displayName: "File",
    isOptional: true,
)
```
![Alt text](doc/CmsAttributeFile.png "CmsAttributeFile")

### CmsAttributeLocation
Example:
```dart
CmsAttributeLocation(
    id: "location",
    displayName: "Location",
    invalidValueErrorMessage: "You have to enter valid location",
)
```
![Alt text](doc/CmsAttributeLocation.png "CmsAttributeLocation")

### CmsAttributeSelection
The selected object could be of any type. 

Example:
```dart
CmsAttributeSelection<EventType>(
    id: "eventType",
    displayName: "Typ",
    invalidValueErrorMessage: "You have to select a typ",
    options: EventType.values,
    optionToString: (option) => option.name,
)
```
![Alt text](doc/CmsAttributeSelection.png "CmsAttributeSelection")

### CmsAttributeList
You can use `CmsAttributeList`to add a list of attributes to your object. The type of the attributes will be defined by the parameter `CmsAttributeStructure`. There you have to pass a `CmsAttributeStructure`. You can use any `CmsAttributeStructure` you want. The behaviour for adding a new attribute instance to the list will be defined in there.

Example:
```dart
CmsAttributeList(
    id: "neededItems",
    displayName: "Needed Items",
    CmsAttributeStructure: CmsAttributeString(
        id: "item",
        displayName: "Item",
        hint: "Item",
        invalidValueErrorMessage: "You have to enter item",
    ),
)
```
![Alt text](doc/CmsAttributeList.png "CmsAttributeList")
![Alt text](doc/CmsAttributeListSelectedItems.png "CmsAttributeListSelectedItems")

### CmsAttributeReference
This attribute gives you the possibility to search for an option which will be selected. You can define that function and return a list of possible items which can be selected. You also have to pass a function for the parameter `getReferenceDisplayString`. This function has to return the display string for a passed item.

A common use case is to add a reference to another object. 

Example:
```dart
CmsAttributeReference<Author>(
    id: "author",
    displayName: "Author",
    searchFunction: loadAuthors,
    getReferenceDisplayString: (author) => author.name,
    isOptional: true,
)

Future<CmsResult<List<Author>>> loadAuthors(String searchQuery) async {
    final authors = [
        Author(id: 1, name: "Jan"),
        Author(id: 1, name: "Fritz"),
        Author(id: 1, name: "Janosch"),
    ];

    final filteredAuthors = authors.where((author) => author.name.startsWith(searchQuery)).toList();

    return CmsResult.success(filteredAuthors);
}
```

![Alt text](doc/CmsAttributeReference.png "CmsAttributeReference")


## Base Validator
Flutter CMS offers you some base validation methods that you can use inside your `CmsAttributeStructure`. You can find them inside the `CmsBaseValidator` class.

## CMS Object Structure CRUD Operations
In an `CmsObjectStructure` you need to define CRUD functions which connects Flutter CMS with your backend. Every of these functions returns a Future of `CmsResult`. The `CmsResult` has two constructors `CmsResult.success` and `CmsResult.error`. If your function succeeds you can use the `CmsResult.success` constructor and pass the required data. If a function shouldnt return any data you need to pass a new `Unit` object: `CmsResult.success(Unit())`. This is for example the case in the delete function. There we only need the information if the action was successful. So you could emagine `Unit()` as `void`. If the action wasnt successful you should use the `CmsResult.error` constructor and pass an error message string. That string will be displayed to the user.

Example:

```dart
Future<CmsResult<Unit>> deleteEvent(String eventId) async {
  try {
    final response = await client.delete("/event/$eventId");

    if(response.status == 404) {
        return CmsResult.error("There exists no event with the id $eventId")
    } else {
        return CmsResult.success(const Unit());
    }
  } catch (exception) {
    return CmsResult.error("Failed to delete event. Please try again");
  }
}
```

To get and pass instances of the pre defined `CmsObjectStructure` there will be used the object `CmsObjectValue`. That object gets an `id` which is the id of the instance, not the id of the `CmsObjectStructure`. Also it has a list of `CmsAttributeValue`. That list should contain a value for every `CmsAttributeStructure` defined in the `CmsObjectStructure`. Its important that the `id` which is set in an `CmsAttributeValue` is the same as the `id` in the defined `CmsAttributeStructure` to which it belongs to. Thats neccessary to load the value of the attribute in a `CmsObjectValue` with the method `getAttributeValueByAttributeId`.

It is a good practice to define a seperate model for the `CmsObjectStructure` with `fromCmsObjectValue` and `toCmsObjectValue` methods. Similar to the `fromJson` and `toJson` methods. That makes it possible to work with that model in a typesave way. 

Example:
```dart
class Event {
  final String id;
  final String title;
  final double? locationLatitude;
  final double? locationLongitude;
  final TimeOfDay startingTime;

  Event({
    required this.id,
    required this.title,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.startingTime,
  });

  CmsObjectValue toCmsObjectValue() {
    return CmsObjectValue(
      id: id,
      values: [
        CmsAttributeValue(id: 'id', value: id),
        CmsAttributeValue(id: 'title', value: title),
        CmsAttributeValue(
          id: 'location',
          value: locationLatitude != null && locationLongitude != null
              ? CmsLocation(
                  latitude: locationLatitude!,
                  longitude: locationLongitude!,
                )
              : null,
        ),
        CmsAttributeValue(id: 'startingTime', value: startingTime),
      ],
    );
  }

  factory Event.fromCmsObjectValue({
    required CmsObjectValue cmsObjectValue,
    String? id,
  }) {
    return Event(
      id: id ?? cmsObjectValue.id!,
      title: cmsObjectValue.getAttributeValueByAttributeId('title'),
      locationLatitude: (cmsObjectValue.getAttributeValueByAttributeId('location') as CmsLocation?)?.latitude,
      locationLongitude: (cmsObjectValue.getAttributeValueByAttributeId('location') as CmsLocation?)?.longitude,
      startingTime: cmsObjectValue.getAttributeValueByAttributeId('startingTime'),
    );
  }
}
```

### Load Cms Objects
The most complex function is `OnLoadCmsObjects`. Thats because this function also handles pagination, filtering and sorting items. 

For the pagination behavior it doesnt directly return a list of `CmsObjectValue` but an `CmsObjectValueList` object, which contains that `CmsObjectValue` list. Additionaly the `CmsObjectValueList` needs an `overallPageCount` value. This is needed to handle the pagination correctly.

The `OnLoadCmsObjects` function gets an `page` value. Thats the value of the page which should be loaded and returned from the function. The size of each page could be defined by yourself. 

The only search parameter for now is `searchQuery`. That optional parameter contains the search text which was entered by the user to filter the objects. How implement that filter is up to you.

For sort functionality an optional value of `CmsObjectSortOptions` will be passed. That object contains the attributeId of the attribute according to which sorting is to take place. If the value `ascending` is set to true, the attribute should be sorted ascending, otherwise descending. The objects can only be sorted by attributes where the values `shouldBeDisplayedOnOverviewTable` and `canObjectBeSortedByThisAttribute` both where set to true. 

## Localization
TODO

## Custom Screens
TODO

## Theming
TODO
