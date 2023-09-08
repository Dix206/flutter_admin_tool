import 'package:firebase_example/user/create_user.dart';
import 'package:firebase_example/user/department.dart';
import 'package:firebase_example/user/load_user.dart';
import 'package:firebase_example/user/load_user_by_id.dart';
import 'package:firebase_example/user/update_user.dart';
import 'package:flutter_admin_tool/flat.dart';

const appUserFirebaseCollectionId = "prod_app_user";

final userFlatObject = FlatObjectStructure(
  id: "user",
  displayName: "User",
  canBeSortedById: true,
  attributes:  [
    const FlatAttributeString(
      id: "name",
      displayName: "Name",
      hint: "Name",
      invalidValueErrorMessage: "Du musst einen Namen angeben",
      canObjectBeSortedByThisAttribute: true,
    ),
    const FlatAttributeString(
      id: "id",
      displayName: "Passwort",
      hint: "Passwort",
      invalidValueErrorMessage: "Du musst ein Passwort angeben",
      canObjectBeSortedByThisAttribute: true,
      shouldBeDisplayedOnOverviewTable: false,
      canBeEdited: false,
    ),
    FlatAttributeList(
      flatAttributeStructure: FlatAttributeSelection<Department>(
        id: "department",
        displayName: "Abteilung",
        options: Department.values,
        optionToString: (option) => option.name,
      ),
      id: "departmentsWithAccess",
      displayName: "Abteilungen",
    ),
  ],
  onCreateFlatObject: createUser,
  onUpdateFlatObject: updateUser,
  loadFlatObjectById: loadUserById,
  onLoadFlatObjects: LoadFlatObjects.curser(loadUser),
  canSearchObjects: false,
);
