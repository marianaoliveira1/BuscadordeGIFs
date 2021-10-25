import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {

  String? _search;
  int _offset = 0;

  Future<Map> _getGif() async {
    http.Response response;

    if(_search == null)
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=o760RNRijdbYiOrCK7lkwkyb6uk08BUR&limit=30&rating=g");
    else
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=o760RNRijdbYiOrCK7lkwkyb6uk08BUR&q=$_search&limit=30&offset=$_offset&rating=g&lang=pt");

    return jsonDecode(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: _getGif(),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                      default:
                        if(snapshot.hasError)
                          return Container();
                        else
                          return _createGidTable(context, snapshot);
                  }
                },
              ),
          ),
        ],
      ),
    );
  }

  Widget _createGidTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0
      ),
      itemCount: snapshot.data["data"].lenght,
      itemBuilder: (context, index){
        return GestureDetector(
          child:  Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
          height: 300.0,
            fit: BoxFit.cover,),

        );
      },
    );
  }
}


