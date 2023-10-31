import 'package:cp_weather/data/image_path.dart';
import 'package:cp_weather/services/location_provider.dart';
import 'package:cp_weather/services/weather_service_provider.dart';
import 'package:cp_weather/utils/apptext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/custom_divider_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 20) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  @override
  void initState() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city.toString())
              .then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        }
      }
    });

    super.initState();
  }

  bool _isLoading = true;

  final TextEditingController _cityController = TextEditingController();
  final bool _clicked = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final locationProvider = Provider.of<LocationProvider>(context);

// Get the weather data from the WeatherServiceProvider
    final weatherProvider = Provider.of<WeatherServiceProvider>(context);
// Inside the build method of your _HomePageState class

// Get the sunrise timestamp from the API response
    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ??
        0; // Replace 0 with a default timestamp if needed
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ??
        0; // Replace 0 with a default timestamp if needed

// Convert the timestamp to a DateTime object
    DateTime sunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

// Format the sunrise time as a string
    String formattedSunrise = DateFormat.jm().format(sunriseDateTime);
    String formattedSunset = DateFormat.jm().format(sunsetDateTime);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.greenAccent,
                strokeWidth: 10,
                color: Colors.white,
                strokeAlign: 3,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 65, left: 20, right: 20, bottom: 20),
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          background[
                                  weatherProvider.weather?.weather![0].main ??
                                      "N/A"] ??
                              "assets/img/default.png",
                        ))),
                child: Stack(
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(14)),
                      width: 170,
                      child: Consumer<LocationProvider>(
                          builder: (context, locationProvider, child) {
                        String? locationCity;
                        if (locationProvider.currentLocationName != null) {
                          locationCity = locationProvider.currentLocationName!
                              .subLocality; // here you can choose which location area shoul show on ui
                        } else {
                          locationCity = "Unknown Location";
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 26),
                                  child: Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      data: locationCity,
                                      color: Colors.white,
                                      fw: FontWeight.w700,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Colors.grey, // Border color
                                          width: 2.0, // Border width
                                        ),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.red,
                                            Colors.blue
                                          ], // Gradient colors
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.limeAccent
                                                .withOpacity(0.6),
                                            blurRadius: 5.0,
                                            offset: const Offset(0,
                                                2), // Shadow offset (horizontal, vertical)
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: AppText(
                                          data: getGreeting(),
                                          letterSpacing: 2,
                                          color:
                                              Colors.white12.withOpacity(0.8),
                                          fw: FontWeight.w700,
                                          size: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                    Align(
                      alignment: const Alignment(0, -0.7),
                      child: Image.asset(
                        imagePath[weatherProvider.weather?.weather![0].main ??
                                "N/A"] ??
                            "assets/img/default.png",
                        // Adjust the height as needed
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0),
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              data:
                                  "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0)} \u00B0C", // Display temperature
                              color: Colors.white,
                              fw: FontWeight.bold,
                              size: 32,
                            ),
                            AppText(
                              data: weatherProvider.weather?.name ?? "N/A",
                              color: Colors.white,
                              fw: FontWeight.w600,
                              size: 20,
                            ),
                            AppText(
                              data: weatherProvider.weather?.weather![0].main ??
                                  "N/A",
                              color: Colors.white,
                              fw: FontWeight.w600,
                              size: 20,
                            ),
                            AppText(
                              fw: FontWeight.w800,
                              data:
                                  DateFormat('d/M/yyyy').format(DateTime.now()),
                              color: Colors.white70,
                              size: 12,
                            ),
                            AppText(
                              fw: FontWeight.w900,
                              data: DateFormat('EEEE - h:mm a')
                                  .format(DateTime.now()),
                              color: Colors.white,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, 0.75),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.4)),
                        height: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/img/temperature-high.png',
                                      height: 55,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AppText(
                                          data: "Temp Max",
                                          color: Colors.white,
                                          size: 14,
                                          fw: FontWeight.w600,
                                        ),
                                        AppText(
                                          data:
                                              "${weatherProvider.weather?.main!.tempMax!.toStringAsFixed(0)} \u00B0C",
                                          color: Colors.white,
                                          size: 14,
                                          fw: FontWeight.w600,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/img/temperature-low.png',
                                      height: 55,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AppText(
                                          data: "Temp Min",
                                          color: Colors.white,
                                          size: 14,
                                          fw: FontWeight.w600,
                                        ),
                                        AppText(
                                          data:
                                              "${weatherProvider.weather?.main!.tempMin!.toStringAsFixed(0)} \u00B0C",
                                          color: Colors.white,
                                          size: 14,
                                          fw: FontWeight.w600,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            CustomDivider(
                              startIndent: 20,
                              endIndent: 20,
                              color: Colors.white,
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/img/sun.png',
                                      height: 55,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AppText(
                                          data: "Sunrise",
                                          color: Colors.white,
                                          size: 14,
                                          fw: FontWeight.w600,
                                        ),
                                        AppText(
                                          data: formattedSunrise,
                                          color: Colors.white,
                                          size: 14,
                                          fw: FontWeight.w600,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/img/moon.png',
                                      height: 50,
                                      width: 40,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AppText(
                                          data: "Sunset",
                                          color: Colors.white,
                                          size: 14,
                                          fw: FontWeight.w600,
                                        ),
                                        AppText(
                                          data: formattedSunset,
                                          color: Colors.white,
                                          size: 14,
                                          fw: FontWeight.w600,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      right: 1,
                      child: SizedBox(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: _isSearching,
                              child: SizedBox(
                                width: 140,
                                height: 44,
                                child: TextFormField(
                                  cursorColor: Colors.green,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  controller: _cityController,
                                  onFieldSubmitted: (value) {
                                    // Trim the input text
                                    final cityName = value.trim();
                                    _cityController.text =
                                        cityName; // Update the text in the text field without trailing spaces
                                    Provider.of<WeatherServiceProvider>(context,
                                            listen: false)
                                        .fetchWeatherDataByCity(cityName);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    hintText: "Search City",
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      letterSpacing: 1,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: _isSearching
                                    ? Colors.green.withOpacity(0.7)
                                    : Colors.black38,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white30, // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isSearching = !_isSearching;
                                    });
                                    Provider.of<WeatherServiceProvider>(context,
                                            listen: false)
                                        .fetchWeatherDataByCity(
                                            _cityController.text.toString());
                                    _cityController.text.trim();
                                  },
                                  icon: Icon(
                                    _isSearching
                                        ? Icons.find_replace
                                        : Icons.search,
                                    size: 30,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
