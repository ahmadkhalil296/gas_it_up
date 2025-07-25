import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/back_button.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  List<Map<String, dynamic>> _services = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _categories = [
    'Fuel Delivery',
    'Car Wash',
    'Tire Change',
    'Other Services',
    'Car Accessories'
  ];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _initializeMainServices();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _initializeMainServices() async {
    setState(() => _isLoading = true);
    try {
      // Check if services collection is empty
      QuerySnapshot serviceSnapshot = await _firestore.collection('services').get();
      
      // Get existing services to check for car accessories
      List<String> existingServices = serviceSnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
          .toList();

      // Add categorized services
      final mainServices = [
        // Fuel Delivery Category
        {
          'name': 'Gasoline 91',
          'category': 'Fuel Delivery',
          'price': 5.0,
          'description': 'Regular unleaded gasoline delivery (91 octane)',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Gasoline 95',
          'category': 'Fuel Delivery',
          'price': 6.0,
          'description': 'Premium unleaded gasoline delivery (95 octane)',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Diesel',
          'category': 'Fuel Delivery',
          'price': 5.5,
          'description': 'Diesel fuel delivery service',
          'created_at': FieldValue.serverTimestamp(),
        },
        
        // Car Wash Category
        {
          'name': 'Exterior Wash',
          'category': 'Car Wash',
          'price': 3.0,
          'description': 'Exterior washing including body, windows, mirrors, tires, and rims',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Interior Wash',
          'category': 'Car Wash',
          'price': 3.0,
          'description': 'Interior cleaning including vacuuming, dashboard, and seats',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Full Service Wash',
          'category': 'Car Wash',
          'price': 5.0,
          'description': 'Complete interior and exterior cleaning with additional detailing',
          'created_at': FieldValue.serverTimestamp(),
        },

        // Tire Change Category
        {
          'name': 'Tire Inflation',
          'category': 'Tire Change',
          'price': 2.0,
          'description': 'Check and adjust tire pressure to recommended levels',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Tire Repair',
          'category': 'Tire Change',
          'price': 3.0,
          'description': 'Fix punctures and minor tire damage',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Tire Change',
          'category': 'Tire Change',
          'price': 3.0,
          'description': 'Complete tire replacement service',
          'created_at': FieldValue.serverTimestamp(),
        },

        // Other Services Category
        {
          'name': 'Battery Jump Start',
          'category': 'Other Services',
          'price': 3.0,
          'description': 'Jump start service for dead batteries',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Battery Replacement',
          'category': 'Other Services',
          'price': 4.0,
          'description': 'Complete battery replacement service with new battery',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Car Scanner',
          'category': 'Other Services',
          'price': 3.0,
          'description': 'Basic diagnostic scan to identify error codes',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Oil Change',
          'category': 'Other Services',
          'price': 3.0,
          'description': 'Standard oil change service with regular oil',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Coolant Service',
          'category': 'Other Services',
          'price': 5.0,
          'description': 'Coolant level check, top-up, or replacement',
          'created_at': FieldValue.serverTimestamp(),
        },

        // Car Accessories Category
        {
          'name': 'Wiper Blades',
          'category': 'Car Accessories',
          'price': 15.0,
          'description': 'High-quality windshield wiper blades',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Headlight',
          'category': 'Car Accessories',
          'price': 35.0,
          'description': 'Replacement headlight units',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Water Pump',
          'category': 'Car Accessories',
          'price': 25.0,
          'description': 'Engine cooling system water pump',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Fuel Pump',
          'category': 'Car Accessories',
          'price': 35.0,
          'description': 'Replacement fuel pump unit',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Clutch',
          'category': 'Car Accessories',
          'price': 75.0,
          'description': 'Complete clutch replacement kit',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Air Filter',
          'category': 'Car Accessories',
          'price': 12.0,
          'description': 'Engine air filter replacement',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Oil Filter',
          'category': 'Car Accessories',
          'price': 8.0,
          'description': 'Engine oil filter replacement',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Brake Pads',
          'category': 'Car Accessories',
          'price': 45.0,
          'description': 'Front brake pad set (pair)',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Brake Rotors',
          'category': 'Car Accessories',
          'price': 55.0,
          'description': 'Front brake rotors (pair)',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Spark Plugs',
          'category': 'Car Accessories',
          'price': 20.0,
          'description': 'Set of 4 spark plugs',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Battery',
          'category': 'Car Accessories',
          'price': 85.0,
          'description': 'Car battery replacement',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Alternator',
          'category': 'Car Accessories',
          'price': 95.0,
          'description': 'Car alternator replacement',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Starter Motor',
          'category': 'Car Accessories',
          'price': 65.0,
          'description': 'Engine starter motor replacement',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Radiator',
          'category': 'Car Accessories',
          'price': 120.0,
          'description': 'Engine radiator replacement',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Thermostat',
          'category': 'Car Accessories',
          'price': 15.0,
          'description': 'Engine thermostat replacement',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Timing Belt',
          'category': 'Car Accessories',
          'price': 45.0,
          'description': 'Engine timing belt replacement',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Serpentine Belt',
          'category': 'Car Accessories',
          'price': 25.0,
          'description': 'Engine serpentine belt replacement',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Shock Absorbers',
          'category': 'Car Accessories',
          'price': 85.0,
          'description': 'Front shock absorbers (pair)',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Struts',
          'category': 'Car Accessories',
          'price': 95.0,
          'description': 'Front struts (pair)',
          'created_at': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Control Arms',
          'category': 'Car Accessories',
          'price': 75.0,
          'description': 'Front control arms (pair)',
          'created_at': FieldValue.serverTimestamp(),
        }
      ];

      // Add each service to Firestore if it doesn't exist
      for (var service in mainServices) {
        if (!existingServices.contains(service['name'])) {
          await _firestore.collection('services').add(service);
        }
      }
      _fetchServices(); // Fetch all services after initialization
    } catch (e) {
      print('Error initializing services: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchServices() async {
    setState(() => _isLoading = true);
    try {
      QuerySnapshot serviceSnapshot = await _firestore.collection('services').get();
      setState(() {
        _services = serviceSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching services: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _addService() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      try {
        await _firestore.collection('services').add({
          'name': _nameController.text,
          'category': _selectedCategory,
          'price': double.parse(_priceController.text),
          'description': _descriptionController.text,
          'created_at': FieldValue.serverTimestamp(),
        });
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _selectedCategory = null;
        _fetchServices();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service added successfully')),
        );
      } catch (e) {
        print('Error adding service: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add service')),
        );
      }
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
    }
  }

  Future<void> _deleteService(String serviceId) async {
    try {
      await _firestore.collection('services').doc(serviceId).delete();
      _fetchServices();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service deleted successfully')),
      );
    } catch (e) {
      print('Error deleting service: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete service')),
      );
    }
  }

  Future<void> _editService(Map<String, dynamic> service) async {
    _nameController.text = service['name'] ?? '';
    _priceController.text = service['price']?.toString() ?? '';
    _descriptionController.text = service['description'] ?? '';
    _selectedCategory = service['category'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Service'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Service Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter a price';
                    if (double.tryParse(value!) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a description' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _selectedCategory = null;
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && _selectedCategory != null) {
                try {
                  await _firestore.collection('services').doc(service['id']).update({
                    'name': _nameController.text,
                    'category': _selectedCategory,
                    'price': double.parse(_priceController.text),
                    'description': _descriptionController.text,
                    'updated_at': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                  _selectedCategory = null;
                  _fetchServices();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Service updated successfully')),
                  );
                } catch (e) {
                  print('Error updating service: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update service')),
                  );
                }
              } else if (_selectedCategory == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a category')),
                );
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAddServiceDialog() {
    _selectedCategory = null;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Service'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Service Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter a price';
                    if (double.tryParse(value!) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a description' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _selectedCategory = null;
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addService();
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group services by category
    Map<String, List<Map<String, dynamic>>> categorizedServices = {};
    for (var service in _services) {
      String category = service['category'] ?? 'Uncategorized';
      if (!categorizedServices.containsKey(category)) {
        categorizedServices[category] = [];
      }
      categorizedServices[category]!.add(service);
    }

    // Define the desired category order
    final categoryOrder = [
      'Fuel Delivery',
      'Car Wash',
      'Tire Change',
      'Other Services',
      'Car Accessories'
    ];

    // Sort the categories according to the specified order
    final sortedCategories = categoryOrder.where((category) => 
      categorizedServices.containsKey(category)).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddServiceDialog,
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Manage Services',
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                ],
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: _services.isEmpty
                          ? Center(child: Text('No services found'))
                          : ListView.builder(
                              itemCount: sortedCategories.length,
                              itemBuilder: (context, index) {
                                String category = sortedCategories[index];
                                List<Map<String, dynamic>> services = categorizedServices[category]!;
                                
                                return Card(
                                  color: Color.fromRGBO(16, 56, 127, 1.0),
                                  margin: EdgeInsets.only(bottom: 16),
                                  child: ExpansionTile(
                                    title: Text(
                                      category,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    children: services.map((service) => Card(
                                      color: Color.fromRGBO(16, 56, 127, 0.8),
                                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: ExpansionTile(
                                        title: Text(
                                          service['name'] ?? 'Unknown Service',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          '\$${service['price']?.toStringAsFixed(2) ?? '0.00'}',
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit, color: Colors.white),
                                              onPressed: () => _editService(service),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red),
                                              onPressed: () => _deleteService(service['id']),
                                            ),
                                          ],
                                        ),
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Description:',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  service['description'] ?? 'No description available',
                                                  style: TextStyle(color: Colors.white70),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                                  ),
                                );
                              },
                            ),
                    ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: const CustomBackButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 