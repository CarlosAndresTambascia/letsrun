const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.newPostNotification = functions.firestore
    .document('posts/{post}')
    .onCreate((snapshot, context) => {
        return admin.messaging().sendToTopic('posts', {
            notification: {
                title: snapshot.data().fullName + " hizo una publicacion!",
                body: snapshot.data().description,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        });
    });