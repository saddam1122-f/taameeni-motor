import { addDoc, collection, doc, getDoc, serverTimestamp } from "firebase/firestore";
import { db } from "./firebase";

export async function addVisitor(data: any) {
  await addDoc(collection(db, "visitors"), { ...data, ts: serverTimestamp() });
}

export async function createRequest(data: any) {
  const ref = await addDoc(collection(db, "requests"), { ...data, ts: serverTimestamp() });
  return ref.id;
}

export async function getRequestById(id: string) {
  const snap = await getDoc(doc(db, "requests", id));
  if (!snap.exists()) throw new Error("Request not found");
  return { id: snap.id, ...snap.data() };
}

export async function createMessage(data: any) {
  const ref = await addDoc(collection(db, "messages"), { ...data, ts: serverTimestamp() });
  return ref.id;
}
