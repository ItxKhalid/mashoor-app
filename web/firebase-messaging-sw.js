importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

firebase.initializeApp({
 apiKey: "AIzaSyCUflvHoddQtRBfilqZBsC2WCq0DJfD4JI",
   authDomain: "salva-fast-food.firebaseapp.com",
   databaseURL: "https://salva-fast-food-default-rtdb.firebaseio.com",
   projectId: "salva-fast-food",
   storageBucket: "salva-fast-food.appspot.com",
   messagingSenderId: "947298372691",
   appId: "1:947298372691:web:2991d74f0b7b3e70d8caa6",
  // measurementId: "G-ES6NQL2ZZD"
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});