# IntegrationExampleMSDK-iOS

## ⭐️ About
Integration Example app for iOS is primarily meant for Mimi's partners to help them integrate the iOS MSDK into their apps.

## 📋 Requirements

Requires iOS 16 and Swift 5.

## 🖥 Set Up

To build the project you need the following pre-requisites:
- Your Mimi Client Secret to allow you to communicate with the Mimi API
- [Sourcery](https://github.com/krzysztofzablocki/Sourcery) (`brew install sourcery`).
- [Xcode 14](https://apps.apple.com/gb/app/xcode/id497799835?mt=12) (or latest available) installed including the Xcode Command Line Tools.
- MimiSDK frameworks

Then, clone the project and do the following:
- Open `IntegrationExample.xcodeproj`.
- Copy over the `MimiSDK` xcframework files into the `IntegrationExample/Frameworks` folder.
- Set the `MIMI_CLIENT_SECRET` value in `Secrets.xcconfig`.
   - To ignore changes to this file in Git run the following `git update-index --skip-worktree Secrets.xcconfig`.
- Build/Run to your heart's content.
