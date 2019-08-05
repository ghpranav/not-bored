import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
    .document('users/{userId}')
    .onCreate(async snapshot => {


        const docu = snapshot.data();
        if(docu){
            const querySnapshot = await db
            .collection('users')
            .doc('userid')
            .collection('req_rec:'+docu.userid)
            .doc(docu.userid)
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
        }
        else 
        return null

       
    });