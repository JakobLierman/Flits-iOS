<p align="center">
<img src="https://github.com/JakobLierman/Flits-iOS/raw/master/Flits/Assets.xcassets/icon_App.imageset/icon_App.png" width="200px"/>
</p>

<h1 align="center">Flits</h1>

iOS application to share police speed traps with other users. Created to learn iOS development using Swift.

## Screenshots

<p>
<img src="https://github.com/JakobLierman/Flits-iOS/raw/master/Screenshots/Open-speedcamera.gif" width="128px">
<img src="https://github.com/JakobLierman/Flits-iOS/raw/master/Screenshots/Open-avgspeedcheck.gif" width="128px">
<img src="https://github.com/JakobLierman/Flits-iOS/raw/master/Screenshots/Create-delete-policecheck.gif" width="128px">
</p>

***

## Getting started

### Installing

Please make sure [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) is installed.

Clone this repo and open `Flits.xcworkspace`.

```zsh
git clone https://github.com/JakobLierman/Flits-iOS.git Jakob_Lierman_FlitsApp
cd Jakob_Lierman_FlitsApp
open Flits.xcworkspace
```

Optional: run `pod install` before opening to make sure all pods are up to date.

### Change Firebase backend

Create your own Firebase: https://console.firebase.google.com/.
Use the [docs](https://firebase.google.com/docs/ios/setup) to change all database references in the project.

1. Search for statements like this one and change accordingly.

    ```swift
    let storageRef = Storage.storage().reference(forURL: "Insert Firebase storage link here")
    ```

2. Change the `GoogleService-Info.plist` to the one you got from Firebase.

## Built With

* [Firebase](https://firebase.google.com/)
* [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper)
* [OrderedSe](https://github.com/Weebly/OrderedSet)
