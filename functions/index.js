const functions = require('firebase-functions');

exports.myFunction = functions.firestore
.document('posts/{post}')
.onCreate((change, context)=>  {
    console.log(change.after.data());
});