class Filter {
  Filter({
    required this.page,
    required this.pageSize,
    required this.searchQuery,
    required this.sortOptions,
  });

  factory Filter.fromJson(Map<String, dynamic> map) {
    return Filter(
      page: map['page'] as int,
      pageSize: map['pageSize'] as int,
      searchQuery: map['searchQuery'] as String?,
      sortOptions: map['sortOptions'] == null
          ? null
          : SortOptions?.fromJson(
              map['sortOptions'] as Map<String, dynamic>,
            ),
    );
  }

  final int page;
  final int pageSize;
  final String? searchQuery;
  final SortOptions? sortOptions;

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'searchQuery': searchQuery,
      'sortOptions': sortOptions?.toJson(),
    };
  }
}

class SortOptions {
  const SortOptions({
    required this.attributeId,
    required this.ascending,
  });

  factory SortOptions.fromJson(Map<String, dynamic> map) {
    return SortOptions(
      attributeId: map['attributeId'] as String,
      ascending: map['ascending'] as bool,
    );
  }

  final String attributeId;
  final bool ascending;

  Map<String, dynamic> toJson() {
    return {
      'attributeId': attributeId,
      'ascending': ascending,
    };
  }
}
