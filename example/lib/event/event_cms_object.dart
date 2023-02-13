import 'package:example/event/use_cases/create_event.dart';
import 'package:example/event/use_cases/delete_event.dart';
import 'package:example/event/use_cases/load_event_by_id.dart';
import 'package:example/event/use_cases/load_events.dart';
import 'package:example/event/use_cases/update_event.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_double/cms_attribut_double.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';

final eventCmsObject = CmsObjectStructure(
  id: "event",
  displayName: "Event",
  canBeSortedById: true,
  attributes: const [
    CmsAttributString(
      id: "title",
      displayName: "Title",
      hint: "Enter a title",
      invalidValueErrorMessage: "You have to enter a title",
      canObjectBeSortedByThisAttribut: true,
    ),
    // TODO Validator
    CmsAttributDouble(
      id: "price",
      displayName: "Price",
      hint: "12.34",
      invalidValueErrorMessage: "You have to enter valid a price",
      canObjectBeSortedByThisAttribut: true,
    ),
    // TODO Validator
    CmsAttributString(
      id: "phoneNumber",
      displayName: "Phone number",
      hint: "+49 123 456789",
      invalidValueErrorMessage: "You have to enter valid phone number",
      canObjectBeSortedByThisAttribut: true,
    ),
    // TODO Validator
    CmsAttributString(
      id: "email",
      displayName: "Email",
      hint: "user@test.com",
      invalidValueErrorMessage: "You have to enter valid email address",
      canObjectBeSortedByThisAttribut: true,
    ),
    // final double? locationLatitude;
    // final double? locationLongitude;
    // final EventType eventType;
    // final List<String>? neededItems;
    // final TimeOfDay startingTime;
  ],
  onCreateCmsObject: createEvent,
  onUpdateCmsObject: updateEvent,
  loadCmsObjectById: loadEventById,
  onLoadCmsObjects: loadEvents,
  onDeleteCmsObject: deleteEvent,
);
