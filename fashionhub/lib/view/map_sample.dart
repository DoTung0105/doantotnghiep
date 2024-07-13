import 'package:fashionhub/viewmodel/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapSample extends StatefulWidget {
  final Function(LatLng) onLocationPicked;
  final String? initialName;
  final String? initialPhone;
  final String? initialAddress;

  const MapSample({
    Key? key,
    required this.onLocationPicked,
    this.initialName,
    this.initialPhone,
    this.initialAddress,
  }) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController? mapController;
  LatLng _initialPosition = LatLng(10.771936, 106.701369);
  LatLng? _pickedLocation;
  bool _isMapAvailable = true;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isEditMode = false; // Track if in edit mode

  @override
  void initState() {
    super.initState();

    // Initialize controllers with initial values from props or Firebase data
    _locationController.text = widget.initialAddress ?? '';
    _nameController.text = widget.initialName ?? '';
    _phoneController.text = widget.initialPhone ?? '';

    _locationController.addListener(_validateInputs);
    _nameController.addListener(_validateInputs);
    _phoneController.addListener(_validateInputs);

    // Check if initial values are present to determine edit mode
    _isEditMode = _locationController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;

    _determinePosition().then((position) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    }).catchError((e) {
      print('Error getting location: $e');
      setState(() {
        _isMapAvailable = false;
      });
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _isButtonEnabled = _locationController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permission denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions permanently denied, we cannot request permissions.';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng location) async {
    setState(() {
      _pickedLocation = location;
    });
    await _updateLocationAddress(location);
  }

  Future<void> _goToCurrentLocation() async {
    try {
      final position = await _determinePosition();
      final currentLocation = LatLng(position.latitude, position.longitude);

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation, zoom: 17.0),
        ),
      );
      setState(() {
        _pickedLocation = currentLocation;
      });
      await _updateLocationAddress(currentLocation);
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  Future<void> _updateLocationAddress(LatLng location) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = '${placemark.street ?? ''}';
        if (placemark.subAdministrativeArea != null &&
            placemark.subAdministrativeArea!.isNotEmpty) {
          address += ', ${placemark.subAdministrativeArea}';
        }
        if (placemark.administrativeArea != null &&
            placemark.administrativeArea!.isNotEmpty) {
          address += ', ${placemark.administrativeArea}';
        }

        setState(() {
          _locationController.text =
              address.trim().isEmpty ? 'Unknown location' : address.trim();
        });
        print('Address: $address');
      } else {
        print('No placemarks found');
        setState(() {
          _locationController.text = 'Unknown location';
        });
      }
    } catch (e) {
      print('Error in reverse geocoding: $e');
      setState(() {
        _locationController.text = 'Unknown location';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(162, 57, 188, 173),
        title: Text(
          _isEditMode ? 'Chỉnh sửa địa chỉ' : 'Thêm địa chỉ mới',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 5,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1),
                  ),
                  child: _isMapAvailable
                      ? GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _initialPosition,
                            zoom: 15.0,
                          ),
                          mapType: MapType.terrain,
                          onTap: _onTap,
                          markers: _pickedLocation != null
                              ? {
                                  Marker(
                                    markerId: MarkerId('pickedLocation'),
                                    position: _pickedLocation!,
                                    infoWindow: InfoWindow(
                                      title: 'Đã chọn vị trí',
                                      snippet: 'Vị trí đã chọn để giao hàng',
                                    ),
                                    icon: BitmapDescriptor.defaultMarker,
                                  ),
                                }
                              : {},
                        )
                      : Center(
                          child: Text(
                            'Không có dữ liệu bản đồ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goToCurrentLocation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.my_location_outlined,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text('Vị trí hiện tại của bạn'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin địa chỉ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on_outlined),
                      hintText: 'Địa chỉ giao hàng',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_outlined),
                      hintText: 'Họ và Tên',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone_android_outlined),
                      hintText: 'Số điện thoại',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.0),
        child: ElevatedButton(
          onPressed: _isButtonEnabled
              ? () async {
                  final cart = Provider.of<Cart>(context, listen: false);
                  if (_isEditMode) {
                    await cart.updateDeliveryAddress(
                      _locationController.text,
                      _nameController.text,
                      _phoneController.text,
                    );
                  } else {
                    await cart.saveDeliveryAddress(
                      _locationController.text,
                      _nameController.text,
                      _phoneController.text,
                    );
                  }
                  Navigator.pop(context, {
                    'location': _locationController.text,
                    'name': _nameController.text,
                    'phone': _phoneController.text,
                    'pickedLocation': _pickedLocation,
                  });
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isButtonEnabled ? Colors.white : Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          child: Text(
            _isEditMode ? 'CẬP NHẬT' : 'HOÀN THÀNH',
            style: TextStyle(
              fontSize: 16.0,
              color: _isButtonEnabled ? Colors.black : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}
