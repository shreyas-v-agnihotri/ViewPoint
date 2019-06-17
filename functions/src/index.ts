import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp({
    credential: admin.credential.applicationDefault()
});

const db = admin.firestore()

const sendNewDebateNotifications = (snapshotData: any, docData: any) => {
    
    const topic = snapshotData["topic"];
    console.log("sending notifications for: ", topic);

    const snapshotUser = snapshotData["user"];
    const snapshotUserName = snapshotData["userName"];

    const docUser = docData["user"];
    const docUserName = docData["userName"];

    console.log("sending first user notification to: ", snapshotUserName);

    db.doc(`notificationTokens/${snapshotUser}`).get().then((tokenSnapshot) => {
        const token = tokenSnapshot.get("token");

        const payload = {
            notification: {
                title: `New Debate!`,
                body: `You matched with ${docUserName} in ${topic}`,
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

    console.log("sending second user notification");

    db.doc(`notificationTokens/${docUser}`).get().then((tokenSnapshot) => {
        const token = tokenSnapshot.get("token");

        const payload = {
            notification: {
                title: `New Debate!`,
                body: `You matched with ${snapshotUserName} in ${topic}`,
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

const deleteRequests = (snapshot: any, doc: any) => {
    snapshot.ref.delete();
    doc.ref.delete();
    console.log('done deleting');
}

const createChat = (snapshotData: any, docData: any) => {

    console.log("Creating Chat...");

    const sender = snapshotData["user"]
    const otherUser = docData["user"]

    db.collection('chats').where("topic", "==", snapshotData["topic"]).where("users", "array-contains", sender).get()
        .then((chatsSnapshot) => {

            let chatsWithOtherUser = 0;
            chatsSnapshot.forEach((chat) => {

                const users = chat.get("users");
                if(users.includes(otherUser)) {
                    chatsWithOtherUser += 1;
                }
            });

            if (chatsWithOtherUser === 0) {
                db.collection('chats').add(
                    {
                        // users: [ snapshot.get("user"), doc.get("user") ],
                        // questions: snapshot.get("questions"),    // Only store questions for one person; they should be the same
                        // user1Answers: snapshot.get("answers"),
                        // user2Answers: doc.get("answers"), 
                        // userNames: [snapshot.get("userName"), doc.get("userName")], 
                        // userPhotoURLs: [snapshot.get("userPhotoURL"), doc.get("userPhotoURL")], 
                        // topic: snapshot.get("topic"),
            
                        users: [snapshotData["user"], docData["user"]],
                        questions: snapshotData["questions"],    // Only store questions for one person; they should be the same
                        user1Answers: snapshotData["answers"],
                        user2Answers: docData["answers"], 
                        userNames: [snapshotData["userName"], docData["userName"]], 
                        userPhotoURLs: [snapshotData["userPhotoURL"], docData["userPhotoURL"]], 
                        topic: snapshotData["topic"],
            
                        messagePreview: "New debate!",
                        timestamp: admin.firestore.FieldValue.serverTimestamp()
                    })
                    .catch(err => console.log(err))
                    .then(() => {
                        // sendNewDebateNotifications(snapshot.data(), doc.data());
                        // deleteRequests(snapshot, doc);
                        console.log("\nFinished creating chat\n");
                    })
                    .catch(() => 'obligatory catch');
            }
        })
        .catch((error) => {
            console.log("Error getting chats: ", error);
        });


    // sendNewDebateNotifications(snapshot.data(), doc.data());
    // deleteRequests(snapshot, doc);
}

export const processRequest = functions.firestore.document('requests/{requestID}').onCreate((snapshot, context) => {

    const snapshotData = snapshot.data()!;

    // const requestAnswers = snapshot.get("answers");
    // const topic = snapshot.get("topic");
    // const sender = snapshot.get("user");

    const requestAnswers = snapshotData["answers"];
    const topic = snapshotData["topic"];
    const sender = snapshotData["user"];


    db.collection('requests').where("topic", "==", topic).orderBy("created").get()
        .then((querySnapshot) => {

            let found = false;
            const BreakException = "Sike! It worked";

            // Needs to be improved somehow; forEach will continue through all snapshot results
            querySnapshot.forEach((doc) => {

                const docData = doc.data();

                // const otherUser = doc.get("user");
                const otherUser = docData["user"];
                const docAnswers = docData["answers"]

                db.collection('chats').where("topic", "==", topic).where("users", "array-contains", sender).get()
                    .then((chatsSnapshot) => {

                        let chatsWithOtherUser = 0;
                        chatsSnapshot.forEach((chat) => {

                            const users = chat.get("users");
                            if(users.includes(otherUser)) {
                                chatsWithOtherUser += 1;
                            }
                        });

                        if (chatsWithOtherUser === 0) {
                            if (found === false && sender !== otherUser && (JSON.stringify(requestAnswers) !== JSON.stringify(docAnswers))) {
                                deleteRequests(snapshot, doc);
                                createChat(snapshotData, docData);
                                sendNewDebateNotifications(snapshotData, docData);
                                found = true;
                                throw BreakException;
                            }
                        }
                    })
                    .catch((error) => {
                        console.log("Error getting chats: ", error);
                    });

            });
        })
        .catch((error) => {
            console.log("Error getting documents: ", error);
        });

})

export const sendMessageNotification = functions.firestore.document('chats/{chatID}/messages/{messageID}').onCreate((snapshot, context) => {

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
