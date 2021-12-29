import 'package:flutter/material.dart';
import 'package:nexus/utils/devicesize.dart';

class registerScreen extends StatelessWidget {
  const registerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Image.asset(
                'images/register.jpg',
                height: displayHeight(context) * 0.35,
                width: displayWidth(context),
                fit: BoxFit.cover,
              ),
              Opacity(opacity: 0.0, child: Divider(height: displayHeight(context)*0.005,)),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Text(
                  'Register to Nexus !!',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: displayWidth(context) * 0.065),
                ),
              ),
              Opacity(opacity: 0.0, child: Divider(height: displayHeight(context)*0.036,)),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  'Full Name',
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.w400,
                      fontSize: displayWidth(context) * 0.042),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 18.0, right: 18),
                child: Container(
                  height: displayHeight(context) * 0.066,
                  width: displayWidth(context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 0.8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextFormField(
                        //  controller: title,
                        validator: (value) {
                          if (value!.isEmpty || value.length == 0)
                            return 'Cannot be empty';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: displayWidth(context) * 0.04),
                          hintText: 'Alpha',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(opacity: 0.0,child: Divider(
                height: displayHeight(context)*0.025,
              )),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  'Email address',
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.w400,
                      fontSize: displayWidth(context) * 0.042),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 18.0, right: 18),
                child: Container(
                  height: displayHeight(context) * 0.066,
                  width: displayWidth(context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 0.8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextFormField(
                        //  controller: title,
                        validator: (value) {
                          if (value!.isEmpty || value.length == 0)
                            return 'Cannot be empty';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintStyle:
                          TextStyle(fontSize: displayWidth(context) * 0.04),
                          hintText: 'alpha77@yahoo.com' ,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(opacity: 0.0,child: Divider(
                height: displayHeight(context)*0.025,
              )),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  'Password',
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.w400,
                      fontSize: displayWidth(context) * 0.042),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 18.0, right: 18),
                child: Container(
                  height: displayHeight(context) * 0.066,
                  width: displayWidth(context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 0.8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextFormField(
                        obscureText: true,
                        //  controller: title,
                        validator: (value) {
                          if (value!.isEmpty || value.length == 0)
                            return 'Cannot be empty';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintStyle:
                          TextStyle(fontSize: displayWidth(context) * 0.04),
                          hintText: '*******' ,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(opacity: 0.0,child: Divider(
                height: displayHeight(context)*0.03,
              )),
              Center(
                child: Container(
                  height: displayHeight(context) * 0.07,
                  width: displayWidth(context) * 0.8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.deepOrange,
                          Colors.deepOrangeAccent,
                          Colors.orange[600]!,
                        ]),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.04),
                    ),
                  ),
                ),
              ),
              Opacity(opacity: 0.0,child: Divider(
                height: displayHeight(context)*0.01,
              )),
              Center(
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: displayWidth(context)*0.045,
                        color: Colors.black54,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
