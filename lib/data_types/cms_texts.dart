import 'package:equatable/equatable.dart';

class CmsTexts extends Equatable {
  final String appTitle;
  final String defaultInvalidDataMessage;

  /// This string will be displayed for an attribute value with a value of null
  final String cmsAttributValueNull;
  final String select;
  final String cmsAttributColorHexTitle;
  final String cmsAttributFileSelectFileMessage;
  final String delete;
  final String cmsAttributListAddItem;
  final String cmsAttributLocationLatitude;
  final String cmsAttributLocationLongitude;
  final String cmsAttributSelectionNoItemSelected;
  final String noCmsCustomMenuEntryFoundWithId;
  final String settings;
  final String cancel;
  final String save;
  final String Function(String id)? _updateCmsObjectNoObjectFoundWithPassedId;
  final String deleteCmsObjectValueConfirmationMessage;
  final String insertCmsObjectInvalidDataMessage;
  final String Function(String id)? _noCmsObjectStructureObjectFoundWithPassedId;
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

  const CmsTexts({
    this.appTitle = "Flutter CMS",
    this.defaultInvalidDataMessage = "Invalid data",
    this.cmsAttributValueNull = "---",
    this.select = "Select",
    this.cmsAttributColorHexTitle = "Hex",
    this.cmsAttributFileSelectFileMessage = "Select a file",
    this.delete = "Delete",
    this.cmsAttributListAddItem = "Add item",
    this.cmsAttributLocationLatitude = "Latitude",
    this.cmsAttributLocationLongitude = "Longitude",
    this.cmsAttributSelectionNoItemSelected = "No item selected",
    this.noCmsCustomMenuEntryFoundWithId = "This menu entry doesnt exist",
    this.settings = "Settings",
    this.cancel = "Cancel",
    this.save = "Save",
    String Function(String id)? updateCmsObjectNoObjectFoundWithPassedId,
    this.deleteCmsObjectValueConfirmationMessage = "Do you really want to delete this item?",
    this.insertCmsObjectInvalidDataMessage = "Invalid data. Please check your entered data.",
    String Function(String id)? noCmsObjectStructureObjectFoundWithPassedId,
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
  })  : _updateCmsObjectNoObjectFoundWithPassedId = updateCmsObjectNoObjectFoundWithPassedId,
        _noCmsObjectStructureObjectFoundWithPassedId = noCmsObjectStructureObjectFoundWithPassedId;

  String updateCmsObjectNoObjectFoundWithPassedId(String id) => _updateCmsObjectNoObjectFoundWithPassedId?.call(id) ?? "There is no Object with the id $id";

  String noCmsObjectStructureObjectFoundWithPassedId(String id) => _noCmsObjectStructureObjectFoundWithPassedId?.call(id) ?? "There is no Object with the id $id";

  @override
  List<Object?> get props => [appTitle, defaultInvalidDataMessage];
}
