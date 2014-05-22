# websms CCMP Example (iOS)

SMS2App from websms combines the cost advantages of push and the reliability of SMS into one single product. This app serves as an example how the SDK of SMS2App can be integrated into a customer’s application. By using SMS2App’s unique functionality, our customers benefit from both worlds – Push and SMS.
 
For more information about SMS2App, visit our [website](https://websms.de/produkte/sms2app)

## Requirements
* XCode 4.5 or higher
* Apple LLVM compiler
* iOS 5.0 or higher
* ARC

## Installation

### CocoaPods

The recommended approach for installating `ccmp-lib-ios` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.
For best results, it is recommended that you install via CocoaPods >= **0.15.2** using Git >= **1.8.0** installed via Homebrew.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory and install pods into your Xcode project:

``` bash
$ cd /path/to/project
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open ccmp-example-ios.xcworkspace
```

Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= **1.8.0** by executing `git --version`. You can get a full picture of the installation details by executing `pod install --verbose`.

## Contributors

Christoph Lückler ([@oe8clr](https://github.com/oe8clr))

## Contact

sms.at mobile internet services gmbh
Münzgrabenstraße 92/4
A-8010 Graz

- https://github.com/websms-com
- https://twitter.com/websms_com
- sms2app@websms.com

## License

ccmp-lib-ios is available under the MIT license.

Copyright © 2014 sms.at mobile internet services gmbh

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.