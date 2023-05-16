// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.19.1/firebase-app.js";
import { doc, getDoc, getFirestore, collection, getDocs, onSnapshot } from "https://www.gstatic.com/firebasejs/9.19.1/firebase-firestore.js";

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyCWY14Mna0pyz15Jcv2jLSq5eVxc2XCHfU",
    authDomain: "quizrd-prod-382117.firebaseapp.com",
    projectId: "quizrd-prod-382117",
    storageBucket: "quizrd-prod-382117.appspot.com",
    messagingSenderId: "338739261213",
    appId: "1:338739261213:web:49d62e4552ffaabcbe7bf4"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const unsub = onSnapshot(doc(db, "admin", "quizManagement"), (doc) => {
    showNextQuestion(doc.data().currentQuestion);
});