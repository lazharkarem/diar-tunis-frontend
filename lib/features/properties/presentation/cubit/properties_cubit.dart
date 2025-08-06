import 'package:dartz/dartz.dart';
import 'package:diar_tunis/core/errors/failures.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/authentication/domain/usecases/usecase.dart';
import 'package:diar_tunis/features/properties/domain/usecases/get_featured_properties_usecase.dart';
import 'package:diar_tunis/features/properties/domain/usecases/get_popular_destinations_usecase.dart';
import 'package:diar_tunis/features/properties/domain/usecases/get_properties_usecase.dart';
import 'package:diar_tunis/features/properties/domain/usecases/get_property_categories_usecase.dart';
import 'package:diar_tunis/features/properties/domain/usecases/search_properties_usecase.dart';
import 'package:diar_tunis/features/shared/domain/entities/property_category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/shared/domain/entities/destination.dart';

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
        _getPopularDestinationsUseCase(NoParams()),
        _getPropertyCategoriesUseCase(NoParams()),
      ]);

      final featuredEither = results[0] as Either<Failure, List<Property>>;
      final destinationsEither =
          results[1] as Either<Failure, List<Destination>>;
      final categoriesEither =
          results[2] as Either<Failure, List<PropertyCategory>>;

      if (featuredEither.isRight() &&
          destinationsEither.isRight() &&
          categoriesEither.isRight()) {
        emit(
          PropertiesLoaded(
            featuredProperties: featuredEither.getOrElse(() => []),
            popularDestinations: destinationsEither.getOrElse(() => []),
            categories: categoriesEither.getOrElse(() => []),
            properties: [],
            hasReachedMax: true,
            currentPage: 1,
          ),
        );
      } else {
        final errorMessage = _getErrorMessage(
          featuredEither,
          destinationsEither,
          categoriesEither,
        );
        emit(PropertiesError(message: errorMessage));
      }
    } catch (e) {
      emit(
        PropertiesError(
          message: 'Failed to load initial data: ${e.toString()}',
        ),
      );
    }
  }

  String _getErrorMessage(
    Either<Failure, List<Property>> featured,
    Either<Failure, List<Destination>> destinations,
    Either<Failure, List<PropertyCategory>> categories,
  ) {
    if (featured.isLeft()) return (featured as Left).value.message;
    if (destinations.isLeft()) return (destinations as Left).value.message;
    if (categories.isLeft()) return (categories as Left).value.message;
    return 'Failed to load initial data';
  }

  Future<void> loadProperties({int page = 1, bool refresh = false}) async {
    if (state is PropertiesLoading) return;

    final currentState = state;

    if (refresh || page == 1) {
      emit(PropertiesLoading());
    }

    try {
      final either = await _getPropertiesUseCase(
        GetPropertiesParams(page: page, perPage: 15),
      );

      either.fold(
        (failure) => emit(PropertiesError(message: failure.message)),
        (paginatedResponse) {
          final newProperties = paginatedResponse.data;
          final hasReachedMax =
              paginatedResponse.currentPage >= paginatedResponse.lastPage;

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
        },
      );
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
      final either = await _searchPropertiesUseCase(
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

      either.fold(
        (failure) => emit(PropertiesError(message: failure.message)),
        (paginatedResponse) {
          final searchResults = paginatedResponse.data;
          final hasReachedMax =
              paginatedResponse.currentPage >= paginatedResponse.lastPage;

          if (currentState is PropertiesSearchLoaded && !refresh && page > 1) {
            // Append to existing search results
            emit(
              currentState.copyWith(
                searchResults: [
                  ...currentState.searchResults,
                  ...searchResults,
                ],
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
                totalResults: paginatedResponse.total,
              ),
            );
          }
        },
      );
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
