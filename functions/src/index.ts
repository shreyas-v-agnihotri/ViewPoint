import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp({
    credential: admin.credential.applicationDefault()
});

const db = admin.firestore()

const deleteRequests = (snapshot: any, doc: any) => {
    snapshot.ref.delete();
    doc.ref.delete();
    console.log('done');
}

const createChat = (snapshot: any, doc: any) => {
    console.log("Creating Chat...");
    db.collection('chats').add({users: [ snapshot.get("user"), doc.get("user") ], userNames: [snapshot.get("userName"), doc.get("userName")], userPhotoURLs: [snapshot.get("userPhotoURL"), doc.get("userPhotoURL")], topic: snapshot.get("topic") })
        .catch(err => console.log(err))
        .then((ref) => 
            {
                if (ref) {
                    // db.collection(`chats/${ref.id}/messages`).add({message: 'hello'})
                    //     .catch(err => console.log(err))
                    //     .then((reference) => console.log('Added message:', reference))
                    //     .catch(() => 'obligatory catch');
                    deleteRequests(snapshot, doc);
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
            const BreakException = {};

            // Needs to be improved somehow; forEach will continue through all snapshot results
            querySnapshot.forEach((doc) => {
                if (found === false && snapshot.get("user") !== doc.get("user") && (JSON.stringify(requestAnswers) !== JSON.stringify(doc.get("answers")))) {
                    createChat(snapshot, doc);
                    found = true;
                    throw BreakException;
                }
            });
        })
        .catch(function(error) {
            console.log("Error getting documents: ", error);
        });

})
