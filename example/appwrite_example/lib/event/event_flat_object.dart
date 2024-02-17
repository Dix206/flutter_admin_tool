import 'package:example/event/event.dart';
import 'package:example/event/use_cases/create_event.dart';
import 'package:example/event/use_cases/delete_event.dart';
import 'package:example/event/use_cases/load_event_by_id.dart';
import 'package:example/event/use_cases/load_events.dart';
import 'package:example/event/use_cases/update_event.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_multi_selection/flat_attribute_multi_selection.dart';
import 'package:flutter_admin_tool/flat.dart';

final eventFlatObject = FlatObjectStructure(
  id: "event",
  displayName: "Event",
  newObjectText: "New Event",
  canBeSortedById: true,
  attributes: [
    const FlatAttributeString(
      id: "title",
      displayName: "Title",
      hint: "Enter a title",
      invalidValueErrorMessage: "You have to enter a title",
      canObjectBeSortedByThisAttribute: true,
    ),
    const FlatAttributeDouble(
      id: "price",
      displayName: "Price",
      hint: "12.34",
      invalidValueErrorMessage: "You have to enter valid a price",
      canObjectBeSortedByThisAttribute: true,
      validator: FlatBaseValidator.isPrice,
    ),
    const FlatAttributeString(
      id: "phoneNumber",
      displayName: "Phone number",
      hint: "+49 123 456789",
      invalidValueErrorMessage: "You have to enter valid phone number",
      canObjectBeSortedByThisAttribute: true,
      validator: FlatBaseValidator.isPhoneNumber,
    ),
    const FlatAttributeString(
      id: "email",
      displayName: "Email",
      hint: "user@test.com",
      invalidValueErrorMessage: "You have to enter valid email address",
      canObjectBeSortedByThisAttribute: true,
      validator: FlatBaseValidator.isEmail,
    ),
    const FlatAttributeLocation(
      id: "location",
      displayName: "Location",
      invalidValueErrorMessage: "You have to enter valid location",
    ),
    FlatAttributeSelection<EventType>(
      id: "eventType",
      displayName: "Typ",
      invalidValueErrorMessage: "You have to select a typ",
      options: EventType.values,
      optionToString: (option) => option.name,
    ),
    FlatAttributeMultiSelection<EventType>(
      id: "secondaryEventTypes",
      displayName: "Needed Secondary Items",
      invalidValueErrorMessage: "You have to select at least one typ",
      options: EventType.values,
      optionToString: (option) => option.name,
      shouldBeDisplayedOnOverviewTable: false,
    ),
    const FlatAttributeList(
      id: "neededItems",
      displayName: "Needed Items",
      isOptional: true,
      invalidValueErrorMessage: "You have to enter needed items",
      flatAttributeStructure: FlatAttributeString(
        id: "item",
        displayName: "Item",
        hint: "Item",
        invalidValueErrorMessage: "You have to enter item",
      ),
    ),
    const FlatAttributeTime(
      id: "startingTime",
      displayName: "Starting Time",
      invalidValueErrorMessage: "You have to enter starting time",
    ),
  ],
  onCreateFlatObject: createEvent,
  onUpdateFlatObject: updateEvent,
  loadFlatObjectById: loadEventById,
  onLoadFlatObjects: LoadFlatObjects.offset(loadEvents),
  onDeleteFlatObject: deleteEvent,
);
