import 'package:flutter/material.dart';
import 'package:back2campus/utils/map_coordinates.dart';
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
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Locate NUS buildings');
  TextEditingController srcController = TextEditingController();
  TextEditingController destController = TextEditingController();

  String sourcelocation = "";
  String destinationlocation = "";

  Widget customMap = Image.network("https://developers.onemap.sg/commonapi/staticmap/getStaticImage?layerchosen=original&lat=1.2950855&lng=103.7739801&zoom=17&height=512&width=512&polygons=&lines=&points=[1.2950855,103.7739801,%22175,50,0%22,%22S%22]&color=&fillColor=");

  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }else{
      Navigator.pushNamed(context, '/');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState((){
                if(customIcon.icon == Icons.search){
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: IconButton(
                      onPressed: () async {
                        setState((){
                          // DO THE SEARCH HERE!
                          customIcon = const Icon(Icons.search);
                          customSearchBar = const Text('Locate NUS buildings');
                          sourcelocation = srcController.text;
                          destinationlocation = destController.text;

                          var srclat = mapcoordinates.lat[sourcelocation];
                          var destlat = mapcoordinates.lat[destinationlocation];
                          var srclongt = mapcoordinates.longt[sourcelocation];
                          var destlongt = mapcoordinates.longt[destinationlocation];
                          if(srclat!=null && destlat!=null && srclongt!=null && destlongt!=null){
                            var imglink = "https://developers.onemap.sg/commonapi/staticmap/getStaticImage?layerchosen=original&lat=${srclat}&lng=${srclongt}&zoom=17&height=512&width=512&polygons=&lines=&points=[${destlat},${destlongt},%22175,50,0%22,%22D%22]|[${srclat},${srclongt},%220,155,0%22,%22S%22]&color=&fillColor=";
                            chosenDestination = destController.text;
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
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    title: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: srcController,
                            decoration: const InputDecoration(
                              hintText: 'Source...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            controller: destController,
                            decoration: const InputDecoration(
                              hintText: 'Destination...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }else{
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Locate NUS buildings');
                }
              });
            },
            icon: customIcon,
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

