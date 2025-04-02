import 'package:flutter/material.dart';
// import 'package:omni_notes/quill.dart';

void main() {
  runApp(const Notes());
}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => NotesStates();
}

class NotesStates extends State<Notes> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(1, 255, 233, 51)),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  var titleText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/bg.jpg"),
              fit: BoxFit.fitHeight,
            )),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 60.0,
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(153, 255, 255, 255),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(32, 0, 0, 0),
                            spreadRadius: 5,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          )
                        ],
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              child: TextField(
                                controller: titleController,
                                focusNode: FocusNode(),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: "S E A R C H",
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  color: Color.fromARGB(175, 0, 0, 0),
                                  backgroundColor: Colors.transparent,
                                  fontSize: 15.0,
                                  fontFamily: "Inria Sans",
                                ),
                                cursorColor:
                                    const Color.fromARGB(255, 79, 79, 79),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => Quill()),
                                    // );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    foregroundColor: const Color(0x99000000),
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 20.0, 0, 20.0),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                  child: const Icon(Icons.add)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(153, 255, 255, 255),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(32, 0, 0, 0),
                              spreadRadius: 5,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            )
                          ],
                          border: Border.all(
                            color: const Color.fromARGB(153, 255, 255, 255),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10.0),
                        child: const Center(
                          child: Text("No Notes"),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            backgroundColor:
                                const Color.fromARGB(153, 255, 255, 255),
                            foregroundColor: const Color(0x99000000),
                            //minimumSize: const Size.square(30),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 0.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Image(
                                image: AssetImage("images/omni_notes_t.png"),
                                height: 35.0,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 0),
                                child: const Text(
                                  "Omni Projects",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: "Inria Sans",
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            backgroundColor:
                                const Color.fromARGB(153, 255, 255, 255),
                            foregroundColor: const Color(0x99000000),
                            minimumSize: const Size.square(40),
                            padding: const EdgeInsets.all(0),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          child: const Image(
                              image: AssetImage("images/settings.png")),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
