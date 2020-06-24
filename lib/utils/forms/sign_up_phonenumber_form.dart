import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_circular_button.dart';
import 'form_validator.dart';

class SignUpWithPhoneForm extends StatefulWidget {
  @override
  _SignUpWithPhoneFormState createState() => _SignUpWithPhoneFormState();
}

class _SignUpWithPhoneFormState extends State<SignUpWithPhoneForm> {
  String _phoneNumber, _otp, _firstName, _lastName;
  bool _autoValidate = false,
      _isNetworkCall = false,
      _otpSent = false,
      _isEnable = false;
  IconData iconData = Icons.visibility_off;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _firstNameController,
                    enabled: !_isEnable,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: validator.validateName,
                    onSaved: (val) => _firstName = val,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _lastNameController,
                    enabled: !_isEnable,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: validator.validateName,
                    onSaved: (val) => _lastName = val,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    enabled: !_isEnable,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixText: '+91',
                      counterText: '',
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    validator: validator.validateNumber,
                    onSaved: (val) => _phoneNumber = val,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                _otpSent
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          onFieldSubmitted: (value) {
                            _otp = _otpController.text;
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                        'Verfied\nName: $_firstName $_lastName\nPhone Number : $_phoneNumber\nOTP: $_otp'),
                                  );
                                });
                          },
                          maxLength: 6,
                          controller: _otpController,
                          decoration: InputDecoration(
                            labelText: 'OTP',
                            counterText: '',
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (val) => _otp = val,
                        ),
                      )
                    : Container(),
                SizedBox(height: size.height * 0.03),
                !_otpSent
                    ? _isNetworkCall
                        ? Container(
                            height: size.height * 0.1,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          )
                        : CustomCicularButton(
                            height: size.height * 0.1,
                            splashColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: size.height * 0.08,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isNetworkCall = true;
                                });
                                _formKey.currentState.save();

                                // Delay to mock as network call
                                await Future.delayed(
                                    Duration(milliseconds: 100));

                                // Dialog box to display Form data we recieved
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            'Name: $_firstName $_lastName\nPhone Number : $_phoneNumber'),
                                      );
                                    });

                                setState(() {
                                  _isNetworkCall = false;
                                  _otpSent = true;
                                  _isEnable = true;
                                });
                              } else {
                                setState(() {
                                  _autoValidate = true;
                                });
                              }
                            },
                          )
                    : _isNetworkCall
                        ? Container(
                            height: size.height * 0.08,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          )
                        : CustomCicularButton(
                            height: size.height * 0.1,
                            splashColor: Colors.orangeAccent,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: size.height * 0.08,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                _isNetworkCall = true;
                              });

                              // Delay to mock as network call
                              await Future.delayed(
                                  Duration(milliseconds: 1000));

                              // Dialog box to display mock network response
                              _otp = _otpController.text;
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          'Verfied\nName: $_firstName $_lastName\nPhone Number : $_phoneNumber\nOTP: $_otp'),
                                    );
                                  });

                              setState(() {
                                _isNetworkCall = false;
                              });
                            },
                          ),
                SizedBox(height: size.height * 0.03),
                CustomButton(
                  height: size.height * 0.05,
                  child: const Text(
                    'Reset',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () async {
                    setState(() {
                      _firstNameController.clear();
                      _lastNameController.clear();
                      _phoneNumberController.clear();
                      // _otpController.clear();
                      _otpSent = false;
                      _isEnable = false;
                    });
                  },
                ),
                SizedBox(height: size.height * 0.05),
              ],
            )),
      ),
    );
  }
}
