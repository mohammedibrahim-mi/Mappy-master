import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mappy/utils/helpers/config.helper.dart';
import 'package:mappy/utils/helpers/location.helper.dart';

import '../../blocs/geocoding.bloc.dart';
import '../../blocs/geocoding.event.dart';
import '../../blocs/geocoding.state.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MapboxMapController _mapController;
    return Scaffold(
      body: Stack(
        children: [

          FutureBuilder(
            future: loadConfigFile(),
            builder: (
                BuildContext cntx,
                AsyncSnapshot<Map<String, dynamic>> snapshot,
                ) {
              if (snapshot.hasData) {
                final String token = snapshot.data['mapbox_api_token'] as String;
                final String style = snapshot.data['mapbox_style_url'] as String;
                return MapboxMap(
                  accessToken: token,
                  styleString: style,
                  minMaxZoomPreference: const MinMaxZoomPreference(6.0, null),
                  initialCameraPosition: CameraPosition(
                    zoom: 16.0,
                    target: LatLng(40.508, 40.048),

                  ),
                  onMapCreated: (MapboxMapController controller) async {
                    _mapController = controller;
                    final result = await acquireCurrentLocation();
                    await controller.animateCamera(
                      CameraUpdate.newLatLng(result),
                    );

                    // await controller.addCircle(
                    //   CircleOptions(
                    //     circleRadius: 8.0,
                    //     circleColor: '#006992',
                    //     circleOpacity: 0.8,
                    //     geometry: result,
                    //     draggable: false,
                    //   ),
                    // );
                  },
                  onMapClick: (Point<double> point, LatLng coordinates) {
                    BlocProvider.of<GeocodingBloc>(context)
                      ..add(
                        RequestGeocodingEvent(
                          latitude: coordinates.latitude,
                          longitude: coordinates.longitude,
                        ),
                      );
                    _setupBottomModalSheet(cntx);
                  },
                  onMapLongClick: (Point<double> point, LatLng coordinates) async {
                    // final ByteData imageBytes =
                    // await rootBundle.load('assets/mappy_icon.png');
                    // final Uint8List bytesList = imageBytes.buffer.asUint8List();
                    // await _mapController.addImage('assets/mappy_icon.png', bytesList);
                    // await _mapController.addSymbol(
                    //   SymbolOptions(
                    //     iconImage: 'place_icon',
                    //     iconSize: 2.5,
                    //     geometry: coordinates,
                    //   ),
                    // );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text('Error has occurred: ${snapshot.error.toString()}')
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Image.asset(
              "assets/loader.gif",
              height: 125.0,
              width: 125.0,
            ),
          ),
          // BlocBuilder<GeocodingBloc, GeocodingState>(
          //   builder: (BuildContext cntx, GeocodingState state) {
          //     if (state is LoadingGeocodingState) {
          //       return Container(
          //         height: 158.0,
          //         child: Center(
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               CircularProgressIndicator(),
          //               SizedBox(
          //                 height: 16.0,
          //               ),
          //               Text('Loading results')
          //             ],
          //           ),
          //         ),
          //       );
          //     } else if (state is SuccessfulGeocodingState) {
          //       final latitudeString =
          //       state.result.coordinates.latitude.toStringAsPrecision(5);
          //       final longitudeString =
          //       state.result.coordinates.longitude.toStringAsPrecision(5);
          //       return Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Container(
          //           child: Text(state.result.placeName),
          //
          //           color: Colors.red,
          //           height: 50.0,)
          //       );
          //     } else if (state is FailedGeocodingState) {
          //       return ListTile(
          //         title: Text('Error'),
          //         subtitle: Text(state.error),
          //       );
          //     } else {
          //       return ListTile(
          //         title: Text('Error'),
          //         subtitle: Text('Unknown error'),
          //       );
          //     }
          //   },
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_on_sharp),
        onPressed: () async {
          final result = await acquireCurrentLocation();
          _mapController.animateCamera(CameraUpdate.newLatLng(result));
        },
      ),
    );
  }

  void _setupBottomModalSheet(BuildContext buildContext) {
    showModalBottomSheet(
      context: buildContext,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocBuilder<GeocodingBloc, GeocodingState>(
          builder: (BuildContext cntx, GeocodingState state) {
            if (state is LoadingGeocodingState) {
              return Container(
                height: 158.0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text('Loading results')
                    ],
                  ),
                ),
              );
            } else if (state is SuccessfulGeocodingState) {
              final latitudeString =
                  state.result.coordinates.latitude.toStringAsPrecision(5);
              final longitudeString =
                  state.result.coordinates.longitude.toStringAsPrecision(5);
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: 150.0,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: new LinearGradient(
                          colors: [Colors.yellow,Colors.blue],
                          begin: Alignment.topCenter,
                          //const FractionalOffset(0.0, 0.5),
                          end: Alignment.bottomCenter,
                          //const FractionalOffset(1.0, 0.6),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp
                        // colors: AppColors.blue_color,
                      ),


                  ),
                  child: Wrap(
                    children: [
                      ListTile(
                        title: Text('Coordinates (latitude/longitude)'),
                        subtitle: Text(
                          '$latitudeString/$longitudeString',
                        ),
                      ),
                      ListTile(
                        title: Text('Place name'),
                        subtitle: Text(state.result.placeName),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is FailedGeocodingState) {
              return ListTile(
                title: Text('Error'),
                subtitle: Text(state.error),
              );
            } else {
              return ListTile(
                title: Text('Error'),
                subtitle: Text('Unknown error'),
              );
            }
          },
        );
      },
    );
  }
}
