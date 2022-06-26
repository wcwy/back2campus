import 'package:flutter/material.dart';
import 'package:back2campus/utils/constants.dart';

class SharedPage extends StatefulWidget {
  const SharedPage({Key? key}) : super(key: key);

  @override
  State<SharedPage> createState() => _SharedPageState();
}

class _SharedPageState extends State<SharedPage> {
  /*
    This variable below is accessible within the class _SharedPageState.
    We need to update its value with the route list retrieved from database through initState() and _retrieveRoutes(),
    so that the listing can be displayed in build().
   */
  List routeList = [1,1,1,1,1]; // TO BE CHANGE TO [] AFTER _retrieveRoutes() IS IMPLEMENTED

  /*
    There are a total of 3 functions in this class.
    @override Widget build() - The standard function needed every page
    @override void initState() - We use this to call _retrieveLayouts() before build() is called by flutter
    Future<void> _retrieveLayouts() async - We will retrieve the info from database here, and update the routeList variable
   */

  // Function 1
  @override
  void initState() {
    _retrieveLayouts(); // call _retrieveLayouts()
    super.initState();
  }

  // Function 2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* START OF APP BAR */
      appBar: AppBar(
          toolbarHeight: 100,
          /*
            The line below this comment is the title of the app bar.
            The $chosenSource and $chosenDestination are global variables defined in utils/constants.dart
            These 2 variables are initialised to COM1 and COM2, but can be updated when user do their searches in routing_page.dart
            (The update take place at routing_page.dart line 66,67)
           */
          title: Text("List of routes for $chosenSource => $chosenDestination"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          /*
            The IconButton below is the home button which clicking it will redirect to routing_page.dart
           */
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/routing');
            },
            icon: const Icon(Icons.home),
          )
      ),
      /* END OF APP BAR */

      body: SingleChildScrollView( // This SingleChildScrollView allow the page to be scrolled if the list is too long
        child: Container( // This Container wraps our list, the style can be set here
          decoration: const BoxDecoration(
              color: Colors.yellow // Setting background to yellow colour
          ),
          child: Column(
            children: [
              /*

                As the number of routes shared by users btw. two locations can changes, we need a dynamic way to display the routes
                ListView.separated will help us for it.
                Reference: https://www.kindacode.com/article/flutter-adding-separators-to-list-view/

               */
              ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  physics:NeverScrollableScrollPhysics(),

                  itemCount: routeList.length, // Set number of items needed to displayed in list view to the length of routeList
                  itemBuilder: (context, index){ // The index will start counting from 0 to itemCount, like a for(int i=0; i<itemCount; i++) loo[
                    // TODO: Change the Text() below to display the routes found from the database, after completing _retrieveLayouts() function
                    return Text("Hello $index");
                  },
                  separatorBuilder: (context, index){ // For every 2 items built, a separator will be built between them
                    return Divider(
                      color: Colors.blueGrey, // Here i build just a divider line
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function 3
  Future<void> _retrieveLayouts() async {
    /*
      In this function, we need to find how many routes are being shared for the $chosenSource and $chosenDestination
      Then, we will update the list of routes found from database to variable "routeList"
     */

    /*
      The shared routes stored in database is stored under routes table. To view them:
      https://app.supabase.com/ > Left menu click Table Editor > Below "All table" click route
      The route table stores the following fields:
        route_id, (autogenerated for each route inserted to database)
        user_id (who shared the route),
        src_location_id (the location id of the source, linked to "locations" table. In "locations" table, the location name, lat, longt are stored)
        end_location_id (the destination id, same as above)
        route_description (title of the shared route given by user)
        route_content (content of the shared route, not required here)
     */

    /*
      What we needed to do in this function:
      1. Find the location_id of $chosenSource and $chosenDestination by searching the database
      2. Using these location_ids found, query the database to find the routes that matches them
      3. Set "routeList" to the data found in (2)
     */

    // VARIABLES TO WORK WITH
    var source_id = "";
    var destination_id = "";

    // SAMPLE ON HOW TO QUERY THE DATABASE TO FIND LOCATION ID OF $chosenDestination
    var res = await supabase
        .from('locations') // SELECT FROM TABLE NAME 'locations'
        .select('location_id, latitude') // TO FIND THE COLUMNS 'location_id' and 'latitude'
        .eq('location_name', chosenDestination) // WHICH THE COLUMN 'location_name' MATCHES chosenDestination
        .execute(); // EXECUTE THIS QUERY

    if(res.hasError){ // CHECK IF THERE IS ANY ERROR
      context.showErrorSnackBar(message: res.error!.message); // PRINT ERROR MSG ON APP
    }else {
      /*
        res.data is a list of dictionaries. Each row returned is a dictionary. In the dictionary, column name is the key, data stored is the value.
       */
      print(res.data); // This will be printed in the RUN console.
      print(res.data[0]); // If multiple rows are found, it will be stored in res.data[i]. Since location is unique, it's at [0]
      print(res.data[0]['location_id']); // This will give the location_id field
      print(res.data[0]['latitude']); // This will give the latitude field
      destination_id = res.data[0]['location_id']; // Set destination_id to the location id found
    }

    // TODO: lookup "locations" table to update source_id
    // TODO: lookup "routes" table to find all the routes with source_id and destination_id

    /* // THIS CAN BE USED TO SET THE ROUTE LIST AFTER THE ROUTES ARE FOUND FROM DATABASE
    setState(() {
      routeList = res.data;
    });
     */
  }
}

