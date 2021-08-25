# NasaChallenge

NasaChallenge is a simple iOS app that allows scrolling through the catalog of NASA's images. It fetches a JSON list from https://images-api.nasa.gov/search?q=%22%22. It supports light or dark appearance based on the user's system preference.

The project makes use of the Swift UIKit, Combine, URLSession and MVVM architecture. It includes a unit test to mock fetching of nasa items.

The UI follows the mockups from https://www.figma.com/file/zy4XFycrYjVDp9zYbPSGCb/Nasa-Challenge?node-id=0%3A1.

Built using Xcode Version 12.5.1 (Swift 5)


## Installation

Make sure to have CocoaPods installed on your computer. If you don't have CocoaPods, follow the guidelines from https://guides.cocoapods.org/using/getting-started.html#installation to install it.

- Clone this repo
- Open Terminal and navigate to the project folder
- Run

```bash
  pod install
```
- Open NasaChallenge.xcworkspace


## Authors

- [@zakhiadamaree](https://github.com/zakhiadamaree)

  
## Optimizations

Adopted a protocol oriented programming approach in Network Handling and Image Caching.

Created several files to handle specific related tasks, such as 
- a NetworkManager: to handle fetching of JSON lists. It conforms to a NetworkHandler protocol, which is also used in unit testing to mock fetching of nasa items.
- an ImageDownloader to handle downloading of images.
- a NetworkError to handle different error states.
- an ImageCache to handle caching of images. The caching of images makes use of NSCache which handles memory management efficiently.

The project can further be optimized by implementing a custom downloadTaskPublisher for downloading of the images. The project makes use of the dataTaskPublisher for the image downloads, which wraps a URL session data task for a given URL. A URL session data task is stored in memory whilst a URL session download task is stored in the file system. A downloadTaskPublisher is not available on Combine, which is why a custom one will have to be implemented.


## Lessons Learned

One of the challenges that I faced while building the project is the detection of internet connectivity. I learnt about a better approach to internet connectivity is to use an adaptable connectivity API. URLSession provides a feature to wait for internet connection instead of failing a URLSessionTask. By default, URLSession waits for up to 7 days. However, the app requires the JSON list which is why I set it to 1 min.

One more thing I learnt with URLSession is the feature of not requesting any large image downloads on expensive networks such as cellular.

Combine was a new concept to me. I wasn't familiar with reactive programming either. With Combine, I've learnt how to request data from a URLSession dataTaskPublisher and mapping of errors.


## Acknowledgements

Followed the following tutorials as guidelines into building this project:

 - [iOS MVVM Tutorial](https://www.raywenderlich.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc)
 - [Combine Error Handling](https://www.avanderlee.com/swift/combine-error-handling/)
 - [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
 - [Testing Networking Code With Combine](https://www.wwt.com/article/testing-networking-code-with-combine/)
 - [How To Use DateFormatter](https://sarunw.com/posts/how-to-use-dateformatter/)
 - [NSCache](https://developer.apple.com/documentation/foundation/nscache)
 - [URLSession using Combine Publishers and Subscribers](https://theswiftdev.com/how-to-download-files-with-urlsession-using-combine-publishers-and-subscribers/)
 - [dataTaskPublisher](https://developer.apple.com/documentation/foundation/urlsession/3329707-datataskpublisher)
 - [Network Connectivity](https://www.vadimbulavin.com/network-connectivity-on-ios-with-swift/)

  
## Support

If you have any questions, feel free to email at zakhia@live.com.

