import * as functions from 'firebase-functions';
import admin from 'firebase-admin';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const onNewMessage = functions.firestore.document('chats/{chatID}/messages/{messageID}').onCreate((snapshot, context) => {

//     // Not necessary, but helps with debugging
//     const chatID = context.params.chatID
//     const messageID = context.params.messageID
//     console.log(`New message ${messageID} in chat ${chatID}`)

//     const messageData = snapshot.data()
//     if (messageData != null) {
//         const newContent = addPizzazz(messageData.content)
//         return snapshot.ref.update({ content: newContent })
//     } else {
//         return null;
//     }

// })

admin.initializeApp({
    credential: admin.credential.applicationDefault()
});

var db = admin.firestore();

var chatsRef = db.collection('chats');
var allChats = chatsRef.get()
    .then(snapshot => {
        snapshot.forEach(doc => {
            console.log(doc.id, '=>', doc.data());

        });
    })
    .catch(err => {
        console.log('Error getting documents', err);
    });



exports.messageCreated = functions.firestore
    .document('chats/{chatID}/messages/{messageID}')
    .onCreate((snap, context) => {

        const chatID = context.params.chatID

        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const messageData = snap.data();

        // access a particular field as you would any JS property
        if (messageData != null) {
            console.log(messageData.content);

            snap.ref.update

            return snap.ref.update( {content: 'asscheeks'} )
        } else {
            return null;
        }

        // perform desired operations ...

    });