# smile_selfie

A Selfie Plugin that allows you capture selfies when a smile is detected.

### Platform Support


This plugin only supports android and IOS

|                | Android | iOS      | 
|----------------|---------|----------|
| **Support**    | SDK 21+ | iOS 10+* |


### Installation & Setup

#### Add the plugin as a dependency to your pubspec:

```yaml
dependencies:
  smile_selfie: 
    git:
      url: https://github.com/asapJ/smile_selfie.git
```

#### iOS


Add two rows to the `ios/Runner/Info.plist`:

* one with the key `Privacy - Camera Usage Description` and a usage description.
* and one with the key `Privacy - Microphone Usage Description` and a usage description.

If editing `Info.plist` as text, add:

```xml
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
```

#### Android

Change the minimum Android sdk version to 21 (or higher) in your `android/app/build.gradle` file.

```groovy
minSdkVersion 21
```


### Usage

#### Import the dart file  

```dart
import 'package:smile_selfie/smile_selfie.dart';
```



#### Initialize the plugin
Must be called before calling any other plugin  method

```dart
try {
        await SmileSelfie.initialize()
    } 
    catch (e) {
        print(e);
    }
```

#### Capture Selfie
```dart


const options = SmileSelfieOptions(
                      eyesOpenProbabilty: 0.5, //between 0.0 to 1
                      smileProbability: 0.5, //between 0.0 to 1,
                      delay: Duration(seconds: 5));

                  final decoration = SmileSelfieDecoration(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      footer: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: const [
                            Text(
                              'Powered by Google',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            "Smile to take a selfie",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      previewSize: 400);

try {
     
        String path = await SmileSelfie.captureSelfie(context, smileSelfieOptions: options,selfieDecoration: decoration);
    } 
    catch (e) {
        print(e);
    }
```





For more clarity on plugin usage, check the example app [here](https://github.com/asapJ/smile_selfie/tree/master/example) 

