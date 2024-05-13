# Flutter ChatGPT Assistant

An example of using OpenAI ChatGPT together with Speech-to-Text and Text-to-Speech in a Flutter project

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setup Firebase

To connect to your own Firebase database, follow these steps:

### Step 1: Create Your Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Click on "Add project" and follow the instructions to create a new project.

### Step 2: Add Firebase to Your Application

#### For Android:
1. In the Firebase console, select your project.
2. Go to the 'Project settings' and under 'Your apps', click on the Android icon to add an Android app.
3. Enter your app’s package name which you can find in your project's `AndroidManifest.xml` file.
4. Follow the instructions to download the `google-services.json` file and place it into the `android/app` directory of your project.

#### For iOS:
1. In the Firebase Console, under your project settings, use the iOS icon to add an iOS app.
2. Enter your iOS bundle ID which you can find in your project's `Info.plist` file.
3. Download the `GoogleService-Info.plist` file and include it in your Xcode project at the root of your app directory.


