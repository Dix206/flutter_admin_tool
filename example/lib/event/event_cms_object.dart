import 'package:example/event/event.dart';
import 'package:example/event/use_cases/create_event.dart';
import 'package:example/event/use_cases/delete_event.dart';
import 'package:example/event/use_cases/load_event_by_id.dart';
import 'package:example/event/use_cases/load_events.dart';
import 'package:example/event/use_cases/update_event.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_time/cms_attribute_time.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_location/cms_attribute_location.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_list/cms_attribute_list.dart';
import 'package:flutter_cms/data_types/cms_base_validator.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_string/cms_attribute_string.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_double/cms_attribute_double.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_selection/cms_attribute_selection.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';

final eventCmsObject = CmsObjectStructure(
  id: "event",
  displayName: "Event",
  canBeSortedById: true,
  attributes: [
    const CmsAttributeString(
      id: "title",
      displayName: "Title",
      hint: "Enter a title",
      invalidValueErrorMessage: "You have to enter a title",
      canObjectBeSortedByThisAttribute: true,
    ),
    const CmsAttributeDouble(
      id: "price",
      displayName: "Price",
      hint: "12.34",
      invalidValueErrorMessage: "You have to enter valid a price",
      canObjectBeSortedByThisAttribute: true,
      validator: CmsBaseValidator.isPrice,
    ),
    const CmsAttributeString(
      id: "phoneNumber",
      displayName: "Phone number",
      hint: "+49 123 456789",
      invalidValueErrorMessage: "You have to enter valid phone number",
      canObjectBeSortedByThisAttribute: true,
      validator: CmsBaseValidator.isPhoneNumber,
    ),
    const CmsAttributeString(
      id: "email",
      displayName: "Email",
      hint: "user@test.com",
      invalidValueErrorMessage: "You have to enter valid email address",
      canObjectBeSortedByThisAttribute: true,
      validator: CmsBaseValidator.isEmail,
    ),
    const CmsAttributeLocation(
      id: "location",
      displayName: "Location",
      invalidValueErrorMessage: "You have to enter valid location",
    ),
    CmsAttributeSelection<EventType>(
      id: "eventType",
      displayName: "Typ",
      invalidValueErrorMessage: "You have to select a typ",
      options: EventType.values,
      optionToString: (option) => option.name,
    ),
    const CmsAttributeList(
      id: "neededItems",
      displayName: "Needed Items",
      isOptional: true,
      invalidValueErrorMessage: "You have to enter needed items",
      cmsAttributeStructure: CmsAttributeString(
        id: "item",
        displayName: "Item",
        hint: "Item",
        invalidValueErrorMessage: "You have to enter item",
      ),
    ),
    const CmsAttributeTime(
      id: "startingTime",
      displayName: "Starting Time",
      invalidValueErrorMessage: "You have to enter starting time",
    ),
  ],
  onCreateCmsObject: createEvent,
  onUpdateCmsObject: updateEvent,
  loadCmsObjectById: loadEventById,
  onLoadCmsObjects: loadEvents,
  onDeleteCmsObject: deleteEvent,
);
