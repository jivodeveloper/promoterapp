import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';

class ApiProider with ChangeNotifier{

  void login(context, String user,String pass) async {


    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.post(Uri.parse(
        '${IP_URL}LoginSalesPerson?user=$user&password=$pass'),
        headers: headers);

    try {

      if (response.statusCode == 200) {

        if (details.personId != 0) {

          try {

            if(details.personType.toString().contains("PROMOTER")){

              SharedPrefClass.setInt(USER_ID, details.personId);
              SharedPrefClass.setString(PERSON_TYPE, details.personType.toString());
              SharedPrefClass.setString(PERSON_NAME, details.personName.toString());
              SharedPrefClass.setString(GROUP, details.group.toString());
              SharedPrefClass.setString(DISTANCE_ALLOWED, details.distanceAllowed.toString());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(),
                ),
              );

            }else{

              Fluttertoast.showToast(
                  msg: "Please check username and password !",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);

            }

          } catch (e) {

            //print("distanceallowed$e");

          }

          Fluttertoast.showToast(
              msg: "Successfully logged in",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);

        } else {

          Fluttertoast.showToast(
            msg: "Please check your userid and password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

        }

      } else {

        Fluttertoast.showToast(
          msg: "Please check your credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );

      }

    } catch (e) {

      Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: black,
        textColor: white,
        fontSize: 16.0,
      );

    }

    progress?.dismiss();
    return details;

  }

}