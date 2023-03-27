import 'package:dio/dio.dart';
import 'package:flat/flat.dart';
import 'package:frontend/event/client.dart';
import 'package:frontend/event/event.dart';

Future<FlatResult<FlatOffsetObjectValueList>> loadEvents({
  required int page,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final result = await client.get(
      "/event",
      // data: {
      //   'page': page,
      //   'pageSize': itemsToLoad,
      //   'searchQuery': searchQuery,
      //   'sortOptions': sortOptions == null
      //       ? null
      //       : {
      //           'attributeId': sortOptions.attributeId,
      //           'ascending': sortOptions.ascending,
      //         },
      // },
    );

    if (result.statusCode != 200) {
      return FlatResult.error("Failed to load events. Please try again");
    }

    final events =
        (result.data as List).map((json) => Event.fromJson(json)).map((event) => event.toFlatObjectValue()).toList();

    return FlatResult.success(
      FlatOffsetObjectValueList(
        flatObjectValues: events,
        overallPageCount: 12, // TODO
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load events. Please try again");
  }
}
