# smile_selfie

A Selfie Plugin that allows you capture selfies when a smile is detected.

## Installation and usage ##

#### Add the plugin as a dependency to your pubspec:

```yaml
dependencies:
  smile_selfie: 
    git:
      url: https://github.com/asapJ/smile_selfie.git
```

#### Import the dart file  

```dart
import 'package:smile_selfie/smile_selfie.dart';
```



#### Initialize the plugin
##### Must be called before calling `captureSelfie()`
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
try {
        String path = await SmileSelfie.captureSelfie(context);
    } 
    catch (e) {
        print(e);
    }
```





For more clarity on plugin usage, check the example app [here](https://github.com/asapJ/smile_selfie/tree/master/example) 

