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

            // Needs to be improved somehow; forEach will continue through all snapshot results
            querySnapshot.forEach((doc) => {
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
