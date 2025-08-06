part of 'properties_cubit.dart';

abstract class PropertiesState extends Equatable {
  const PropertiesState();

  @override
  List<Object?> get props => [];
}

class PropertiesInitial extends PropertiesState {}

class PropertiesLoading extends PropertiesState {}

class PropertiesLoaded extends PropertiesState {
  final List<Property> featuredProperties;
  final List<Destination> popularDestinations;
  final List<PropertyCategory> categories;
  final List<Property> properties;
  final bool hasReachedMax;
  final int currentPage;

  const PropertiesLoaded({
    required this.featuredProperties,
    required this.popularDestinations,
    required this.categories,
    required this.properties,
    required this.hasReachedMax,
    required this.currentPage,
  });

  PropertiesLoaded copyWith({
    List<Property>? featuredProperties,
    List<Destination>? popularDestinations,
    List<PropertyCategory>? categories,
    List<Property>? properties,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return PropertiesLoaded(
      featuredProperties: featuredProperties ?? this.featuredProperties,
      popularDestinations: popularDestinations ?? this.popularDestinations,
      categories: categories ?? this.categories,
      properties: properties ?? this.properties,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    featuredProperties,
    popularDestinations,
    categories,
    properties,
    hasReachedMax,
    currentPage,
  ];
}

class PropertiesSearching extends PropertiesState {}

class PropertiesSearchLoaded extends PropertiesState {
  final String query;
  final List<Property> searchResults;
  final bool hasReachedMax;
  final int currentPage;
  final int totalResults;

  const PropertiesSearchLoaded({
    required this.query,
    required this.searchResults,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalResults,
  });

  PropertiesSearchLoaded copyWith({
    String? query,
    List<Property>? searchResults,
    bool? hasReachedMax,
    int? currentPage,
    int? totalResults,
  }) {
    return PropertiesSearchLoaded(
      query: query ?? this.query,
      searchResults: searchResults ?? this.searchResults,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalResults: totalResults ?? this.totalResults,
    );
  }

  @override
  List<Object?> get props => [
    query,
    searchResults,
    hasReachedMax,
    currentPage,
    totalResults,
  ];
}

class PropertiesError extends PropertiesState {
  final String message;

  const PropertiesError({required this.message});

  @override
  List<Object?> get props => [message];
}
