import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:smart_quran/model/model_listayat.dart';

class ListAyat extends StatefulWidget {
  @override
  _ListAyatState createState() => _ListAyatState();
}

class _ListAyatState extends State<ListAyat> {
  @override
  List<ModelListAyat> _faq = List<ModelListAyat>();
  List<ModelListAyat> _faqForDisplay = List<ModelListAyat>();

  Future<List<ModelListAyat>> fetchNotes() async {
    final String url = 'https://api.banghasan.com/quran/format/json/surat';
    final response = await http.get(url);

    var faqs = List<ModelListAyat>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(utf8.decode(response.bodyBytes));
      print(notesJson['hasil']);
      for (var noteJson in notesJson['hasil']) {
        faqs.add(ModelListAyat.fromJson(noteJson));
      }
    } else {
      throw Exception('Failed to load List Ayat');
    }

    return faqs;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      print(value);
      setState(() {
        _faq.addAll(value);
        _faqForDisplay = _faq;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Color(0xFF4ba592),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Center(
                    child: Text(
                  'Smart Quran',
                  style: TextStyle(
                      color: Color(0xFF4ba592),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ))
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(primary: false, children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 3.0, bottom: 10, left: 3),
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? _searchBar()
                                  : _listItem(index - 1);
                            },
                            itemCount: _faqForDisplay.length + 1,
                          ))),
                ]),
              ),
            ),
          )
        ],
      ),
    ));
  }

  _searchBar() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
        child: TextField(
          style: TextStyle(color: Color(0xFF4ba592), fontFamily: "JosefinSans"),
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintStyle: TextStyle(
                  fontSize: 17.0,
                  color: Colors.grey,
                  fontFamily: "JosefinSans"),
              hintText: 'Cari...',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))),
          onChanged: (text) {
            text = text.toLowerCase();
            setState(() {
              _faqForDisplay = _faq.where((note) {
                var noteTitle = note.nama.toLowerCase();
                return noteTitle.contains(text);
              }).toList();
            });
          },
        ),
      ),
    );
  }

  _listItem(index) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          FontAwesomeIcons.certificate,
                          color: Color(0xFF4ba592),
                          size: 35.0,
                        ),
                      ),
                      Center(
                          child: Text(
                        _faqForDisplay[index].nomor,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white),
                      )),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    _faqForDisplay[index].nama,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4ba592),
                        fontFamily: "JosefinSans"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  _faqForDisplay[index].asma,
                  style: GoogleFonts.harmattan(
                      color: Color(0xFF4ba592),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
