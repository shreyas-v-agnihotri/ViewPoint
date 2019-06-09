import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp({
    credential: admin.credential.applicationDefault()
});

const db = admin.firestore()

const deleteChats = (snapshot: any, doc: any) => {
    snapshot.ref.delete();
    doc.ref.delete();
    console.log('done');
}

const createChat = (snapshot: any, doc: any) => {
    console.log("Creating Chat...");
    db.collection('chats_test').add({users: [ snapshot.get("user"), doc.get("user") ], topic: snapshot.get("topic") })
        .catch(err => console.log(err))
        .then((ref) => 
            {
                if (ref) {
                    db.collection(`chats_test/${ref.id}/messages`).add({message: 'hello'})
                        .catch(err => console.log(err))
                        .then((reference) => console.log('Added message:', reference))
                        .catch(() => 'obligatory catch');
                    deleteChats(snapshot, doc);
                }
            }
        )
        .catch(() => 'obligatory catch');
}

export const onNewRequest = functions.firestore.document('requests/{requestID}').onCreate((snapshot, context) => {

    const requestAnswers = snapshot.get("answers");

    db.collection('requests').where("topic", "==", snapshot.get("topic")).orderBy("created").get()
        .then((querySnapshot) => {

            let found = false;
            querySnapshot.forEach((doc) => {
                // doc.data() is never undefined for query doc snapshots
                // console.log(doc.id, " => ", doc.data());
                if (found === false && snapshot.get("user") !== doc.get("user") && (JSON.stringify(requestAnswers) !== JSON.stringify(doc.get("answers")))) {
                    createChat(snapshot, doc);
                    found = true;
                    return;
                }
            });
        })
        .catch(function(error) {
            console.log("Error getting documents: ", error);
        });

})

// let p = admin.firestore().collection(`exports/${userUID}/${theSubcollection}`)
//     .add({ message: messageString })
//     .then(ref => {
//         console.log('Added document with ID: ', ref.id)
// });



// var allChats = chatsRef.get()
//     .then(snapshot => {
//         snapshot.forEach(doc => {
//             console.log(doc.id, '=>', doc.data());

//         });
//     })
//     .catch(err => {
//         console.log('Error getting documents', err);
//     });



// exports.messageCreated = functions.firestore
//     .document('chats/{chatID}/messages/{messageID}')
//     .onCreate((snap, context) => {

//         const chatID = context.params.chatID

//         // Get an object representing the document
//         // e.g. {'name': 'Marie', 'age': 66}
//         const messageData = snap.data();

//         // access a particular field as you would any JS property
//         if (messageData != null) {
//             console.log(messageData.content);

//             snap.ref.update

//             return snap.ref.update( {content: 'asscheeks'} )
//         } else {
//             return null;
//         }

//         // perform desired operations ...

//     });