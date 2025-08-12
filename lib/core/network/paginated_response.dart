/// A generic class that holds the paginated response data and pagination information
class PaginatedResponse<T> {
  /// The list of items in the current page
  final List<T> data;

  /// The current page number
  final int currentPage;

  /// The number of items per page
  final int perPage;

  /// The total number of items across all pages
  final int total;

  /// The total number of pages
  final int lastPage;

  /// Creates a new [PaginatedResponse] instance
  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  /// Creates a [PaginatedResponse] from a JSON map
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      currentPage: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 1,
    );
  }

  /// Creates a copy of this [PaginatedResponse] with the given fields replaced by the new values
  PaginatedResponse<T> copyWith({
    List<T>? data,
    int? currentPage,
    int? perPage,
    int? total,
    int? lastPage,
  }) {
    return PaginatedResponse<T>(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      lastPage: lastPage ?? this.lastPage,
    );
  }

  /// Whether there are more pages available
  bool get hasNextPage => currentPage < lastPage;

  /// Whether there are previous pages available
  bool get hasPreviousPage => currentPage > 1;

  @override
  String toString() {
    return 'PaginatedResponse{data: $data, currentPage: $currentPage, perPage: $perPage, total: $total, lastPage: $lastPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginatedResponse<T> &&
        other.runtimeType == runtimeType &&
        other.currentPage == currentPage &&
        other.perPage == perPage &&
        other.total == total &&
        other.lastPage == lastPage &&
        other.data.length == data.length;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      currentPage,
      perPage,
      total,
      lastPage,
      data.length,
    );
  }
}
