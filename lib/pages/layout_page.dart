import 'package:flutter/material.dart';
import 'package:back2campus/utils/constants.dart';
import 'package:back2campus/pages/upload_layout.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({Key? key}) : super(key: key);

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  List layoutList = [];
  Future<void> _retrieveLayouts() async {
    var res = await supabase
        .from('locations')
        .select('location_id')
        .eq('location_name', chosenDestination)
        .execute();
    if(res.hasError){
      context.showErrorSnackBar(message: res.error!.message);
    }else {
      final location_id = res.data[0]['location_id'];
      res = await supabase
          .from('layouts')
          .select('floor_level, layoutmap_url')
          .eq('location_id', location_id)
          .execute();
      if(res.hasError){
        context.showErrorSnackBar(message: res.error!.message);
      }else {
        setState(() {
          layoutList = res.data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text("Internal Layout ($chosenDestination)"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/routing');
            },
            icon: const Icon(Icons.home),
          )
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.blueGrey
          ),
          child: Column(
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  physics:NeverScrollableScrollPhysics(),

                  itemCount: layoutList.length,
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        Container(
                          height: 10,
                        ),
                        Text(layoutList[index]['floor_level']),
                        Image.network(supabase.storage.from('layoutmaps').getPublicUrl(layoutList[index]['layoutmap_url']).data!),

                      ],
                    );

                  },
                  separatorBuilder: (context, index){
                    return Divider(
                      color: Colors.blueGrey,
                    );
                  }
              ),
              UploadLayout(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _retrieveLayouts();
    super.initState();
  }
}