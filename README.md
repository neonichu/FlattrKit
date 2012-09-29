# FlattrKit #

Easily access the [Flattr][2] v2 API on your iOS device.

The repository contains an [example application][1].
You can also checkout the [API documentation][3]

[1]: https://github.com/neonichu/FlattrKit/blob/master/Example/VUAppDelegate.m
[2]: http://www.flattr.com/
[3]: http://vu0.org/projects/FlattrKit/docs

## Integrating FlattrKit as UIActivity ##

Since iOS 6, it has become much easier to integrate third-party services
into your app thanks to the UIActivityViewController. FlattrKit now
embraces this new method by providing an UIActivity subclass for easier
integration. To add this to your app, do the following:

1. Build libFlattrKit and add it to your project.
2. Add the VUFlattrActivity files and the FlattrActivity images to your
   app bundle.
3. Add _-ObjC_ to your linker flags.
4. Add the FlattrKit directory to your header search paths (recursive).
5. Add the VUFlattrActivity to your UIActivityViewController invocation.

Example:

    NSArray* activityItems = @[ [NSURL URLWithString:@"http://www.google.de"] ];
    NSArray* appActivities = @[ [[VUFlattrActivity alloc] init] ];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:appActivities];
    [self presentViewController:activityController animated:YES completion:nil];

Be aware that VUFlattrActivity only supports a single NSURL object as
activity item. Make sure you change the OAuth information in the .m file
to match your application. OAuth tokens are stored in your app's
keychain after the first login. That login will happen in a UIWebView
which is displayed automatically.

