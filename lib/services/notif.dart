import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:not_bored/pages/chat.dart';
import 'package:not_bored/pages/notifications.dart';
import 'package:not_bored/services/nbLoc.dart';
import 'package:not_bored/services/serve.dart';
import 'package:rich_alert/rich_alert.dart';

abstract class BaseNotif {
  void notif2(message, context, widget);

  void notif3(message, context, widget);

  void notif1(message, context, widget);
  void notif4(message, context, widget);
}

class Notif extends BaseNotif {
  bool _check;

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
                  if (frndid != null)
                    {
                      _check =
                          await acceptNBmsg(widget.userId, frndid.toString()),
                      if (_check)
                        {
                          Navigator.of(context).pop(),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Chat(
                                        peerId: frndid.toString(),
                                        userId: widget.userId,
                                      ))),
                        }
                    }
                  else
                    {
                      Navigator.of(context).pop(),
                      Fluttertoast.showToast(
                          msg: "Your Friend is no longer bored",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
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
          timeInSecForIosWeb: 1,
          backgroundColor: PrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void notif4(message, context, widget) async {
    var frndid = await getNBLoc();
    var text;
    if (frndid != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            content: ListTile(
              title: Text("Bored?"),
              subtitle: Text("Wanna Meet?"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Reject'),
                onPressed: () => {
                  rejectNBLoc(widget.userId, frndid.toString()),
                  Navigator.of(context).pop(),
                },
              ),
              FlatButton(
                child: Text('Accept'),
                onPressed: () async => {
                  frndid = await getNBLoc(),
                  if (frndid != null)
                    {
                      await acceptNBLoc(widget.userId, frndid.toString()),
                      await showDetails(frndid).then((value) {
                        text = value;
                      }),
                      Navigator.of(context).pop(),
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RichAlertDialog(
                              alertTitle: richTitle("Yayy Connected"),
                              alertSubtitle:
                                  richSubtitle(text[1] + ":" + text[0]),
                              alertType: RichAlertType.SUCCESS,
                            );
                          })
                    }
                  else
                    {
                      Navigator.of(context).pop(),
                      Fluttertoast.showToast(
                          msg: "Your Friend is no longer bored",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
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
          timeInSecForIosWeb: 1,
          backgroundColor: PrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void notif1(message, context, widget) async {
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: ListTile(
    //       title: Text(message['notification']['title']),
    //       subtitle: Text(message['notification']['body']),
    //     ),
    //     actions: <Widget>[
    //       FlatButton(
    //         child: Text('Ok'),
    //         onPressed: () => Navigator.of(context).pop(),
    //       ),
    //     ],
    //   ),
    // );
  }
}
