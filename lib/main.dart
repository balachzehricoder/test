import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hadith Books List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Map<String, dynamic> mapresp;
  late List<dynamic> listresp = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> callapi() async {
    var apikey = "\$2y\$10\$BylaBcXs5Lw7ZOtYmQ3PXO1x15zpp26oc1FeGktdmF6YeYoRd88e";
      http.Response response = await http.get(Uri.parse("https://hadithapi.com/api/books?apiKey=$apikey"));

      if (response.statusCode == 200) {
        setState(() {
          mapresp = jsonDecode(response.body);
          listresp = mapresp["books"];
          isLoading = false;
        });
     
    }
  }

  @override
  void initState() {
    super.initState();
    callapi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: listresp.isNotEmpty
          ? ListView.builder(
              itemCount: listresp == null ? 0 : listresp.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      var bookslug = listresp[index]["bookSlug"];
                     
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo[900],
                      radius: 30,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(listresp[index]["bookName"]),
                    subtitle: Text(listresp[index]["writerName"]),
                    trailing: Column(
                      children: [
                        Text(listresp[index]["hadiths_count"]),
                        Text(listresp[index]["chapters_count"]),
                      ],
                    ));
              },
            )
                      : Center(child: CircularProgressIndicator()),

    );
  }
}
