# IntegrationExampleMSDK-iOS

## ⭐️ About
Integration Example app for iOS is primarily meant for Mimi's partners to help them integrate the iOS MSDK into their apps.

## 📋 Requirements

To build the project you need the following pre-requisites:
- Xcode 14
- Your Mimi Client Id and Secret to allow you to communicate with the Mimi API.
- MimiSDK v7.3.0 frameworks.
- [Sourcery](https://github.com/krzysztofzablocki/Sourcery) (`brew install sourcery`).
- [Xcode 14](https://apps.apple.com/gb/app/xcode/id497799835?mt=12) (or latest available) installed including the Xcode Command Line Tools.

## 🖥 Set Up

Clone the project and do the following:
- Open `IntegrationExample.xcodeproj`.
- Copy over the `MimiSDK` xcframework files into the `IntegrationExample/Frameworks` folder.
- Set the `MIMI_CLIENT_ID` & `MIMI_CLIENT_SECRET` values in `Secrets.xcconfig`.
   - To ignore changes to this file in Git run the following `git update-index --skip-worktree Secrets.xcconfig`.
- Build/Run to your heart's content.
