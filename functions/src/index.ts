import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
  .document("users/{userId}/req_rec/{frndId}")
  .onCreate(async (snapshot, context) => {
    const frndid = context.params.frndId;
    const userid = context.params.userId;

    const querySnapshot = await db
      .collection("users")
      .doc(userid)
      .collection("tokens")
      .get();

    const frndSnapshot = await db
      .collection("users")
      .doc(frndid)
      .get();
    const name = frndSnapshot.get("name");

    const tokens = querySnapshot.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: "Friend Request",
        body: `${name} sent you a friend request`,
        icon: "your-icon-url",
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        sound: "default",
        frndid: "${frndid}"
      }
    };

    return fcm.sendToDevice(tokens, payload);
  });

export const sendToDevice2 = functions.firestore
  .document("users/{userId}/{user}/{frndId}")
  .onCreate(async (snapshot, context) => {
    const frnd = snapshot.data;
    const frndid = context.params.frndId;
    const user = context.params.user;
    const userid = context.params.userId;

    if (frnd && user == userid) {
      const querySnapshot = await db
        .collection("users")
        .doc(userid)
        .collection("tokens")
        .get();

      const frndSnapshot = await db
        .collection("users")
        .doc(frndid)
        .get();
      const name = frndSnapshot.get("name");

      const tokens = querySnapshot.docs.map(snap => snap.id);

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: "New Friend",
          body: `${name} is now your friend!`,
          icon: "your-icon-url",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          sound: "default"
        }
      };

      return fcm.sendToDevice(tokens, payload);
    } else {
      return null;
    }
  });

export const nbMsg = functions.firestore
  .document("users/{userId}/nb_msg/{frndId}")
  .onCreate(async (snapshot, context) => {
    const userid = context.params.userId;

    const querySnapshot = await db
      .collection("users")
      .doc(userid)
      .collection("tokens")
      .get();

    const tokens = querySnapshot.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: "Bored?",
        body: `Wanna chat?`,
        icon: "your-icon-url",
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        sound: "default"
      }
    };

    return fcm.sendToDevice(tokens, payload);
  });
