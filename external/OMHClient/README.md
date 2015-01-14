OMHClient
======

This is the repository for the Open mHealth DSU iOS client library.

DEPENDENCIES
------------

The Open mHealth DSU uses the Google+ platform for user authentication, so this library has a dependency on the Google+ iOS SDK. In addition to including all the files in this repository in your project, your project must include all the frameworks required by the Google+ iOS SDK:

* AddressBook.framework
* AssetsLibrary.framework
* Foundation.framework
* CoreLocation.framework
* CoreMotion.framework
* CoreGraphics.framework
* CoreText.framework
* MediaPlayer.framework
* Security.framework
* SystemConfiguration.framework
* UIKit.framework

CLIENT SETUP
------------------------

In order to sign in to the DSU, your app will need four keys:

1. A Google+ client ID for your app (associated with your app's bundle ID)
2. A Google+ client ID for the DSU server you're using
3. A DSU client ID for your app
4. The DSU client secret for your DSU client ID

Your app should use these keys to setup the client in your app delegate's `applicationDidFinishLaunching` by calling 
```
[OMHClient setupClientWithAppGoogleClientID:(1)
                       serverGoogleClientID:(2)
                             appDSUClientID:(3)
                         appDSUClientSecret:(4)];
```

CONTRIBUTE
----------

If you would like to contribute code to the Open mHealth iOS client you can do so through GitHub by forking the repository and sending a pull request.

You may [file an issue](https://github.com/cforkish/OMHClient/issues/new) if you find bugs or would like to add a new feature.

LICENSE
-------

    Copyright (C) 2015 Open mHealth

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.