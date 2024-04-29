import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ApiCall extends StatefulWidget {
  const ApiCall({Key? key}) : super(key: key);

  @override
  State<ApiCall> createState() => _ApiCallState();
}

class _ApiCallState extends State<ApiCall> {
  late List<dynamic> datalist = [];
  bool isLoading = false;
  Future<void> fetchData(String url) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        datalist = jsonDecode(response.body);
        isLoading = false;
      });
      print('$response');
    } else {
      setState(() {
        isLoading = false; // Set loading state to false (in case of error)
      });
      print("request status failed");
    }
  }

  void initState() {
    String url = "https://jsonplaceholder.typicode.com/posts";
    super.initState();

    fetchData(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: datalist.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Detailpage(datalist[index]['id'])));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                  title:
                                      Text(datalist[index]['title'].toString()),
                                  subtitle: Text(
                                    datalist[index]['body'],
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class Detailpage extends StatefulWidget {
  int id;
  Detailpage(this.id);

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  Map<dynamic, dynamic> daatalist = {}; // Initial empty Map (optional)
  Future<void> fetchData(String url) async {
    setState(() {
      // isLoading = true;
    });
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        daatalist = jsonDecode(response.body);
        // isLoading = false;
      });
      print('$response');
    } else {
      setState(() {
        // isLoading = false; // Set loading state to false (in case of error)
      });
      print("request status failed");
    }
  }


  void initState() {
    int id = widget.id;

    String url = "https://jsonplaceholder.typicode.com/posts/$id";
    super.initState();
    print("--------------------");
    print(url);
    fetchData(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(daatalist.toString()),
        ),
      ),
    );
  }
}
