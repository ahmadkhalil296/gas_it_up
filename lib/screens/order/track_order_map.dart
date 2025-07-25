import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/back_button.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:math' show min, max;
import '../../services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

/// Widget that displays a map for tracking an order's delivery
/// Shows the driver's location, route, and destination
class TrackOrderMap extends StatefulWidget {
  final String orderId;

  const TrackOrderMap({Key? key, required this.orderId}) : super(key: key);

  @override
  State<TrackOrderMap> createState() => _TrackOrderMapState();
}

class _TrackOrderMapState extends State<TrackOrderMap> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _isLoading = true;
  StreamSubscription<Position>? _locationSubscription;
  LatLng? _savedLocation;
  final LatLng _storeLocation = LatLng(34.434519, 35.835907); // Store location
  String googleAPiKey = ""; // Google Maps API key removed
  List<LatLng> _routePoints = [];
  int _currentRouteIndex = 0;
  Timer? _simulationTimer;
  LatLng? _driverLocation;
  BitmapDescriptor? _truckIcon;

  @override
  void initState() {
    super.initState();
    print('TrackOrderMap initialized with order ID: ${widget.orderId}');
    _createTruckMarkerIcon();
    _loadSavedLocation();
    _addStoreMarker();
  }

  /// Creates a custom truck icon for the driver marker
  /// Loads and processes the truck image from assets
  Future<void> _createTruckMarkerIcon() async {
    try {
      final ByteData data =
          await rootBundle.load('assets/images/delivery_truck.png');
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: 110, // Increased from 80
        targetHeight: 110, // Increased from 80
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ByteData? resizedData =
          await fi.image.toByteData(format: ui.ImageByteFormat.png);

      if (resizedData != null) {
        setState(() {
          _truckIcon =
              BitmapDescriptor.fromBytes(resizedData.buffer.asUint8List());
        });
      }
    } catch (e) {
      print('Error creating truck icon: $e');
    }
  }

  /// Loads the saved delivery location from local storage
  /// Updates the map markers and starts route simulation
  Future<void> _loadSavedLocation() async {
    try {
      final location = await LocalStorageService().getSavedLocation();
      if (location != null) {
        setState(() {
          _savedLocation = LatLng(location.latitude, location.longitude);
          _addDestinationMarker();
        });
        await _getRouteAndStartSimulation();
      }
    } catch (e) {
      print('Error loading saved location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Adds a marker for the store location on the map
  void _addStoreMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('store'),
        position: _storeLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Store Location'),
      ),
    );
  }

  /// Adds a marker for the delivery destination
  void _addDestinationMarker() {
    if (_savedLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _savedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Delivery Location'),
        ),
      );
    }
  }

  /// Updates the driver's marker position on the map
  void _updateDriverMarker() {
    if (_driverLocation != null) {
      _markers.removeWhere((marker) => marker.markerId.value == 'driver');
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverLocation!,
          icon: _truckIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'Driver Location'),
        ),
      );
    }
  }

  /// Gets the route between store and destination
  /// Starts the driver simulation along the route
  Future<void> _getRouteAndStartSimulation() async {
    if (_savedLocation == null) return;

    try {
      final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${_storeLocation.latitude},${_storeLocation.longitude}'
          '&destination=${_savedLocation!.latitude},${_savedLocation!.longitude}'
          '&mode=driving'
          '&key=$googleAPiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == 'OK') {
          final points = decoded['routes'][0]['overview_polyline']['points'];
          _routePoints = _decodePolyline(points);

          // Start with driver at store location
          _driverLocation = _storeLocation;
          _updateDriverMarker();

          setState(() {
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: const Color(0xFF2196F3),
                points: _routePoints,
                width: 8,
              ),
            );
          });

          // Start the simulation
          _startRouteSimulation();

          // Adjust map bounds to show the entire route
          _updateMapBounds();
        }
      }
    } catch (e) {
      print('Error getting route: $e');
    }
  }

  /// Decodes a Google Maps encoded polyline into a list of LatLng points
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }

  /// Starts the simulation of the driver moving along the route
  void _startRouteSimulation() {
    _simulationTimer?.cancel();
    _currentRouteIndex = 0;

    _simulationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentRouteIndex < _routePoints.length) {
        setState(() {
          _driverLocation = _routePoints[_currentRouteIndex];
          _updateDriverMarker();
        });
        _currentRouteIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  /// Updates the map bounds to show the entire route
  void _updateMapBounds() {
    if (_mapController != null && _routePoints.isNotEmpty) {
      double minLat = _routePoints[0].latitude;
      double maxLat = _routePoints[0].latitude;
      double minLng = _routePoints[0].longitude;
      double maxLng = _routePoints[0].longitude;

      for (var point in _routePoints) {
        minLat = min(minLat, point.latitude);
        maxLat = max(maxLat, point.latitude);
        minLng = min(minLng, point.longitude);
        maxLng = max(maxLng, point.longitude);
      }

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          50.0,
        ),
      );
    }
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.local_shipping_rounded,
                        color: Colors.white, size: 40),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Track Your Order',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            'Watch your delivery in real-time',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Map Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Stack(
                            children: [
                              GoogleMap(
                                onMapCreated: (controller) =>
                                    _mapController = controller,
                                initialCameraPosition: CameraPosition(
                                  target: _storeLocation,
                                  zoom: 15,
                                ),
                                markers: _markers,
                                polylines: _polylines,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                                mapToolbarEnabled: false,
                              ),
                              // Custom controls overlay
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.my_location),
                                        onPressed: () {
                                          if (_mapController != null &&
                                              _driverLocation != null) {
                                            _mapController!.animateCamera(
                                              CameraUpdate.newLatLngZoom(
                                                _driverLocation!,
                                                16,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.zoom_out_map),
                                        onPressed: _updateMapBounds,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              if (_mapController != null) {
                                                _mapController!.animateCamera(
                                                  CameraUpdate.zoomIn(),
                                                );
                                              }
                                            },
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              if (_mapController != null) {
                                                _mapController!.animateCamera(
                                                  CameraUpdate.zoomOut(),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Back button at bottom
              Center(
                child: CustomBackButton(),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
