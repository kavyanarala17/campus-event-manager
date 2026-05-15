import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode:
      darkMode ? ThemeMode.dark : ThemeMode.light,

      darkTheme: ThemeData.dark(),

      theme: ThemeData.light(),

      home: LoginScreen(
        toggleTheme: () {
          setState(() {
            darkMode = !darkMode;
          });
        },
      ),
    );
  }
}

// ================= LOGIN =================

class LoginScreen extends StatefulWidget {

  final VoidCallback toggleTheme;

  LoginScreen({
    required this.toggleTheme,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  TextEditingController nameController =
  TextEditingController();

  String selectedRole = "Student";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: BoxDecoration(

          gradient: LinearGradient(

            colors: [
              Color(0xff090014),
              Color(0xff34116a),
            ],
          ),
        ),

        child: Center(

          child: SingleChildScrollView(

            child: Padding(

              padding: EdgeInsets.all(25),

              child: Column(

                children: [

                  Icon(
                    Icons.event_available,
                    size: 120,
                    color:
                    Colors.deepPurpleAccent,
                  ),

                  SizedBox(height: 20),

                  Text(

                    "Campus Event Manager",

                    style: TextStyle(
                      fontSize: 34,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(

                    "Smart Event Participation System",

                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: 40),

                  TextField(

                    controller: nameController,

                    decoration: InputDecoration(

                      filled: true,

                      fillColor:
                      Colors.white10,

                      hintText:
                      "Enter Name",

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  DropdownButtonFormField(

                    value: selectedRole,

                    items: [

                      "Student",
                      "Admin",

                    ].map((e) {

                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );

                    }).toList(),

                    onChanged: (value) {

                      setState(() {
                        selectedRole = value!;
                      });
                    },

                    decoration: InputDecoration(

                      filled: true,

                      fillColor:
                      Colors.white10,

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  ElevatedButton(

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      Colors.deepPurple,

                      padding:
                      EdgeInsets.symmetric(

                        horizontal: 120,
                        vertical: 16,
                      ),
                    ),

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              HomeScreen(

                                username:
                                nameController.text,

                                role:
                                selectedRole,

                                toggleTheme:
                                widget.toggleTheme,
                              ),
                        ),
                      );
                    },

                    child: Text(
                      "LOGIN",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= HOME =================

class HomeScreen extends StatefulWidget {

  final String username;
  final String role;
  final VoidCallback toggleTheme;

  HomeScreen({

    required this.username,
    required this.role,
    required this.toggleTheme,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  List<Map<String, dynamic>> events = [];

  String search = "";

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    String? data =
    prefs.getString("events");

    if (data != null) {

      List decoded = jsonDecode(data);

      events = decoded
          .map((e) =>
      Map<String, dynamic>.from(e))
          .toList();
    }

    else {

      events = [

        {
          "event": "AI Workshop",
          "participants": 121,
          "category": "Workshop",
          "venue": "Seminar Hall",
          "date": "20 May",
          "liked": false,
          "maxSeats": 150,
          "joinedStudents": [],
        },

        {
          "event": "Hackathon 2026",
          "participants": 300,
          "category": "Hackathon",
          "venue": "Auditorium",
          "date": "28 May",
          "liked": false,
          "maxSeats": 350,
          "joinedStudents": [],
        },
      ];

      saveEvents();
    }

    setState(() {});
  }

  Future<void> saveEvents() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      "events",
      jsonEncode(events),
    );
  }

  Widget dashboardCard(
      String value,
      String title,
      IconData icon,
      Color color,
      ) {

    return Expanded(

      child: Container(

        padding: EdgeInsets.all(20),

        decoration: BoxDecoration(

          borderRadius:
          BorderRadius.circular(22),

          color: Colors.white10,
        ),

        child: Column(

          children: [

            CircleAvatar(

              radius: 28,

              backgroundColor: color,

              child: Icon(icon),
            ),

            SizedBox(height: 15),

            Text(

              title,

              style: TextStyle(
                color: Colors.white70,
              ),
            ),

            SizedBox(height: 10),

            Text(

              value,

              style: TextStyle(

                fontSize: 32,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget miniInfo(
      IconData icon,
      String text,
      ) {

    return Row(

      mainAxisSize: MainAxisSize.min,

      children: [

        Icon(
          icon,
          size: 16,
          color: Colors.white70,
        ),

        SizedBox(width: 5),

        Text(

          text,

          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    List filtered = events.where((e) {

      return e['event']
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase());

    }).toList();

    return Scaffold(

      appBar: AppBar(

        backgroundColor:
        Color(0xff1b103d),

        title:
        Text("Campus Event Manager"),

        actions: [

          IconButton(

            onPressed:
            widget.toggleTheme,

            icon:
            Icon(Icons.dark_mode),
          ),
        ],
      ),

      floatingActionButton:
      widget.role == "Admin"

          ? FloatingActionButton(

        backgroundColor:
        Colors.deepPurple,

        child: Icon(Icons.add),

        onPressed: () {
          addEventDialog();
        },
      )

          : null,

      body: Container(

        decoration: BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Color(0xff090014),
              Color(0xff34116a),
            ],
          ),
        ),

        child: SingleChildScrollView(

          child: Padding(

            padding: EdgeInsets.all(18),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                SizedBox(height: 20),

                Center(

                  child: Column(

                    children: [

                      Text(

                        "Welcome ${widget.username} 👋",

                        style: TextStyle(

                          fontSize: 36,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(

                        "${widget.role} Dashboard",

                        style: TextStyle(

                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                TextField(

                  onChanged: (value) {

                    setState(() {
                      search = value;
                    });
                  },

                  decoration: InputDecoration(

                    hintText:
                    "Search Events...",

                    prefixIcon:
                    Icon(Icons.search),

                    filled: true,

                    fillColor:
                    Colors.white10,

                    border:
                    OutlineInputBorder(

                      borderRadius:
                      BorderRadius.circular(22),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                Row(

                  children: [

                    dashboardCard(
                      events.length.toString(),
                      "Total Events",
                      Icons.event,
                      Colors.deepPurple,
                    ),

                    SizedBox(width: 15),

                    dashboardCard(

                      events.fold<int>(
                        0,
                            (sum, item) =>
                        sum +
                            (item['participants']
                            as int),
                      ).toString(),

                      "Participants",

                      Icons.people,

                      Colors.green,
                    ),
                  ],
                ),

                SizedBox(height: 30),

                Text(

                  "Events",

                  style: TextStyle(

                    fontSize: 28,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                ...filtered.map((event) {

                  return Container(

                    margin:
                    EdgeInsets.only(bottom: 20),

                    padding:
                    EdgeInsets.all(20),

                    decoration:
                    BoxDecoration(

                      borderRadius:
                      BorderRadius.circular(28),

                      gradient:
                      LinearGradient(

                        colors: [
                          Color(0xff3c1d73),
                          Color(0xff1b103d),
                        ],
                      ),
                    ),

                    child: Column(

                      children: [

                        Row(

                          children: [

                            Container(

                              height: 90,
                              width: 90,

                              decoration:
                              BoxDecoration(

                                borderRadius:
                                BorderRadius.circular(22),

                                gradient:
                                LinearGradient(

                                  colors: [

                                    Colors.deepPurple,
                                    Colors.pinkAccent,
                                  ],
                                ),
                              ),

                              child: Icon(

                                event['category'] ==
                                    "Hackathon"

                                    ? Icons.computer

                                    : event['category'] ==
                                    "Workshop"

                                    ? Icons.school

                                    : Icons.emoji_events,

                                size: 42,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(width: 22),

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    event['event'],

                                    style: TextStyle(

                                      fontSize: 32,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  Wrap(

                                    spacing: 14,
                                    runSpacing: 8,

                                    children: [

                                      miniInfo(
                                        Icons.location_on,
                                        event['venue'],
                                      ),

                                      miniInfo(
                                        Icons.calendar_month,
                                        event['date'],
                                      ),

                                      miniInfo(
                                        Icons.people,
                                        "${event['participants']} Participants",
                                      ),

                                      miniInfo(
                                        Icons.gpp_good,
                                        "Seats Left: ${event['maxSeats'] - event['participants']}",
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 18),

                                  Text(

                                    "${((event['participants'] / event['maxSeats']) * 100).toInt()}% Filled",
                                  ),

                                  SizedBox(height: 8),

                                  ClipRRect(

                                    borderRadius:
                                    BorderRadius.circular(20),

                                    child:
                                    LinearProgressIndicator(

                                      minHeight: 10,

                                      value:
                                      event['participants'] /
                                          event['maxSeats'],

                                      backgroundColor:
                                      Colors.white12,

                                      valueColor:
                                      AlwaysStoppedAnimation(
                                        Colors.deepPurpleAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 25),

                            Column(

                              children: [

                                IconButton(

                                  icon: Icon(

                                    event['liked']

                                        ? Icons.favorite

                                        : Icons.favorite_border,

                                    color: Colors.red,
                                    size: 34,
                                  ),

                                  onPressed: () {

                                    setState(() {

                                      event['liked'] =
                                      !event['liked'];
                                    });

                                    saveEvents();
                                  },
                                ),

                                SizedBox(height: 20),

                                // ONLY STUDENT CAN JOIN

                                if (widget.role ==
                                    "Student")

                                  ElevatedButton(

                                    style:
                                    ElevatedButton.styleFrom(

                                      backgroundColor:
                                      Colors.green,

                                      padding:
                                      EdgeInsets.symmetric(

                                        horizontal: 28,
                                        vertical: 16,
                                      ),
                                    ),

                                    onPressed: () {
                                      joinDialog(event);
                                    },

                                    child: Text(
                                      "JOIN EVENT",
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),

                        // ADMIN VIEW JOINED STUDENTS

                        if (widget.role ==
                            "Admin")

                          Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              SizedBox(height: 25),

                              Text(

                                "Joined Students",

                                style: TextStyle(

                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 15),

                              ...List.generate(

                                event['joinedStudents']
                                    .length,

                                    (i) {

                                  var student =
                                  event['joinedStudents'][i];

                                  return Container(

                                    margin:
                                    EdgeInsets.only(
                                        bottom: 12),

                                    padding:
                                    EdgeInsets.all(15),

                                    decoration:
                                    BoxDecoration(

                                      color:
                                      Colors.white10,

                                      borderRadius:
                                      BorderRadius.circular(18),
                                    ),

                                    child: Column(

                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                      children: [

                                        Text(
                                          "👤 Name: ${student['name']}",
                                        ),

                                        SizedBox(height: 5),

                                        Text(
                                          "🆔 USN: ${student['usn']}",
                                        ),

                                        SizedBox(height: 5),

                                        Text(
                                          "🏫 Branch: ${student['branch']}",
                                        ),

                                        SizedBox(height: 5),

                                        Text(
                                          "📚 Year: ${student['year']}",
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  );

                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= JOIN DIALOG =================

  void joinDialog(
      Map<String, dynamic> event) {

    TextEditingController usn =
    TextEditingController();

    TextEditingController branch =
    TextEditingController();

    TextEditingController year =
    TextEditingController();

    showDialog(

      context: context,

      builder: (ctx) {

        return AlertDialog(

          title: Text("Join Event"),

          content:
          SingleChildScrollView(

            child: Column(

              mainAxisSize:
              MainAxisSize.min,

              children: [

                TextField(

                  enabled: false,

                  decoration:
                  InputDecoration(

                    labelText: "Name",

                    hintText:
                    widget.username,
                  ),
                ),

                SizedBox(height: 10),

                TextField(

                  controller: usn,

                  decoration:
                  InputDecoration(
                    labelText: "USN",
                  ),
                ),

                SizedBox(height: 10),

                TextField(

                  controller: branch,

                  decoration:
                  InputDecoration(
                    labelText: "Branch",
                  ),
                ),

                SizedBox(height: 10),

                TextField(

                  controller: year,

                  decoration:
                  InputDecoration(
                    labelText: "Year",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            ElevatedButton(

              onPressed: () async {

                setState(() {

                  event['participants'] =
                      event['participants'] + 1;

                  event['joinedStudents'].add({

                    "name":
                    widget.username,

                    "usn":
                    usn.text,

                    "branch":
                    branch.text,

                    "year":
                    year.text,
                  });
                });

                await saveEvents();

                Navigator.pop(ctx);

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  SnackBar(

                    content: Text(
                      "Successfully Joined 🎉",
                    ),
                  ),
                );
              },

              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  // ================= ADD EVENT =================

  void addEventDialog() {

    TextEditingController event =
    TextEditingController();

    TextEditingController venue =
    TextEditingController();

    TextEditingController date =
    TextEditingController();

    String category = "Hackathon";

    showDialog(

      context: context,

      builder: (ctx) {

        return AlertDialog(

          title: Text("Add Event"),

          content:
          SingleChildScrollView(

            child: Column(

              children: [

                TextField(

                  controller: event,

                  decoration:
                  InputDecoration(
                    labelText:
                    "Event Name",
                  ),
                ),

                SizedBox(height: 10),

                TextField(

                  controller: venue,

                  decoration:
                  InputDecoration(
                    labelText:
                    "Venue",
                  ),
                ),

                SizedBox(height: 10),

                TextField(

                  controller: date,

                  decoration:
                  InputDecoration(
                    labelText:
                    "Date",
                  ),
                ),

                SizedBox(height: 10),

                DropdownButtonFormField(

                  value: category,

                  items: [

                    "Hackathon",
                    "Workshop",
                    "Sports",

                  ].map((e) {

                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );

                  }).toList(),

                  onChanged: (v) {
                    category = v!;
                  },
                ),
              ],
            ),
          ),

          actions: [

            ElevatedButton(

              onPressed: () {

                setState(() {

                  events.add({

                    "event":
                    event.text,

                    "participants":
                    0,

                    "category":
                    category,

                    "venue":
                    venue.text,

                    "date":
                    date.text,

                    "liked":
                    false,

                    "maxSeats":
                    100,

                    "joinedStudents":
                    [],
                  });
                });

                saveEvents();

                Navigator.pop(ctx);
              },

              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}