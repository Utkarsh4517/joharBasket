import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:johar/constants/colors.dart';
import 'package:johar/constants/dimensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, weight: 60),
        backgroundColor: orangeColor,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: orangeColor,
              ),
              child: Text('Johar Basket'),
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.bagShopping,
              ),
              title: Text('Groceries'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.bagShopping,
              ),
              title: Text('Cosmetics'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.bagShopping,
              ),
              title: Text('Stationaries'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.bagShopping,
              ),
              title: Text('Pooja Products'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: getScreenWidth(context),
                height: getScreenheight(context) * 0.35,
                decoration: BoxDecoration(color: orangeColor, borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05),
                      height: getScreenheight(context) * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: TypeAheadField(
                        
                        controller: controller,
                        itemBuilder: (context, value) {
                          return Container();
                        },
                        onSelected: (value) {},
                        suggestionsCallback: (search) {},
                        builder: (context, controller, focusNode) {
                          return TextFormField(
                            cursorColor: Colors.black,
                            controller: controller,
                            style: GoogleFonts.poppins(color: const Color.fromRGBO(51, 51, 51, 1), fontWeight: FontWeight.w700, fontSize: 12),
                            focusNode: focusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              suffix: (controller.text.isNotEmpty)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          controller.text = '';
                                        });
                                      },
                                      child: Icon(FontAwesomeIcons.cross))
                                  : Icon(FontAwesomeIcons.magnifyingGlass),
                              errorStyle: GoogleFonts.poppins(
                                color: Colors.red,
                              ),
                              labelText: 'Search Products',
                              labelStyle: GoogleFonts.poppins(
                                color: const Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.w600,
                                fontSize: getScreenWidth(context) * 0.035,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(216, 216, 216, 1)),
                                 borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder:UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(216, 216, 216, 1)),
                                 borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
