import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';


//global variable
class Drone {
  String name;
  String ip;
  int number;
  List<Route> routes = [];
  Drone(this.name, this.ip, this.number);
}

class Route{
  List<String> storedRoutes= [];
  String name;

  Route(this.name);
}


int howManyDrone = 0;
int selectedDroneIndex = 0;
String fromWhereToSelectionPage = '';
//List<List<String>> storedRoutes= [];
List<Drone> droneList = [];


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
        title: Text('Select Your Route'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route:',
              style: cool_font,
            ),
            droneList[selectedDroneIndex].routes.isEmpty
                ? Text('No route set up')
                : ListView.builder(
              shrinkWrap: true,
              itemCount: droneList[selectedDroneIndex].routes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                  onPressed: () {
                    _displayRoute(context, droneList[selectedDroneIndex].routes[index].storedRoutes);
                    //print(storedRoutes);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60), // Adjust the height as needed
                  ),
                  child: Text(droneList[selectedDroneIndex].routes[index].name),
                ),
                );
              },
            ),
          ],

        ),
      )
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
  List<bool> isProceeded = [];
  //WebViewController controller = WebViewController()
  //..loadRequest(Uri.parse('http://192.168.0.156:8080/?action=stream'));
  void _navigateToFlyingCommandPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlyingCommandPage()),
    );
    setState(() {
      if (result != null) {
        selectedCommands.add(result);
        isProceeded.add(false);
      }
    });
  }
  void _deleteCommand(int index){
    setState(() {
      selectedCommands.removeAt(index);
      isProceeded.removeAt(index);
    });
  }
  void _clearCommands() {
    setState(() {
      selectedCommands.clear();
      isProceeded.clear();
    });
  }
  void _pressArrow(int index){
    setState(() {
      isProceeded[index] = true;
    });
  }

  void _showStoreRouteSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Store Route Successful'),
          content: Text('You have successfully stored the route.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  List<String> tmp = List<String>.from(selectedCommands);
                  final Route temp = Route(_routeNameController.text);
                  for (String route__ in tmp) {
                    temp.storedRoutes.add(route__);
                  }
                  droneList[selectedDroneIndex].routes.add(temp);
                  selectedCommands.clear();
                  isProceeded.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectionPage()),
                  );
                  _showStoreRouteSuccessDialog(context);
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
            //child: WebViewWidget(controller: controller),
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
                      .asMap()
                      .entries
                      .map(
                        (MapEntry map) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteCommand(map.key);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    map.value+" " ++"m",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon:
                                  isProceeded[map.key] == false
                                ?Icon(Icons.play_arrow, color: Colors.green)
                                :Icon(Icons.check, color: Colors.green),
                                onPressed: () {
                                  _pressArrow(map.key);// Add logic to test the command here
                                },
                              ),
                            ],
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
    'Spin',
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

  void _showRegistrationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Text('You have successfully registered the drone.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _submitData() {
    howManyDrone++;
    setState(() {
      droneList.add(Drone(_nameController.text, _ipController.text, howManyDrone-1));
    });
    /*for (var drone in droneList) {
      print("Drone Name: ${drone.name}, IP: ${drone.ip}");
    }*/
    Navigator.pop(context);
    _showRegistrationSuccessDialog(context);
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

class SelectDronePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Drone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var drone_ in droneList)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      selectedDroneIndex =  drone_.number;
                      fromWhereToSelectionPage == "newroute"
                      ?Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RouteDestinationSetupPage()),
                      )
                          : Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RouteDestinationPage(droneList[selectedDroneIndex].routes)),
                      );
                      // Perform action when the drone is selected
                      print('Selected Drone: $drone_');
                      // Add your desired action here
                    },
                    child: Text(drone_.name),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dobermann'),
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
                      Icon(Icons.add_circle, size: 45),
                      SizedBox(height: 10),
                      Text(
                          'Register',
                          style: cool_font
                      ),
                      Text(
                          'Drone',
                          style: cool_font
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
                      Icon(Icons.schedule, size: 45),
                      SizedBox(height: 10),
                      Text(
                        'Schedule',
                        style: cool_font
                      ),
                      Text(
                        'Mission',
                        style: cool_font
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
                    fromWhereToSelectionPage = "newroute";
                    droneList.isEmpty
                    ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DroneRegistrationPage()),
                    )
                    : Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectDronePage()),
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
                      Icon(Icons.airplanemode_active, size: 45),
                      SizedBox(height: 10),
                      Text(
                        'Create',
                        style: cool_font
                      ),
                      Text(
                        'New',
                        style: cool_font
                      ),
                      Text(
                          'Route',
                          style: cool_font
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    fromWhereToSelectionPage = "selectroute";
                    droneList.isEmpty
                    ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DroneRegistrationPage()),
                    ) :Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectDronePage()),
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
                      Icon(Icons.add_location, size: 45),
                      SizedBox(height: 10),
                      Text(
                          'Start',
                          style: cool_font
                      ),
                      Text(
                          'Mission',
                          style: cool_font
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

var cool_font = GoogleFonts.rubik(
    textStyle: TextStyle(
    fontSize: 26,
    color: Color.fromRGBO(114, 56, 35, 1),
    fontWeight: FontWeight.w700,
  ));









// The main function and other necessary code here




// Implement the other pages for route destination selection, mission scheduling, route destination setup, and drone registration similarly.
