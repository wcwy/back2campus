import 'package:flutter/material.dart';
//import 'package:back2campus/utils/map_coordinates.dart';
import 'package:supabase/supabase.dart';
import 'package:back2campus/components/auth_required_state.dart';
import 'package:back2campus/utils/constants.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({Key? key}) : super(key: key);

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}
// class _RoutingPageState extends AuthRequiredState<RoutingPage> { // can change to this in future for safer auth
class _RoutingPageState extends State<RoutingPage> {
  // Initialised by _retrieveLocations()
  var lat = {};
  var longt = {};
  var sourceitems = [chosenSource]; // Dropdown list item
  String sourcedropdownvalue = chosenSource; // Dropdown list display value
  var destinationitems = [chosenDestination]; // Dropdown list item
  String destinationdropdownvalue = chosenDestination; // // Dropdown list display value
  Widget customMap = Image.network("https://developers.onemap.sg/commonapi/staticmap/getStaticImage?layerchosen=original&lat=1.2950855&lng=103.7739801&zoom=17&height=512&width=512&polygons=&lines=&points=[1.2950855,103.7739801,%22175,50,0%22,%22S%22]&color=&fillColor=");

  // Retrieve all the available locations in database (for dropdown menu selection)
  Future<void> _retrieveLocations() async {
    // Get all the locations (name, lat, longt) from locations table
    var res = await supabase
        .from('locations')
        .select('location_name, latitude, longtitude')
        .execute();
    if(res.hasError){
      context.showErrorSnackBar(message: res.error!.message);
    }else {
      List<String> mapitemstemp = [];
      var lattemp = {};
      var longttemp = {};
      for(var i=0; i<res.data.length; i++){
        //for(var i=0; i<1; i++){
        mapitemstemp.add(res.data[i]['location_name']);
        lattemp[res.data[i]['location_name']] = res.data[i]['latitude'];
        longttemp[res.data[i]['location_name']] = res.data[i]['longtitude'];
      }

      setState(() {
        sourceitems = mapitemstemp;
        destinationitems = mapitemstemp;
        lat = lattemp;
        longt = longttemp;
      });

      _showMap();
    }
  }

  @override
  void initState() {
    _retrieveLocations();
    super.initState();
  }

  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }else{
      Navigator.pushNamed(context, '/');
    }
  }

  // Call OneMap API with the latitude and longtitude of the two user selected locations
  // and update the customMap to the image received from OneMap API
  Future<void> _showMap() async {
      setState((){

        var srclat = lat[sourcedropdownvalue];
        var destlat = lat[destinationdropdownvalue];
        var srclongt = longt[sourcedropdownvalue];
        var destlongt = longt[destinationdropdownvalue];
        if(srclat!=null && destlat!=null && srclongt!=null && destlongt!=null){
          var imglink = "https://developers.onemap.sg/commonapi/staticmap/getStaticImage?layerchosen=original&lat=${srclat}&lng=${srclongt}&zoom=17&height=512&width=512&polygons=&lines=&points=[${destlat},${destlongt},%22175,50,0%22,%22D%22]|[${srclat},${srclongt},%220,155,0%22,%22S%22]&color=&fillColor=";
          chosenSource = sourcedropdownvalue;
          chosenDestination = destinationdropdownvalue;
          customMap = Image.network(imglink);
        }else{
          showDialog(context: context, builder: (BuildContext context){
            return const AlertDialog(
              title: Text("Building(s) not found!"),
              content: Text("Please try another spelling or contact admin."),
            );
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Locate NUS buildings'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              // TODO: PROFILE PAGE
            },
            icon: const Icon(Icons.account_circle_sharp),
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.blueGrey
        ),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                children: <Widget>[
                  Container(
                    child: const Text(
                      "Source",
                    ),
                    width: 55,
                  ),
                  const Text(
                      ": "
                  ),
                  DropdownButton(
                    //isExpanded: true,
                    // Initial Value
                    value: sourcedropdownvalue, //REMOVED AS THE RELOAD DOESN'T WORK

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: sourceitems.map((String items) {
                      return DropdownMenuItem<String>(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) async {
                      setState(() {
                        sourcedropdownvalue = newValue!;
                      });
                      _showMap();
                    },
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                children: <Widget>[
                  Container(
                    child: const Text(
                      "Ending",
                    ),
                    width: 55,
                  ),
                  const Text(
                      ": "
                  ),
                  DropdownButton(
                    //isExpanded: true,
                    // Initial Value
                    value: destinationdropdownvalue, //REMOVED AS THE RELOAD DOESN'T WORK

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: destinationitems.map((String items) {
                      return DropdownMenuItem<String>(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) async{
                      setState(() {
                        destinationdropdownvalue = newValue!;
                      });
                      _showMap();
                    },
                  ),
                ]
              ),
              Container(
                height: 10,
              ),
              customMap,
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/layout');
                      },
                      child: const Text('Internal Layout'),
                    ),
                    Container(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/shared');
                      },
                      child: const Text('Shared Routes'),
                    ),
                    ],
                ),
              ),

              ElevatedButton(
                onPressed: (){
                    _signOut();
                    },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

