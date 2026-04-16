import { onAuthStateChanged, signInWithEmailAndPassword, User } from "firebase/auth";
import { auth } from "./firebase";

export function onAuthState(cb: (user: User | null) => void) {
  return onAuthStateChanged(auth, cb);
}

export async function signInWithEmail(email: string, password: string) {
  return signInWithEmailAndPassword(auth, email, password);
}

export function isAdminEmail(email: string) {
  const raw = process.env.NEXT_PUBLIC_ADMIN_EMAILS || "";
  const allow = raw.split(",").map(s => s.trim().toLowerCase()).filter(Boolean);
  return allow.includes(email.trim().toLowerCase());
}
