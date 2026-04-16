"use client";

import { useState } from "react";
import { createMessage } from "@/lib/firestore";

export default function ContactPage() {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [subject, setSubject] = useState("");
  const [message, setMessage] = useState("");
  const [id, setId] = useState<string | null>(null);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    const msgId = await createMessage({
      name,
      email,
      subject,
      message,
      createdAt: new Date().toISOString()
    });
    setId(msgId);
  }

  return (
    <main className="mx-auto max-w-2xl p-6">
      <h1 className="text-2xl font-bold">Contact</h1>

      <form className="mt-6 grid gap-3" onSubmit={submit}>
        <input className="border p-2 rounded" placeholder="Name" value={name} onChange={(e) => setName(e.target.value)} />
        <input className="border p-2 rounded" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} />
        <input className="border p-2 rounded" placeholder="Subject" value={subject} onChange={(e) => setSubject(e.target.value)} />
        <textarea className="border p-2 rounded" placeholder="Message" value={message} onChange={(e) => setMessage(e.target.value)} />
        <button className="bg-black text-white rounded p-2">Send</button>
      </form>

      {id && <p className="mt-4">Message sent: {id}</p>}
    </main>
  );
}
