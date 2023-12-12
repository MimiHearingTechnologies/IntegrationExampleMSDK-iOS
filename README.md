# IntegrationExampleMSDK-iOS

## ⭐️ About
Integration Example app for iOS is primarily meant for Mimi's partners to help them integrate the iOS MSDK into their apps.

> **Note**
> The Integration Example app is meant to accompany the `Headphone Integration Guide For Mobile Applications`. We strongly recommend reading the guide first as this would greatly improve the understanding of the code in this project. Please contact us if you did not receive a copy of the guide already.

## 📋 Requirements

To build the project you need the following pre-requisites:
- Your Mimi Client Id and Secret to allow you to communicate with the Mimi API.
- [Sourcery](https://github.com/krzysztofzablocki/Sourcery) (`brew install sourcery`).
- [Xcode 15](https://apps.apple.com/gb/app/xcode/id497799835?mt=12) (or latest available) installed including the Xcode Command Line Tools.

## 🖥 Building

Clone the project and do the following:
- Open `IntegrationExample.xcodeproj`.
- Set the `MIMI_CLIENT_ID` & `MIMI_CLIENT_SECRET` values in `Secrets.xcconfig`.
   - To ignore changes to this file in Git run the following `git update-index --skip-worktree Secrets.xcconfig`.
- Build/Run to your heart's content.

## 📃 Documentation

The Example app demonstrates the standard integration of the Mimi Profile and the use of the Mimi Processing APIs.

### Mimi Processing APIs
The code outlining the usage of the Mimi Processing APIs can be found under the `Processing` directory.

- `PartnerFirmwareController` - A mock implementation of an object that communicates with the `Mimi Processing Library` on the Mimi enabled device's firmware.
- `PartnerAudioProcessingController` - A mock audio processing controller which illustrates the usage of the Mimi Processing Parameter Applicators.
- `PartnerHeadphoneConnectivityController - A mock headphone connectivity controller which provides information on the currently connected headphone to the MSDK.
- `ProcessingView` & `ProcessingViewModel` - These files illustrate the usage of the Mimi Processing Parameters.

### Additional Documentation
- Headphone Integration Guide For Mobile Applications - Get in touch with us for a copy of the guide.
- [MSDK API Reference](https://mimihearingtechnologies.github.io/SDKDocs-iOS/master/)
