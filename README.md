# IRImagery

IRImagery holds a collection of helper classes and views that work with images, specifically `UIImage` objects.

## Sample

Look at the Sample App: iridia/IRImagery-Sample@master .

## Useful Classes and Methods

### `IRImageView`

`IRImageView` is designed to be a drop-in replacement of `UIImageView`.  It overrides `-setImage:` to decode the image in background, create a fully in-memory representation of the image in the correct scale and orientation, then send it back to the image view, preventing decoding to happen on the main thread. 

### `UIImage` additions

*	`-[UIImage irStandardImage]` creates a point-for-pixel image from `self`, and does orientation rotation for you, so the final image is suitable for all sorts of processing and guaranteed to be up-side-up.

*	`-[UIImage irDecodedImage]` creates an in-memory `CGImageRef`-backed image using `-irStandardImage`, and the result is guaranteed to be “hot” and in memory, suitable for immediate display by being trampolined to the main thread.

*	`-[UIImage irSetRepresentedObject:]` and `-[UIImage irRepresentedObject:]` provides a basic level of support for describing multiple image representations against one single truth, e.g. multiple thumbnail images of different sizes.

*	`-[UIImage irWriteToSavedPhotosAlbumWithCompletion:]` provides a callback block, instead of a selector invocation.

###	`IRImagePageView`

`IRImagePageView` is a simple page view that contains a scrollable, pannable, zoomable view hosting an image.  It uses IRImageView internally, and can be used in junction with `IRPaginatedView` to build a scrollable gallery.

##	Credits

*	[Evadne Wu](http://twitter.com/evadne) at [Iridia Productions](http://iridia.tw) / [Waveface Inc](http://waveface.com).
*	[Trevor Harmon](http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/) for the original UIImage+Resize implementation
