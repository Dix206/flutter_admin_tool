import 'package:equatable/equatable.dart';

class FlatTexts extends Equatable {
  final String appTitle;
  final String defaultInvalidDataMessage;

  /// This string will be displayed for an attribute value with a value of null
  final String flatAttributeValueNull;
  final String select;
  final String flatAttributeColorHexTitle;
  final String flatAttributeFileSelectFileMessage;
  final String delete;
  final String flatAttributeListAddItem;
  final String flatAttributeLocationLatitude;
  final String flatAttributeLocationLongitude;
  final String flatAttributeSelectionNoItemSelected;
  final String noFlatCustomMenuEntryFoundWithId;
  final String settings;
  final String cancel;
  final String save;
  final String Function(String id)? _updateFlatObjectNoObjectFoundWithPassedId;
  final String deleteFlatObjectValueConfirmationMessage;
  final String insertFlatObjectInvalidDataMessage;
  final String Function(String id)?
      _noFlatObjectStructureObjectFoundWithPassedId;
  final String createNewObjectButton;
  final String searchObjectsTextFieldHint;
  final String searchObjectsButton;
  final String objectTablePageText;
  final String objectTablePageOfText;
  final String objectTableNoItemsMessage;
  final String objectTableIdTitle;
  final String darkMode;
  final String logout;
  final String errorMessageRetryButton;
  final String errorMessageTitle;
  final String ok;

  const FlatTexts({
    this.appTitle = "Flat",
    this.defaultInvalidDataMessage = "Invalid data",
    this.flatAttributeValueNull = "---",
    this.select = "Select",
    this.flatAttributeColorHexTitle = "Hex",
    this.flatAttributeFileSelectFileMessage = "Select a file",
    this.delete = "Delete",
    this.flatAttributeListAddItem = "Add item",
    this.flatAttributeLocationLatitude = "Latitude",
    this.flatAttributeLocationLongitude = "Longitude",
    this.flatAttributeSelectionNoItemSelected = "No item selected",
    this.noFlatCustomMenuEntryFoundWithId = "This menu entry doesnt exist",
    this.settings = "Settings",
    this.cancel = "Cancel",
    this.save = "Save",
    String Function(String id)? updateFlatObjectNoObjectFoundWithPassedId,
    this.deleteFlatObjectValueConfirmationMessage =
        "Do you really want to delete this item?",
    this.insertFlatObjectInvalidDataMessage =
        "Invalid data. Please check your entered data.",
    String Function(String id)? noFlatObjectStructureObjectFoundWithPassedId,
    this.createNewObjectButton = "New object",
    this.searchObjectsTextFieldHint = "Search",
    this.searchObjectsButton = "Search",
    this.objectTablePageText = "Page",
    this.objectTablePageOfText = "of",
    this.objectTableNoItemsMessage = "No items found",
    this.objectTableIdTitle = "ID",
    this.darkMode = "Dark Mode",
    this.logout = "Logout",
    this.errorMessageRetryButton = "Retry",
    this.errorMessageTitle = "Error",
    this.ok = "Ok",
  })  : _updateFlatObjectNoObjectFoundWithPassedId =
            updateFlatObjectNoObjectFoundWithPassedId,
        _noFlatObjectStructureObjectFoundWithPassedId =
            noFlatObjectStructureObjectFoundWithPassedId;

  String updateFlatObjectNoObjectFoundWithPassedId(String id) =>
      _updateFlatObjectNoObjectFoundWithPassedId?.call(id) ??
      "There is no Object with the id $id";

  String noFlatObjectStructureObjectFoundWithPassedId(String id) =>
      _noFlatObjectStructureObjectFoundWithPassedId?.call(id) ??
      "There is no Object with the id $id";

  @override
  List<Object?> get props => [appTitle, defaultInvalidDataMessage];
}
