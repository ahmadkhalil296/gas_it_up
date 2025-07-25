import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic_services/screens/order/get_payment_method.dart';
import 'package:mechanic_services/widgets/input_field.dart';

import '../../services/local_storage_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';

class GetAddress extends StatefulWidget {
  const GetAddress({super.key});

  @override
  State<GetAddress> createState() => _GetAddressState();
}

class _GetAddressState extends State<GetAddress> {
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  String? selectedGovernorate;
  bool isDropdownOpen = false;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _selectedLocation;
  bool _isLoading = true;

  // List of governorates in Lebanon
  final List<String> governorates = [
    'Beirut',
    'Mount Lebanon',
    'North Lebanon',
    'South Lebanon',
    'Beqaa',
    'Nabatiyeh',
    'Akkar',
    'Baalbek-Hermel'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _updateMarker();
        _isLoading = false;
      });
    } catch (e) {
      print('Error getting location: $e');
      setState(() => _isLoading = false);
    }
  }

  void _updateMarker() {
    if (_selectedLocation != null) {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedLocation!,
          draggable: true,
          onDragEnd: (newPosition) {
            setState(() {
              _selectedLocation = newPosition;
            });
          },
        ),
      );
    }
  }

  String? _validate(String? value) {
    if (value == null || value == '') {
      return 'value cannot be empty';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value == '') {
      return 'city cannot be empty';
    }
    // Check if the city contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'city can only contain letters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 35),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your Address',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontSize: 32,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Address Form
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(8, 174, 234, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Governorate',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: selectedGovernorate,
                    dropdownColor: Color.fromRGBO(8, 174, 234, 1),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    menuMaxHeight: 300,
                    borderRadius: BorderRadius.circular(20),
                    items: governorates.map((String governorate) {
                      return DropdownMenuItem<String>(
                        value: governorate,
                        child: Text(governorate),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGovernorate = newValue;
                        isDropdownOpen = false;
                      });
                    },
                    onTap: () {
                      setState(() {
                        isDropdownOpen = true;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              InputField(
                  validator: _validateCity,
                  controller: cityController,
                  hintText: 'City ',
                  inputType: TextInputType.text,
                  lettersOnly: true,
                  onChanged: (value) {
                    if (value == null) return;
                    String lettersOnly =
                        value.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');
                    if (lettersOnly != value) {
                      cityController.text = lettersOnly;
                      cityController.selection = TextSelection.fromPosition(
                        TextPosition(offset: lettersOnly.length),
                      );
                    }
                  }),
              SizedBox(height: 20),
              InputField(
                  validator: _validate,
                  controller: streetController,
                  hintText: 'Street'),
              SizedBox(height: 20),
              // Map Container
              Text(
                'Pin Your Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _selectedLocation ??
                                  const LatLng(
                                      33.8938, 35.5018), // Default to Beirut
                              zoom: 15,
                            ),
                            onMapCreated: (controller) =>
                                _mapController = controller,
                            markers: _markers,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            onTap: (position) {
                              setState(() {
                                _selectedLocation = position;
                                _updateMarker();
                              });
                            },
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomBackButton(),
                  CustomNextButton(onPressed: () async {
                    String? city = cityController.text.trim();
                    String? street = streetController.text.trim();

                    if (city.isEmpty ||
                        street.isEmpty ||
                        selectedGovernorate == null ||
                        _selectedLocation == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Please fill all fields and select a location on the map'),
                      ));
                      return;
                    }

                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(city)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('City can only contain letters'),
                      ));
                      return;
                    }

                    // Save location data
                    await LocalStorageService().save(
                        'location',
                        jsonEncode({
                          'latitude': _selectedLocation!.latitude,
                          'longitude': _selectedLocation!.longitude,
                        }));

                    await LocalStorageService()
                        .save('governorate', jsonEncode(selectedGovernorate));
                    await LocalStorageService().save('city', jsonEncode(city));
                    await LocalStorageService()
                        .save('street', jsonEncode(street));

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GetPaymentMethod()));
                  })
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
