import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  List<String> parameter =[];
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RunningRoutePage()),
                    );
                    //_displayRoute(context, droneList[selectedDroneIndex].routes[index].storedRoutes);
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
class RunningRoutePage extends StatelessWidget {
  WebViewController controller = WebViewController()
  ..loadRequest(Uri.parse('http://192.168.0.156:8080/?action=stream'));

  WebViewController controller2 = WebViewController()
    ..loadRequest(Uri.parse('http://192.168.0.156:8081/?action=stream'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff30246e),
      appBar: AppBar(
        title: Text('Running Route'),
      ),
      body: Column(children: [
        //SizedBox(height: 100),
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.grey,
            // 第一个摄像头 WebViewWidget
            child: WebViewWidget(controller: controller),
          ),
        ),
        //SizedBox(height: 10), //畫面的間距
        SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: Color.fromRGBO(246, 128, 37, 1),
              ),
              onPressed: () {
                // 处理第一个按钮的操作
              },
            ),
            IconButton(
              icon: Icon(
                Icons.pause,
                color: Color.fromRGBO(246, 128, 37, 1),
              ),
              onPressed: () {
                // 处理第二个按钮的操作
              },
            ),
          ],
        ),
        SizedBox(height: 15),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(246, 128, 37, 1),
            ),
            child: Text(
              "Show Route",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            )),
        SizedBox(height: 35),
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.grey,
            // 第一个摄像头 WebViewWidget
            child: WebViewWidget(controller: controller2),
          ),
        ),
      ]),
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
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 40.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewSchedulingPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(246, 128, 37, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text(
              'Add New Schedule Mission',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(114, 56, 35, 1),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class NewSchedulingPage extends StatefulWidget {
  @override
  _NewSchedulingPageState createState() => _NewSchedulingPageState();
}

class _NewSchedulingPageState extends State<NewSchedulingPage> {
  final List<String> droneList = ['Drone A', 'Drone B', 'Drone C'];
  final List<String> routeList = ['Route 1', 'Route 2', 'Route 3'];
  String? selectedDrone;
  String? selectedRoute;
  String frequency = '';
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  bool fireNotification = false;
  bool movingObjectNotification = false;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedStartDate)
      setState(() {
        selectedStartDate = picked;
      });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedEndDate)
      setState(() {
        selectedEndDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Schedule Mission'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: selectedDrone,
                hint: Text('Select Drone'),
                onChanged: (String? value) {
                  setState(() {
                    selectedDrone = value;
                  });
                },
                items: droneList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedRoute,
                hint: Text('Select Route'),
                onChanged: (String? value) {
                  setState(() {
                    selectedRoute = value;
                  });
                },
                items: routeList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Repeat',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  frequency = value;
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectStartDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('Start Date: ${DateFormat('yyyy-MM-dd').format(selectedStartDate)}'),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectEndDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('End Date: ${DateFormat('yyyy-MM-dd').format(selectedEndDate)}'),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Fire Detection'),
                  Checkbox(
                    value: fireNotification,
                    onChanged: (bool? value) {
                      setState(() {
                        fireNotification = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Moving Object'),
                  Checkbox(
                    value: movingObjectNotification,
                    onChanged: (bool? value) {
                      setState(() {
                        movingObjectNotification = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Save scheduling logic
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Save Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
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
  List<String> parameterArray = [];
  WebViewController controller = WebViewController()
  ..loadRequest(Uri.parse('http://192.168.0.156:8080/?action=stream'));
  void _navigateToFlyingCommandPage() async {
    final Map<String, String> result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlyingCommandPage()),
    );

    setState(() {
      if (result != null) {
        selectedCommands.add(result['command']!);
        parameterArray.add(result['parameter']!);
        isProceeded.add(false);

      }
    });
  }
  void _deleteCommand(int index){
    setState(() {
      selectedCommands.removeAt(index);
      parameterArray.removeAt(index);
      isProceeded.removeAt(index);

    });
  }
  void _clearCommands() {
    setState(() {
      selectedCommands.clear();
      parameterArray.clear();
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
                  List<String> paratmp = List<String>.from(parameterArray);
                  final Route temp = Route(_routeNameController.text);
                  for (String route__ in tmp) {
                    temp.storedRoutes.add(route__);
                  }
                  for (String route___ in paratmp) {
                    temp.storedRoutes.add(route___);
                  }
                  droneList[selectedDroneIndex].routes.add(temp);
                  selectedCommands.clear();
                  parameterArray.clear();
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
      backgroundColor: Color(0xff30246e),
      appBar: AppBar(
        title: Text('Route Destination Setup Page'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200, // Adjust the height as needed
            color: Colors.grey, // Placeholder color for the live camera video
            child: WebViewWidget(controller: controller),
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
                                    (map.value=='Take-off' || map.value=='Landing')
                                    ?map.value
                                    :map.value+" "+parameterArray[map.key]+" meter",
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
    final _parameterController = TextEditingController();
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
                        if(command == 'Take-off')
                          {
                            Map<String, String> tmp ={
                              'command': 'Take-off',
                              'parameter': 'none'
                            };
                            Navigator.pop(context, tmp);
                          }
                        else if(command == 'Landing')
                          {
                            Map<String, String> tmp ={
                              'command': 'Landing',
                              'parameter': 'none'
                            };
                            Navigator.pop(context, tmp);
                          }
                        else
                          {
                            _showParameterDialog(context, command, _parameterController);
                          }

                        //Navigator.pop(context, command);
                      },
                      child: Text(command),
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
  void _showParameterDialog(
      BuildContext context, String command, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(command),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'meter or degree'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Handle the submission here
                String parameter = controller.text;
                // Navigate back to the RouteDestinationSetupPage
                Map<String, String> data ={
                  'command' : command,
                  'parameter' : parameter,
                };
                Navigator.pop(context);
                Navigator.pop(context, data);
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RouteDestinationSetupPage()),
                );*/
              },
            ),
          ],
        );
      },
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
