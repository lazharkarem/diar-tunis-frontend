import 'package:flutter/foundation.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/properties/domain/repositories/property_repository.dart';

class HostPropertyProvider with ChangeNotifier {
  final PropertyRepository _propertyRepository;
  
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  List<Property> _properties = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalProperties = 0;
  
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _currentPage < _totalPages;
  String? get error => _error;
  List<Property> get properties => _properties;
  int get totalProperties => _totalProperties;
  
  HostPropertyProvider(this._propertyRepository);
  
  Future<void> loadProperties({bool refresh = false}) async {
    print('loadProperties called. refresh: $refresh');
    
    if (refresh) {
      _currentPage = 1;
      _properties = [];
      _error = null;
    }
    
    // Prevent multiple simultaneous loads
    if (_isLoading || _isLoadingMore) {
      print('Load already in progress. Skipping...');
      return;
    }
    
    // Set loading states
    if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    
    notifyListeners();
    
    try {
      print('Fetching properties page $_currentPage...');
      final stopwatch = Stopwatch()..start();
      
      final response = await _propertyRepository.getProperties(
        page: _currentPage,
        perPage: 10, // Adjust per page count as needed
      );
      
      stopwatch.stop();
      print('API call completed in ${stopwatch.elapsedMilliseconds}ms');
      
      if (response.isSuccess) {
        final data = response.data;
        if (data == null) {
          _error = 'No data received from server';
          print('Error: $_error');
          notifyListeners();
          return;
        }
        
        print('Received ${data.data.length} properties (page ${data.currentPage} of ${data.lastPage})');
        
        final newProperties = data.data;
        
        if (refresh) {
          _properties = newProperties;
        } else {
          _properties.addAll(newProperties);
        }
        
        _totalProperties = data.total;
        _totalPages = data.lastPage;
        
        if (newProperties.isNotEmpty) {
          _currentPage++;
        }
        
        print('Total properties loaded: ${_properties.length}');
      } else {
        _error = response.message ?? 'Failed to load properties';
        print('API Error: $_error');
        print('Status code: ${response.statusCode}');
        
        // Handle authentication errors
        if (response.statusCode != null && response.statusCode == 401) {
          _error = 'Your session has expired. Please log in again.';
          // TODO: Trigger logout flow
        }
      }
    } catch (e, stackTrace) {
      _error = 'Error loading properties: ${e.toString()}';
      print('Exception in loadProperties: $_error');
      print('Stack trace: $stackTrace');
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
      
      print('Load completed. Error: $_error');
    }
  }
  
  Future<bool> togglePropertyStatus(String propertyId) async {
    try {
      // Find the property to update
      final index = _properties.indexWhere((p) => p.id == propertyId);
      if (index == -1) return false;
      
      // Optimistic update
      final property = _properties[index];
      final updatedProperty = property.copyWith(
        status: property.status == 'active' ? 'inactive' : 'active',
      );
      
      _properties[index] = updatedProperty;
      notifyListeners();
      
      // TODO: Call API to update property status
      // final response = await _propertyRepository.updatePropertyStatus(
      //   propertyId: propertyId,
      //   status: updatedProperty.status,
      // );
      
      // If API call fails, revert the change
      // if (!response.isSuccess) {
      //   _properties[index] = property;
      //   notifyListeners();
      //   return false;
      // }
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> refreshProperties() async {
    await loadProperties(refresh: true);
  }
  
  Property? getPropertyById(String id) {
    try {
      return _properties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }
}
