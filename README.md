# Location-based Services App in Flutter

This Flutter application demonstrates location-based services, allowing users to store their current location along with address details in a SQLite database. It provides a user-friendly interface with a map view where users can view their current location, store new coordinates, and manage previously stored data.

## Features

- **User Interface:** Simple and intuitive interface with a map view.
- **Location Data Collection:** Allows users to collect GPS coordinates and store them along with address details.
- **Database Storage:** Stores collected coordinates and address details in a local SQLite database for offline access.
- **View and Delete:** Users can view and delete previously stored coordinates.
- **Draw Lines:** Draws lines on the map connecting collected GPS coordinates, creating a visual path.
- **Export Data:** Enables users to export stored data as a CSV file.(Note: CSV export will not work on iOS devices).
- **Error Handling:** Implements proper error handling for scenarios such as no GPS signal and database errors.
- **Unit Testing:** Includes unit tests for storing coordinates in the SQLite database.
- **Optimization:** Stores address details along with coordinates to improve application performance.
- **Modular Coding:** Utilizes the BLoC pattern for clean and modular coding.

## Instructions

1. Clone the repository.
2. Open the project in a Flutter-compatible IDE.
3. Run the application on a simulator or physical device.

### Installation

Follow these steps to install and run the Assignment

1. **Clone the repository:**

   ```bash
   $ git clone https://github.com/PatelPruthvi/mapsense_assignment.git

2. **Navigate to Project Directory**
   
   ```bash
   $ cd mapsense_assignment
3. **Install dependencies**
   
   ```bash
   $ flutter pub get
   
4. **Replace API Key in AndroidManifest.xml and AppDelegate.swift**
Replace 'YOUR_API_KEY' in the AndroidManifest.xml file located in the android/app/src/main directory with your Google Maps API key. Similarly, replace 'YOUR_API_KEY' with your Google Maps API key in the AppDelegate.swift file in the ios/Runner directory using the GMSServices.provideApiKey('YOUR_API_KEY') method.
5. **Run application**

   ```bash
   $ flutter run

## Development Details

- **Libraries Used:** Utilizes Flutter packages for location-based services and the BLoC pattern for clean and modular coding.
- **Design Decisions:** Focuses on clean code, modular design, and adherence to Flutter best practices.
- **Challenges Faced:** Overcame challenges in error handling and optimizing database operations.
- **Version Control:** Managed the project using Git and hosted the repository on GitHub.

## Screenshots and Demo

<img height="400" alt="image" src="https://github.com/PatelPruthvi/mapsense_assignment/assets/71627511/cf033e80-b250-4988-bcfa-b0cb1ffe77a2">
<img height="400" alt="image" src="https://github.com/PatelPruthvi/mapsense_assignment/assets/71627511/f71713ca-cb86-4457-be2c-127ec1972fc0">
<img height="400" alt="image" src="https://github.com/PatelPruthvi/mapsense_assignment/assets/71627511/a5ed5a3b-68cd-4014-afb6-731e4bea24df">
<img height="400" alt="image" src="https://github.com/PatelPruthvi/mapsense_assignment/assets/71627511/556e9f53-4423-4b07-ab98-1b42729b76b5">
<img height="400" alt="image" src="https://github.com/PatelPruthvi/mapsense_assignment/assets/71627511/17b6b372-1bbf-4884-9126-e0ffe68005ac">

- [Video Demo & Download APK](#) [Click Here](https://drive.google.com/drive/folders/18-kUBZ4hsa9_E0KBZHio35NN6AGfsDSV?usp=share_link)
