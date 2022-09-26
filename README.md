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
Make sure KeyboardRichText Widget at top level widget tree of Screen (or only after Scaffold Widget)

Use Default ToolBar:

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

Use Custom ToolBar:

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
        keyBroadToolbar: Text('ToolBar'),
        child: const Center(
          child: TextField(),
        ),
      ),
    );
  }
}

```
