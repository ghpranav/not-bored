import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
    .document('users/{userId}')
    .onCreate(async snapshot => {


        const docu = snapshot.data();

        const querySnapshot = await db
            .collection('users')
            .doc(docu.req_rec)
            .collection('tokens')
            .get();

        const tokens = querySnapshot.docs.map(snap => snap.id);

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'Friend Request',
                body: `{docu.name} sent you a friend request}`,
                icon: 'your-icon-url',
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
		sound : 'default'
            }
        };

        return fcm.sendToDevice(tokens, payload);
    });