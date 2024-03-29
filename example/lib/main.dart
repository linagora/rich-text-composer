
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/widgets/rich_text_keyboard_toolbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final RichTextController richTextController = RichTextController();

  @override
  void initState() {
    richTextController.showRichTextView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          richTextController.htmlEditorApi?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Demo Home Page'),
            backgroundColor: Colors.green,
          ),
          body: KeyboardRichText(
            richTextController: richTextController,
            keyBroadToolbar: RichTextKeyboardToolBar(
              richTextController: richTextController,
              rootContext: context
            ),
            child: SingleChildScrollView(
              child: HtmlEditor(
                key: const Key('composer_editor'),
                minHeight: 550,
                addDefaultSelectionMenuItems: false,
                onCreated: (editorApi) {
                  richTextController.onCreateHTMLEditor(editorApi);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
