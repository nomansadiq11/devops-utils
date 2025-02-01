# How we can build the iOS Application using github-action

## Github Action file

```yaml

name: iOS Build

on:
  branch:
    - main

jobs:
  build-and-distribute:
    name: Build
    runs-on: macos-latest

    steps:
      # Step 1: Checkout the code
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Check Xcode Version
        run: xcodebuild -version

      - name: Check Available SDKs
        run: xcodebuild -showsdks

      - name: Clean Derived Data
        run: |
          rm -rf ~/Library/Developer/Xcode/DerivedData

      Step 2: Install CocoaPods
      - name: Install CocoaPods
        run: |
          sudo gem install cocoapods
          pod install
        working-directory: ./

      Step 5: Build and Archive the App
      - name: Build and Archive
        run: |
          xcodebuild clean archive \
          -workspace project.xcworkspace \
          -scheme {scheme} \
          -sdk iphoneos \
          -configuration Release \
          -archivePath ./build/project.xcarchive

      - name: Export IPA
        run: |
          xcodebuild -exportArchive \
          -archivePath ./build/YourApp.xcarchive \
          -exportPath ./build \
          -exportOptionsPlist ./YourProjectDirectory/exportOptions.plist



```
