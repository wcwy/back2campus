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
  List routeList = []; // TO BE CHANGE TO [] AFTER _retrieveRoutes() IS IMPLEMENTED

  /*
    There are a total of 3 functions in this class.
    @override Widget build() - The standard function needed every page
    @override void initState() - We use this to call _retrieveLayouts() before build() is called by flutter
    Future<void> _retrieveLayouts() async - We will retrieve the info from database here, and update the routeList variable
   */

  // Function 1
  @override
  void initState() {
    _retrieveSharedRoute(); // call _retrieveSharedRoute()
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
          title: Text("$chosenSource => $chosenDestination"),
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
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/writeroute');
              },
              icon: const Icon(Icons.edit_outlined),
            )
          ],
      ),
      /* END OF APP BAR */

      body: SingleChildScrollView( // This SingleChildScrollView allow the page to be scrolled if the list is too long
        child: Container( // This Container wraps our list, the style can be set here
          color: Colors.white70,
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
                    return InkWell(
                      child: Container(
                        height: 80,
                        color: Colors.white70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                routeList[index]["route_description"],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),


                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Text(
                                      "Posted on: ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,

                                      )
                                  ),
                                ),
                                Text(
                                    (routeList[index]["last_edited_time"]).substring(0,10),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,

                                    )
                                )
                              ],
                            )
                          ],
                        )
                      ),
                      onTap: () {
                        setState(() {
                          routeselected = routeList[index]["route_id"];
                        });
                        Navigator.pushNamed(context, '/viewroute');
                      },
                    );;
                  },
                  separatorBuilder: (context, index){ // For every 2 items built, a separator will be built between them
                    return const Divider(
                      color: Colors.black12, // Here i build just a divider line
                      indent: 16,
                      endIndent: 16,
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
  Future<void> _retrieveSharedRoute() async {
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
      destination_id = res.data[0]['location_id']; // Set destination_id to the location id found
    }

    res = await supabase
        .from('locations') // SELECT FROM TABLE NAME 'locations'
        .select('location_id, latitude') // TO FIND THE COLUMNS 'location_id' and 'latitude'
        .eq('location_name', chosenSource) // WHICH THE COLUMN 'location_name' MATCHES chosenDestination
        .execute(); // EXECUTE THIS QUERY

    if(res.hasError){ // CHECK IF THERE IS ANY ERROR
      context.showErrorSnackBar(message: res.error!.message); // PRINT ERROR MSG ON APP
    }else {
      /*
        res.data is a list of dictionaries. Each row returned is a dictionary. In the dictionary, column name is the key, data stored is the value.
       */
      /*print(res.data); // This will be printed in the RUN console.
      print(res.data[0]); // If multiple rows are found, it will be stored in res.data[i]. Since location is unique, it's at [0]
      print(res.data[0]['location_id']); // This will give the location_id field
      print(src.data[0]['latitude']); // This will give the latitude field */
      source_id = res.data[0]['location_id']; // Set destination_id to the location id found
    }

    res = await supabase
        .from('routes')
        .select('''
          route_id,
          route_description,
          source:src_location_id ( location_name ),
          destination:end_location_id ( location_name ),
          user_id,
          last_edited_time
        ''')
        .eq("src_location_id", source_id)
        .eq("end_location_id", destination_id)
        .execute(); // EXECUTE THIS QUERY

    if(res.hasError){ // CHECK IF THERE IS ANY ERROR
      context.showErrorSnackBar(message: res.error!.message); // PRINT ERROR MSG ON APP
    }else {
      setState(() {
        print(res.data);
        routeList = res.data;
      });
    }
  }
}

