// Firebase SDK imports
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import {
  getAuth,
  signInWithEmailAndPassword,
  signInWithPopup,
  GoogleAuthProvider,
  deleteUser,
} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
import {
  getFirestore,
  doc,
  deleteDoc,
  collection,
  query,
  where,
  getDocs,
  writeBatch,
} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDqkENbAdDFHwSrrDL0TpwIMHv_Pxlbzo8",
  authDomain: "yuve-es.firebaseapp.com",
  projectId: "yuve-es",
  storageBucket: "yuve-es.firebasestorage.app",
  messagingSenderId: "83359937854",
  appId: "1:83359937854:web:f9b8657f012553adeae86f",
  measurementId: "G-H6J9SS46KT",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);
const googleProvider = new GoogleAuthProvider();

// DOM Elements
const stepLogin = document.getElementById("step-login");
const stepConfirm = document.getElementById("step-confirm");
const stepProcessing = document.getElementById("step-processing");
const stepSuccess = document.getElementById("step-success");

const btnGoogle = document.getElementById("btn-google");
const emailForm = document.getElementById("email-form");
const emailInput = document.getElementById("email");
const passwordInput = document.getElementById("password");
const loginError = document.getElementById("login-error");

const userEmailSpan = document.getElementById("user-email");
const confirmTextInput = document.getElementById("confirm-text");
const btnCancel = document.getElementById("btn-cancel");
const btnDelete = document.getElementById("btn-delete");
const deleteError = document.getElementById("delete-error");

const progressStatus = document.getElementById("progress-status");

// Current user
let currentUser = null;

// Show/hide steps
function showStep(step) {
  [stepLogin, stepConfirm, stepProcessing, stepSuccess].forEach((s) =>
    s.classList.add("hidden")
  );
  step.classList.remove("hidden");
}

// Show error
function showError(element, message) {
  element.textContent = message;
  element.classList.remove("hidden");
}

function hideError(element) {
  element.classList.add("hidden");
}

// Update progress
function updateProgress(message) {
  progressStatus.textContent = message;
}

// Handle successful login
function handleLoginSuccess(user) {
  currentUser = user;
  userEmailSpan.textContent = user.email;
  showStep(stepConfirm);
}

// Google Sign In
btnGoogle.addEventListener("click", async () => {
  try {
    hideError(loginError);
    const result = await signInWithPopup(auth, googleProvider);
    handleLoginSuccess(result.user);
  } catch (error) {
    console.error("Google sign in error:", error);
    if (error.code === "auth/popup-closed-by-user") {
      showError(loginError, "Inicio de sesión cancelado.");
    } else if (error.code === "auth/account-exists-with-different-credential") {
      showError(
        loginError,
        "Ya existe una cuenta con este correo usando otro método de inicio de sesión."
      );
    } else {
      showError(
        loginError,
        "Error al iniciar sesión con Google. Por favor intenta de nuevo."
      );
    }
  }
});

// Email/Password Sign In
emailForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const email = emailInput.value.trim();
  const password = passwordInput.value;

  if (!email || !password) {
    showError(loginError, "Por favor ingresa tu correo y contraseña.");
    return;
  }

  try {
    hideError(loginError);
    const result = await signInWithEmailAndPassword(auth, email, password);
    handleLoginSuccess(result.user);
  } catch (error) {
    console.error("Email sign in error:", error);
    if (
      error.code === "auth/user-not-found" ||
      error.code === "auth/wrong-password" ||
      error.code === "auth/invalid-credential"
    ) {
      showError(loginError, "Correo o contraseña incorrectos.");
    } else if (error.code === "auth/too-many-requests") {
      showError(
        loginError,
        "Demasiados intentos fallidos. Por favor espera unos minutos."
      );
    } else {
      showError(
        loginError,
        "Error al iniciar sesión. Por favor intenta de nuevo."
      );
    }
  }
});

// Confirm text input
confirmTextInput.addEventListener("input", () => {
  const isValid = confirmTextInput.value.toUpperCase() === "ELIMINAR";
  btnDelete.disabled = !isValid;
});

// Cancel button
btnCancel.addEventListener("click", () => {
  auth.signOut();
  currentUser = null;
  confirmTextInput.value = "";
  btnDelete.disabled = true;
  hideError(deleteError);
  showStep(stepLogin);
});

// Delete account
btnDelete.addEventListener("click", async () => {
  if (!currentUser) return;

  showStep(stepProcessing);

  try {
    const uid = currentUser.uid;

    // 1. Delete user profile from 'users' collection
    updateProgress("Eliminando perfil de usuario...");
    try {
      await deleteDoc(doc(db, "users", uid));
    } catch (e) {
      console.log("No user profile found or already deleted");
    }

    // 2. Delete jobs created by this user
    updateProgress("Eliminando trabajos publicados...");
    try {
      const jobsQuery = query(
        collection(db, "jobs"),
        where("clientId", "==", uid)
      );
      const jobsSnapshot = await getDocs(jobsQuery);

      if (!jobsSnapshot.empty) {
        const batch = writeBatch(db);
        jobsSnapshot.forEach((docSnap) => {
          batch.delete(docSnap.ref);
        });
        await batch.commit();
      }
    } catch (e) {
      console.log("Error deleting jobs:", e);
    }

    // 3. Delete conversations where user is client
    updateProgress("Eliminando conversaciones...");
    try {
      const convsQuery = query(
        collection(db, "conversations"),
        where("clientId", "==", uid)
      );
      const convsSnapshot = await getDocs(convsQuery);

      if (!convsSnapshot.empty) {
        const batch = writeBatch(db);
        convsSnapshot.forEach((docSnap) => {
          batch.delete(docSnap.ref);
        });
        await batch.commit();
      }
    } catch (e) {
      console.log("Error deleting conversations:", e);
    }

    // 4. Delete notifications
    updateProgress("Eliminando notificaciones...");
    try {
      const notifsQuery = query(
        collection(db, "notifications"),
        where("userId", "==", uid)
      );
      const notifsSnapshot = await getDocs(notifsQuery);

      if (!notifsSnapshot.empty) {
        const batch = writeBatch(db);
        notifsSnapshot.forEach((docSnap) => {
          batch.delete(docSnap.ref);
        });
        await batch.commit();
      }
    } catch (e) {
      console.log("Error deleting notifications:", e);
    }

    // 5. Finally, delete the Firebase Auth account
    updateProgress("Eliminando cuenta de autenticación...");
    await deleteUser(currentUser);

    // Success!
    showStep(stepSuccess);
  } catch (error) {
    console.error("Delete account error:", error);
    showStep(stepConfirm);

    if (error.code === "auth/requires-recent-login") {
      showError(
        deleteError,
        "Por seguridad, necesitas volver a iniciar sesión antes de eliminar tu cuenta. Por favor cierra sesión e inicia sesión de nuevo."
      );
    } else {
      showError(
        deleteError,
        "Error al eliminar la cuenta. Por favor intenta de nuevo o contacta a soporte."
      );
    }
  }
});
