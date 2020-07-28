

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GstInfoPage extends StatefulWidget {
  GstInfoPage({this.retailerId});
  final  retailerId;

  @override
  _GstInfoPageState createState() => _GstInfoPageState();
}
class _GstInfoPageState extends State<GstInfoPage> {
  String lgnm='Not Available', tradeNam='Not Available', stj='Not Available', rgdt='Not Available', ctb='Not Available', dty='Not Available', nba='Not Available', sts='Not Available', cxdt='Not Available', lstupdt='Not Available', stjCd='Not Available', ctjCd='Not Available', adadr='Not Available', addr='Not Available';



  @override
  void initState() {



    getGstData();

    super.initState();
  }




  Future getGstData() async {
    String retailerID = widget.retailerId();
    print(retailerID);

    final DocumentReference document =   await Firestore.instance.collection('retailersList').document(retailerID);

    await document.get().then((snapshot) async{
      setState(() {
        lgnm=snapshot.data['gstInfo']['lgnm'].toString();
        tradeNam=snapshot.data['gstInfo']['tradeNam'].toString();
        stj=snapshot.data['gstInfo']['stj'].toString();
        rgdt=snapshot.data['gstInfo']['rgdt'].toString();
        ctb=snapshot.data['gstInfo']['ctb'].toString();
        dty=snapshot.data['gstInfo']['dty'].toString();
        nba=snapshot.data['gstInfo']['nba'].toString();
        sts=snapshot.data['gstInfo']['sts'].toString();
        cxdt=snapshot.data['gstInfo']['cxdt'].toString();
        lstupdt=snapshot.data['gstInfo']['lstupdt'].toString();
        stjCd=snapshot.data['gstInfo']['stjCd'].toString();
        adadr=snapshot.data['gstInfo']['adadr'].toString();
        addr=snapshot.data['gstInfo']['addr'].toString();
        ctjCd=snapshot.data['gstInfo']['ctjCd'].toString();



      });
    });
  }


  @override
  Widget build(BuildContext context) {


    final makeBody = Container(
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Trade Name ",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            tradeNam,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Legal Name of Business",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            lgnm,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "State Jurisdiction",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            stj,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Date of Registration",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            rgdt,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Constitution of Business",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            ctb,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Taxpayer Type",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            dty,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Nature of Business Activity",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            nba,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "GSTIN Status",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            sts,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Date of Cancellation",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            cxdt,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Last Updated Date",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            lstupdt,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "State Jurisdiction Code",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            stjCd,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Centre Jurisdiction Code",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            ctjCd,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Addtional Place of Business Fields",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            adadr,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                          child: Text(
                            "Additional Place of Business Address",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                          child: Text(
                            addr,
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              ),
            ],
          )
          ]

      )

    );


    final topAppBar = AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(94, 197, 198, 1),
        title: Text("GST Info",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),),

        centerTitle: true
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(210, 253, 253, 1),
      appBar: topAppBar,
      body: makeBody,

    );

  }


}