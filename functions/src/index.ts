import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
    .document('users/{userId}/req_rec/{frndId}')
    .onCreate(async (snapshot, context) => {

        const frnd = snapshot.data;
        const frndid = context.params.frndId;
        const userid = context.params.userId;

        if (frnd) {
            const querySnapshot = await db
                .collection('users')
                .doc(userid)
                .collection('tokens')
                .get();

            const frndSnapshot = await db
                .collection('users')
                .doc(frndid)
                .get();
            const name = frndSnapshot.get('name');

            const tokens = querySnapshot.docs.map(snap => snap.id);

            const payload: admin.messaging.MessagingPayload = {
                notification: {
                    title: 'Friend Request',
                    body: `${name} sent you a friend request`,
                    icon: 'your-icon-url',
                    click_action: 'FLUTTER_NOTIFICATION_CLICK',
                    sound: 'default'
                }
            };

            return fcm.sendToDevice(tokens, payload);
        }
        else {
            return null
        }
    },
    );