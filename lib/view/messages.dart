import 'package:flutter/material.dart';
import 'package:my_agile_story_flutter_app/controller/api_requests.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';

void messagePopup(String title, Color titleColor, String message, context) {
  // flutter defined function
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!,
    builder: (BuildContext context) {
      // return object of type Dialog
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
  // flutter defined function
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(
          title,
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
  // flutter defined function
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!,
    builder: (BuildContext context) {
      // return object of type Dialog
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
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
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

