import 'package:bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';

class ForTabPage extends StatefulWidget {
  @override
  _ForTabPageState createState() => _ForTabPageState();
}

class _ForTabPageState extends State<ForTabPage> {
  int _selectedIndex = 0;
  String _name = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabs'),
      ),
      body: _buildTabContent(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Form',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_thresholding),
            label: 'Data',
          ),
        ],
      ),
    );
  }

  final TextEditingController _formNameController = TextEditingController();
  final TextEditingController _formEmailController = TextEditingController();

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return _buildForm();
      case 1:
        return _displayData();
      default:
        return Container();
    }
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getRowOfFormField('Enter Name', _formNameController),
          getRowOfFormField('Enter Email', _formEmailController),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              String name = _formNameController.text;
              String email = _formEmailController.text;

              // Save the form data to local storage
              saveFormData(name, email);
              Fluttertoast.showToast(
                  msg: "Submitted",
                  backgroundColor: Colors.grey[600],
                  textColor: Colors.white,
                  fontSize: 16.0);

              this.setState(() {
                name = _formNameController.text;
                email = _formEmailController.text;
              });
              _formNameController.clear();
              _formEmailController.clear();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _displayData() {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                'Name: $_name',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Email: $_email',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _loadFormData();
  }

  void _loadFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _email = prefs.getString('email') ?? '';
    });
  }

  Widget getRowOfFormField(String s, TextEditingController controller) {
    return Row(
      children: [
        Text(
          s,
          style: TextStyle(fontSize: 16),
        ),
        Container(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        )
      ],
    );
  }
}

void saveFormData(String name, String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('name', name);
  prefs.setString('email', email);
}
