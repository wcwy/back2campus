import 'package:flutter/material.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({Key? key}) : super(key: key);

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text("Internal Route"),
        automaticallyImplyLeading: false,
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
              Image.network("https://developers.onemap.sg/commonapi/staticmap/getStaticImage?layerchosen=original&lat=1.2950855&lng=103.7739801&zoom=17&height=512&width=512&polygons=&lines=&points=[1.2950855,103.7739801,%22175,50,0%22,%22S%22]&color=&fillColor=")
            ],
          ),
        ),
      ),
    );
  }
}
