import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String droneName = '';
String droneIP = '';
List<List<String>> storedRoutes= [];

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drone App',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Colors.black),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: createMaterialColor(Color.fromRGBO(255, 250, 250, 0.7)),
      ),
      home: WelcomePage(),
    );
  }
}

// Import statements and other code here

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dobermann'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Dobermann',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(246, 128, 37, 1),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 18, color:  Color.fromRGBO(114, 56, 35, 1), fontWeight: FontWeight.w700 ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The rest of your code here


// Import statements and other code here

class RouteDestinationPage extends StatelessWidget {

  RouteDestinationPage(storedRoutes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Destination Page'),
      ),
      body: Center(
        child: storedRoutes.isEmpty
            ? Text('No route set up')
            : ListView.builder(
          itemCount: storedRoutes.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                _displayRoute(context, storedRoutes[index]);
                print(storedRoutes);
              },
              child: Text('Route ${index + 1}'),
            );
          },
        ),
      ),
    );
  }
}

void _displayRoute(BuildContext context, List<String> route) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Route Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: route
                .map(
                  (step) => Text(step),
            )
                .toList(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              //print(route);
            },
          ),
        ],
      );
    },
  );
}


class MissionSchedulingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mission Scheduling Page'),
      ),
      body: Center(
        child: Text('This is the Mission Scheduling Page'),
      ),
    );
  }
}



class RouteDestinationSetupPage extends StatefulWidget {
  @override
  _RouteDestinationSetupPageState createState() => _RouteDestinationSetupPageState();
}

class _RouteDestinationSetupPageState extends State<RouteDestinationSetupPage> {
  List<String> selectedCommands = [];

  void _navigateToFlyingCommandPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlyingCommandPage()),
    );
    setState(() {
      if (result != null) {
        selectedCommands.add(result);
      }
    });
  }

  void _clearCommands() {
    setState(() {
      selectedCommands.clear();
    });
  }

  void _storeRoute() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _routeNameController = TextEditingController();
        return AlertDialog(
          title: Text('Store Route'),
          content: TextField(
            controller: _routeNameController,
            decoration: InputDecoration(hintText: 'Enter Route Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Store'),
              onPressed: () {
                setState(() {
                  List<String> tmp = new List<String>.from(selectedCommands);
                  storedRoutes.add(tmp);
                  //print(storedRoutes);
                  selectedCommands.clear();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(39, 29, 90, 1),
      appBar: AppBar(
        title: Text('Route Destination Setup Page'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200, // Adjust the height as needed
            color: Colors.grey, // Placeholder color for the live camera video
          ),
          SizedBox(height: 20),
          Expanded(
            flex:9,
            child: SingleChildScrollView(
              child: Container(
                //color: Colors.grey[200], // Set the desired background color
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: selectedCommands
                      .map(
                        (command) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 2.0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                command,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                  )
                      .toList(),
                ),
              ),
            ),
          ),
          Expanded(
            flex:1,
            child: Container(), // Add your live camera video widget here later
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _navigateToFlyingCommandPage,
                  child: Text('Add Flying Command'),
                ),
                ElevatedButton(
                  onPressed: _clearCommands,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 5)
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _storeRoute();
                  },
                  child: Text('Store Route'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlyingCommandPage extends StatelessWidget {
  final List<String> commands = [
    'Take-off',
    'Landing',
    'Spin 360',
    'Move Forward',
    'Move Backward',
    'Move Left',
    'Move Right',
    'Climb Up',
    'Go Down',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flying Command Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var command in commands)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, command);
                    },
                    child: Text(command),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// Import statements and other code here


class DroneRegistrationPage extends StatefulWidget {
  @override
  _DroneRegistrationPageState createState() => _DroneRegistrationPageState();
}

class _DroneRegistrationPageState extends State<DroneRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();

  void _submitData() {
    setState(() {
      droneName = _nameController.text;
      droneIP = _ipController.text;
    });

    // Add your document logic here
    print(droneName);
    print(droneIP);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drone Registration Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Drone Name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  hintText: 'Enter Drone IP',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// The rest of your code here

// The rest of your code here


class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RouteDestinationPage(storedRoutes)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(246, 128, 37, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 350),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.add_location),
                      Text(
                        'Select',
                        style: TextStyle(fontSize: 26, color: Color.fromRGBO(114, 56, 35, 1), fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Route',
                        style: TextStyle(fontSize: 26, color: Color.fromRGBO(114, 56, 35, 1), fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MissionSchedulingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(246, 128, 37, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 350),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.schedule),
                      Text(
                        'Schedule',
                        style: TextStyle(fontSize: 26, color: Color.fromRGBO(114, 56, 35, 1), fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Mission',
                        style: TextStyle(fontSize: 26, color: Color.fromRGBO(114, 56, 35, 1), fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RouteDestinationSetupPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(246, 128, 37, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 350),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.settings),
                      Text(
                        'Route',
                        style: TextStyle(fontSize: 26, color: Color.fromRGBO(114, 56, 35, 1), fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Setup',
                        style: TextStyle(fontSize: 26, color: Color.fromRGBO(114, 56, 35, 1), fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DroneRegistrationPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(246, 128, 37, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 350),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.add_circle),
                      Text(
                        'Register',
                        style: TextStyle(fontFamily: "Rock Salt", fontSize: 26, color: Color.fromRGBO(114, 56, 35, 1), fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Drone',
                        style: GoogleFonts.rubikPixels(
                            fontSize: 26,
                            color: Color.fromRGBO(114, 56, 35, 1),
                            fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





// The main function and other necessary code here




// Implement the other pages for route destination selection, mission scheduling, route destination setup, and drone registration similarly.
