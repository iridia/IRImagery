# IRImagery

IRImagery holds a collection of helper classes and views that work with images, specifically `UIImage` objects.

## Useful Classes

### IRImageView

`IRImageView` is designed to be a drop-in replacement of `UIImageView`.  It overrides `-setImage:` to decode the image in background, create a fully in-memory representation of the image in the correct scale and orientation, then send it back to the image view, preventing decoding to happen on the main thread. 

##	Credits

*	[Evadne Wu](http://twitter.com/evadne) at [Iridia Productions](http://iridia.tw) / [Waveface Inc](http://waveface.com).
*	[Trevor Harmon](http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/) for the original UIImage+Resize implementation
