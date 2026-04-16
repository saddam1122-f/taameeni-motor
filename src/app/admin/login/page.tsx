"use client";

import { useState } from "react";
import { signInWithEmail } from "@/lib/auth";

export default function AdminLogin() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    await signInWithEmail(email, password);
    window.location.href = "/admin";
  }

  return (
    <main className="mx-auto max-w-md p-6">
      <h1 className="text-2xl font-bold">Admin Login</h1>
      <form className="mt-6 grid gap-3" onSubmit={submit}>
        <input className="border p-2 rounded" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} />
        <input className="border p-2 rounded" placeholder="Password" type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
        <button className="bg-black text-white rounded p-2">Sign in</button>
      </form>
    </main>
  );
}
