import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// text controller
  final TextEditingController _myController = TextEditingController();

  String _countryDialCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.mirror,
              colors: [
                Color(0xffDDD8FF),
                Color(0xffffffff),
              ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: EdgeInsets.only(top: 20, right: 10, bottom: 16),
            decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset(0, 3))
                ],
                border: Border.all(color: Color(0xFFDDD7FF), width: 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Icon(Icons.arrow_back_ios, size: 14),
          ),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Quitter ',
                  style: TextStyle(
                    shadows: [
                      Shadow(
                        color: Color(0xFF212529),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      )
                    ],
                    color: Color(0xFF212529),
                    fontSize: 20,
                    fontFamily: 'Montaga',
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: 'CABVY',
                  style: TextStyle(
                    color: Color(0xFF9F85FF),
                    shadows: [
                      Shadow(
                        color: Color(0xFF9F85FF),
                        offset: Offset(0, 3),
                        blurRadius: 4,
                      )
                    ],
                    fontSize: 20,
                    fontFamily: 'Montaga',
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF9F85FF),
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/image/x_images.png', width: 210, height: 200),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Entrez vos ',
                    style: TextStyle(
                      shadows: [
                        Shadow(
                          color: Color(0xFF43494D),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        )
                      ],
                      color: Color(0xFF212529),
                      fontSize: 22,
                      fontFamily: 'Montaga',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: 'coordonnées',
                    style: TextStyle(
                      shadows: [
                        Shadow(
                          color: Color(0xFF9F85FF),
                          offset: Offset(0, 3),
                          blurRadius: 4,
                        )
                      ],
                      color: Color(0xFF9F85FF),
                      fontSize: 22,
                      fontFamily: 'Montaga',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 248,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nous procéderons ensuite à la ',
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            color: Color(0xFF43494D),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          )
                        ],
                        color: Color(0xFF212529),
                        fontSize: 15,
                        fontFamily: 'Montaga',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: 'suppression',
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            color: Color(0xFF9F85FF),
                            offset: Offset(0, 3),
                            blurRadius: 4,
                          )
                        ],
                        color: Color(0xFF9F85FF),
                        fontSize: 15,
                        fontFamily: 'Montaga',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: ' complet de votre compte.',
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            color: Color(0xFF43494D),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          )
                        ],
                        color: Color(0xFF212529),
                        fontSize: 15,
                        fontFamily: 'Montaga',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
// display the entered numbers
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Row(children: [
                    Container(
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 3),
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 1)
                        ],
                      ),
                      child: CodePickerWidget(
                        boxDecoration: BoxDecoration(
                          color: Colors.teal,
                        ),
                        onChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        // countryFilter: [_countryDialCode],
                        showDropDownButton: true,
                        padding: EdgeInsets.zero,
                        showFlagMain: true,
                        hideMainText: true,
                        showCountryOnly: true,
                        flagWidth: 25,
                        textStyle: robotoRegular.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Expanded(
                        child: Container(
                          height: 58,
                          padding: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 1)
                            ],
                          ),
                          child: TextField(
                            maxLines: 1,
                            maxLength: 10,
                            autofocus: false,
                            controller: _myController,
                            keyboardType: TextInputType.none,
                            textAlign: TextAlign.center,
                            readOnly: true,
                            showCursor: false,
                            decoration: InputDecoration(
                              counter: Offstage(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              isDense: true,
                              hintText: '06 00 60 44',
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        )),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
