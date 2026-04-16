import { onAuthStateChanged, signInWithEmailAndPassword, User } from "firebase/auth";
import { getAuthClient } from "./firebase";

export function onAuthState(cb: (user: User | null) => void) {
  return onAuthStateChanged(getAuthClient(), cb);
}

export async function signInWithEmail(email: string, password: string) {
  return signInWithEmailAndPassword(getAuthClient(), email, password);
}

export function isAdminEmail(email: string) {
  const raw = process.env.NEXT_PUBLIC_ADMIN_EMAILS || "";
  const allow = raw.split(",").map(s => s.trim().toLowerCase()).filter(Boolean);
  return allow.includes(email.trim().toLowerCase());
}
