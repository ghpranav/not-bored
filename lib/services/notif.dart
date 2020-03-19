import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:not_bored/services/serve.dart';

import 'package:not_bored/pages/chat.dart';

import 'package:not_bored/pages/notifications.dart';

abstract class BaseNotif {
  void notif2(message, context, widget);
  void notif3(message, context, widget);
  void notif1(message, context, widget);
}

class Notif extends BaseNotif {
  void notif2(message, context, widget) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NotifPage(
                  auth: widget.auth,
                  userId: widget.userId,
                  request: widget.request,
                )));
  }

  void notif3(message, context, widget) async {
    var frndid = await getNBmsg();
    if (frndid != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            content: ListTile(
              title: Text("Bored?"),
              subtitle: Text("Wanna Chat?"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Reject'),
                onPressed: () => {
                  rejectNBmsg(widget.userId, frndid.toString()),
                  Navigator.of(context).pop(),
                },
              ),
              FlatButton(
                child: Text('Accept'),
                onPressed: () async => {
                  frndid = await getNBmsg(),
                  Navigator.of(context).pop(),
                  if (frndid != null)
                    {
                      acceptNBmsg(widget.userId, frndid.toString()),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Chat(
                                    peerId: frndid.toString(),
                                    userId: widget.userId,
                                  ))),
                    }
                  else
                    {
                      Fluttertoast.showToast(
                          msg: "Your Friend is no longer bored",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: PrimaryColor,
                          textColor: Colors.white,
                          fontSize: 16.0),
                    }
                },
              ),
            ],
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Your Friend is no longer bored",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: PrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void notif1(message, context, widget) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message['notification']['title']),
          subtitle: Text(message['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
