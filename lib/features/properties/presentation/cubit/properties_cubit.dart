import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'properties_state.dart';

class PropertiesCubit extends Cubit<PropertiesState> {
  final GetPropertiesUseCase _getPropertiesUseCase;
  final GetFeaturedPropertiesUseCase _getFeaturedPropertiesUseCase;
  final GetPopularDestinationsUseCase _getPopularDestinationsUseCase;
  final GetPropertyCategoriesUseCase _getPropertyCategoriesUseCase;
  final SearchPropertiesUseCase _searchPropertiesUseCase;

  PropertiesCubit(
    this._getPropertiesUseCase,
    this._getFeaturedPropertiesUseCase,
    this._getPopularDestinationsUseCase,
    this._getPropertyCategoriesUseCase,
    this._searchPropertiesUseCase,
  ) : super(PropertiesInitial());

  Future<void> loadInitialData() async {
    emit(PropertiesLoading());

    try {
      // Load all initial data concurrently
      final results = await Future.wait([
        _getFeaturedPropertiesUseCase(
          const FeaturedPropertiesParams(limit: 10),
        ),
        _getPopularDestinationsUseCase(),
        _getPropertyCategoriesUseCase(),
      ]);

      final featuredResult = results[0] as ApiResponse<List<Property>>;
      final destinationsResult = results[1] as ApiResponse<List<Destination>>;
      final categoriesResult = results[2] as ApiResponse<List<Category>>;

      emit(
        PropertiesLoaded(
          featuredProperties: featuredResult.data ?? [],
          popularDestinations: destinationsResult.data ?? [],
          categories: categoriesResult.data ?? [],
          properties: [],
          hasReachedMax: true,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(
        PropertiesError(
          message: 'Failed to load initial data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> loadProperties({int page = 1, bool refresh = false}) async {
    if (state is PropertiesLoading) return;

    final currentState = state;

    if (refresh || page == 1) {
      emit(PropertiesLoading());
    }

    try {
      final result = await _getPropertiesUseCase(
        GetPropertiesParams(page: page, perPage: 15),
      );

      if (result.isSuccess && result.data != null) {
        final newProperties = result.data!.data;
        final hasReachedMax = result.data!.currentPage >= result.data!.lastPage;

        if (currentState is PropertiesLoaded && !refresh && page > 1) {
          // Append to existing properties
          emit(
            currentState.copyWith(
              properties: [...currentState.properties, ...newProperties],
              hasReachedMax: hasReachedMax,
              currentPage: page,
            ),
          );
        } else if (currentState is PropertiesLoaded) {
          // Replace properties (refresh or first load)
          emit(
            currentState.copyWith(
              properties: newProperties,
              hasReachedMax: hasReachedMax,
              currentPage: page,
            ),
          );
        } else {
          // First load without initial data
          emit(
            PropertiesLoaded(
              featuredProperties: [],
              popularDestinations: [],
              categories: [],
              properties: newProperties,
              hasReachedMax: hasReachedMax,
              currentPage: page,
            ),
          );
        }
      } else {
        emit(PropertiesError(message: result.message));
      }
    } catch (e) {
      emit(
        PropertiesError(message: 'Failed to load properties: ${e.toString()}'),
      );
    }
  }

  Future<void> searchProperties({
    required String query,
    int page = 1,
    bool refresh = false,
    String? city,
    String? type,
    double? minPrice,
    double? maxPrice,
    int? guests,
  }) async {
    if (state is PropertiesLoading) return;

    final currentState = state;

    if (refresh || page == 1) {
      emit(PropertiesSearching());
    }

    try {
      final result = await _searchPropertiesUseCase(
        SearchPropertiesParams(
          query: query,
          page: page,
          perPage: 15,
          city: city,
          type: type,
          minPrice: minPrice,
          maxPrice: maxPrice,
          guests: guests,
        ),
      );

      if (result.isSuccess && result.data != null) {
        final searchResults = result.data!.data;
        final hasReachedMax = result.data!.currentPage >= result.data!.lastPage;

        if (currentState is PropertiesSearchLoaded && !refresh && page > 1) {
          // Append to existing search results
          emit(
            currentState.copyWith(
              searchResults: [...currentState.searchResults, ...searchResults],
              hasReachedMax: hasReachedMax,
              currentPage: page,
            ),
          );
        } else {
          // New search or refresh
          emit(
            PropertiesSearchLoaded(
              query: query,
              searchResults: searchResults,
              hasReachedMax: hasReachedMax,
              currentPage: page,
              totalResults: result.data!.total,
            ),
          );
        }
      } else {
        emit(PropertiesError(message: result.message));
      }
    } catch (e) {
      emit(PropertiesError(message: 'Search failed: ${e.toString()}'));
    }
  }

  void clearSearch() {
    if (state is PropertiesSearchLoaded) {
      loadInitialData();
    }
  }

  Future<void> refreshData() async {
    await loadInitialData();
  }
}
