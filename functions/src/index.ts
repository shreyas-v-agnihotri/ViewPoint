import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp({
    credential: admin.credential.applicationDefault()
});

const db = admin.firestore()

const deleteRequests = (snapshot: any, doc: any) => {
    snapshot.ref.delete();
    doc.ref.delete();
    console.log('done deleting');
}

const createChat = (snapshot: any, doc: any) => {
    console.log("Creating Chat...");
    db.collection('chats').add(
        {
            users: [ snapshot.get("user"), doc.get("user") ],
            questions: snapshot.get("questions"),    // Only store questions for one person; they should be the same
            user1Answers: snapshot.get("answers"),
            user2Answers: doc.get("answers"), 
            userNames: [snapshot.get("userName"), doc.get("userName")], 
            userPhotoURLs: [snapshot.get("userPhotoURL"), doc.get("userPhotoURL")], 
            topic: snapshot.get("topic"),
            messagePreview: "New debate!",
            timestamp: admin.firestore.FieldValue.serverTimestamp()
        })
        .catch(err => console.log(err))
        .then(() => deleteRequests(snapshot, doc))
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
        .catch((error) => {
            console.log("Error getting documents: ", error);
        });

})

export const sendNotification = functions.firestore.document('chats/{chatID}/messages/{messageID}').onCreate((snapshot, context) => {

    const chatID = context.params.chatID;
    const senderID = snapshot.get("senderID");
    const content = snapshot.get("content");
    
    db.doc(`chats/${chatID}`).get().then((chatSnapshot) => {
        const users = chatSnapshot.get("users");
        const userNames = chatSnapshot.get("userNames");

        const topic = chatSnapshot.get("topic");

        for (let index = 0; index < users.length; index++) {
            if (users[index] !== senderID) {

                const senderName = userNames[users.length-1-index];

                db.doc(`notificationTokens/${users[index]}`).get().then((tokenSnapshot) => {
                    const token = tokenSnapshot.get("token");

                    const payload = {
                        notification: {
                            title: `${senderName} (${topic})`,
                            body: `${content}`,
                            badge: '1'
                        }
                    };

                    admin.messaging().sendToDevice(token, payload).then((response) => {
                        console.log("Successfully sent notification: ", response);
                    })
                    .catch(function(error) {
                        console.log("Error sending message: ", error);
                    });
                })
                .catch((error) => {
                    console.log("Error getting notification token: ", error);
                });
            }
        }
    })
    .catch((error) => {
        console.log("Error getting chat: ", error);
    });

});
