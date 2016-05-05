SVGeez
======

SVG parser and code generator, with configurable templates.

Currently only iOS templates are implemented.

Install
=======

Run `bundle install --path vendor/bundle/`, and you should have what you need.

Usage
=====

Run `bin/svgeez path/to/some/File*.svg -o path/to/output/dir/SVGeez`.

You should see a `SVGeez.h` and `SVGeez.m` inside of `path/to/output/dir/` for use in your project.

Then you can grab the `CALayer`s by key, such as:

```objc
CALayer *foo = [SVGeez layerForKey:SVGeez_FileA];
```

You can attach that to a `UIView`, and off you go. You'll need to do a little work to have that layer play well with view resizing etc, but that will depend on your use case.