import 'package:example/event/event.dart';
import 'package:example/event/use_cases/create_event.dart';
import 'package:example/event/use_cases/delete_event.dart';
import 'package:example/event/use_cases/load_event_by_id.dart';
import 'package:example/event/use_cases/load_events.dart';
import 'package:example/event/use_cases/update_event.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_time/cms_attribut_time.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_location/cms_attribut_location.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_list/cms_attribut_list.dart';
import 'package:flutter_cms/data_types/base_validator.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_double/cms_attribut_double.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_selection/cms_attribut_selection.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';

final eventCmsObject = CmsObjectStructure(
  id: "event",
  displayName: "Event",
  canBeSortedById: true,
  attributes: [
    const CmsAttributString(
      id: "title",
      displayName: "Title",
      hint: "Enter a title",
      invalidValueErrorMessage: "You have to enter a title",
      canObjectBeSortedByThisAttribut: true,
    ),
    const CmsAttributDouble(
      id: "price",
      displayName: "Price",
      hint: "12.34",
      invalidValueErrorMessage: "You have to enter valid a price",
      canObjectBeSortedByThisAttribut: true,
      validator: CmsBaseValidator.isPrice,
    ),
    const CmsAttributString(
      id: "phoneNumber",
      displayName: "Phone number",
      hint: "+49 123 456789",
      invalidValueErrorMessage: "You have to enter valid phone number",
      canObjectBeSortedByThisAttribut: true,
      validator: CmsBaseValidator.isPhoneNumber,
    ),
    const CmsAttributString(
      id: "email",
      displayName: "Email",
      hint: "user@test.com",
      invalidValueErrorMessage: "You have to enter valid email address",
      canObjectBeSortedByThisAttribut: true,
      validator: CmsBaseValidator.isEmail,
    ),
    const CmsAttributLocation(
      id: "location",
      displayName: "Location",
      invalidValueErrorMessage: "You have to enter valid location",
    ),
    CmsAttributSelection<EventType>(
      id: "eventType",
      displayName: "Typ",
      invalidValueErrorMessage: "You have to enter a typ",
      options: EventType.values,
      optionToString: (option) => option.name,
    ),
    const CmsAttributList(
      id: "neededItems",
      displayName: "Needed Items",
      isOptional: true,
      invalidValueErrorMessage: "You have to enter needed items",
      cmsAttributStructure: CmsAttributString(
        id: "item",
        displayName: "Item",
        hint: "Item",
        invalidValueErrorMessage: "You have to enter item",
      ),
    ),
    const CmsAttributTime(
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
