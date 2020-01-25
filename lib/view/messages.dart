import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/controller/user_story_api.dart';
import 'package:my_agile_story_flutter_app/controller/project_api.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';

void messagePopup(String title, Color titleColor, String message, context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void messagePopupNoDismiss(String title, Color titleColor, String message, context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Updating data',
          style: TextStyle(color: titleColor),
        ),
        content: Text(message),
        actions: <Widget>[
        ],
      );
    },
  );
}

void deleteWarningPopup(String itemType, String itemName, context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Warning !', style: TextStyle(color: Colors.red)),
        content: myRichText(itemType, itemName),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: const Text('DELETE'),
            onPressed: () {
              switch (itemType) {
                case 'user story':
                  {
                    deleteUserStory(myLastSelectedUserStory, context);
                  }
                  break;
                case 'project':
                  {
                    deleteProject(myLastSelectedProject, context);
                    myLastSelectedProject = -1;
                  }
                  break;
                default:
                  {}
                  break;
              }
            },
          )
        ],
      );
    },
  );
}

RichText myRichText(String itemType, String itemName) {
  var text = new RichText(
    text: new TextSpan(
      style: new TextStyle(
        fontSize: 14.0,
        color: Colors.black,
      ),
      children: <TextSpan>[
        new TextSpan(
            text: 'You are about to delete ' + itemType + ', ',
            style: new TextStyle(fontSize: 17)),
        new TextSpan(
            text: itemName,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        new TextSpan(
            text: '.  This process is irreversable are you sure?',
            style: new TextStyle(fontSize: 17)),
      ],
    ),
  );
  return text;
}

