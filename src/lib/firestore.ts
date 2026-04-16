import { addDoc, collection, doc, getDoc, serverTimestamp } from "firebase/firestore";
import { getDbClient } from "./firebase";

export async function addVisitor(data: any) {
  await addDoc(collection(getDbClient(), "visitors"), { ...data, ts: serverTimestamp() });
}

export async function createRequest(data: any) {
  const ref = await addDoc(collection(getDbClient(), "requests"), { ...data, ts: serverTimestamp() });
  return ref.id;
}

export async function getRequestById(id: string) {
  const snap = await getDoc(doc(getDbClient(), "requests", id));
  if (!snap.exists()) throw new Error("Request not found");
  return { id: snap.id, ...snap.data() };
}

export async function createMessage(data: any) {
  const ref = await addDoc(collection(getDbClient(), "messages"), { ...data, ts: serverTimestamp() });
  return ref.id;
}
