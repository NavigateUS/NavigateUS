# NavigateUS

A new Flutter project created for Orbital 2022. NavigateUS is a simple navigation app for the NUS Kent Ridge Campus on iOS and android devices.

## Getting Started

1. Download and install Android Studio and Flutter.
2. Clone this repository
3. Get an [API key](https://cloud.google.com/maps-platform/) from Google Maps Platform
4. Enable Google Map SDK for each platform according to [this guide](https://pub.dev/packages/google_maps_flutter).
5. Also enable Directions API and Distance Matrix API in the Google Maps Platform.
6. Under Billing, enter your billing information. Google provides $200 usage per month for no charge.
7. Input your API key by replacing ```YOURKEYHERE``` in ```lib/key.dart``` to the API key from above.

#### Android

In ```android/app/src/main/AndroidManifest.xml```, change ```YOURKEYHERE``` in
```
<meta-data android:name="com.google.android.geo.API_KEY"
            android:value="YOURKEYHERE"/>
```
to the API key from above.

#### iOS

In ```ios/Runner/AppDelegate.swift```, change ```YOURKEYHERE``` in
```
GMSServices.provideAPIKey("YOURKEYHERE")
```
to the API key from above.