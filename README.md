<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Add features to the Android / iOS keyboard in a simple way.

## Features

Allow custom top toolbar keybroad

Example of the custom top toolbar keybroad:

<img width="387" alt="Screen Shot 2022-09-23 at 09 59 18" src="https://user-images.githubusercontent.com/107173849/191884470-5b9f8394-166e-4964-9af1-a5033902e3e6.png">


## Getting started

You should ensure that you add the dependency in your flutter project.
```
dependencies:
  rich_text_composer:
    git:
      url: https://github.com/linagora/rich-text-composer.git
      ref: master
 ```
You should then run flutter packages upgrade or update your packages in IntelliJ.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
class _MyHomePageState extends State<MyHomePage> {
  final RichTextAppendController richTextAppendController = RichTextAppendController();

  @override
  void initState() {
    richTextAppendController.showRichTextView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: KeyboardRichText(
        richTextAppendController: richTextAppendController,
        backgroundKeyboardToolBarColor: Colors.grey,
        keyBroadToolbar: RichTextKeyboardToolBar(
            insertImage: () {}, insertAttachment: () {}, appendRickText: () {}),
        child: const Center(
          child: TextField(),
        ),
      ),
    );
  }
}

```
