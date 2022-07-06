import 'package:FAHMIAASMOBILE/View/Component/Category.dart';
import 'package:FAHMIAASMOBILE/View/Screens/Detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _value = 0;

  List<String> Categorietitle = [
    "All",
    "Iphone",
    "Macbook",
    "Android",
  ];

  Future<List<dynamic>> _fecthDataUsers() async {
    var result = await http.get(Uri.parse('https://dummyjson.com/products'));
    return json.decode(result.body)['products'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 21, 21, 21),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 21, 21, 21),
        elevation: 0,
        title: const Text(
          'TOKOKULAKUTERUS',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('diskon.jpg'), fit: BoxFit.contain)),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(Categorietitle.length, (index) {
                  return MyRadioListTile<int>(
                    value: index,
                    groupValue: _value,
                    leading: Categorietitle[index],
                    onChanged: (value) {
                      setState(() {
                        _value = value!;
                      });
                    },
                  );
                }),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<List<dynamic>>(
            future: _fecthDataUsers(),
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: (() {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ArticlScreen(
                                            articalID:
                                                snapshot.data[index]['id'] - 1,
                                          )));
                                }),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(snapshot
                                                    .data[index]['thumbnail']),
                                                fit: BoxFit.contain)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data[index]['title'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '\$' +
                                          snapshot.data[index]['price']
                                              .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                  : const Expanded(
                      child: Center(
                      child: CircularProgressIndicator(),
                    ));
            },
          ),
        ],
      ),
    );
  }
}
