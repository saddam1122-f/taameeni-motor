#!/usr/bin/env bash
set -euo pipefail

mkdir -p src/app/quote
mkdir -p src/app/request/[id]
mkdir -p src/app/contact
mkdir -p src/app/admin/login
mkdir -p src/app/admin
mkdir -p src/components
mkdir -p src/lib

cat > package.json <<'EOF'
{
  "name": "taameeni-motor",
  "private": true,
  "version": "1.0.0",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "firebase": "^10.12.5",
    "next": "^14.2.12",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@types/node": "^20.14.15",
    "@types/react": "^18.3.4",
    "@types/react-dom": "^18.3.0",
    "autoprefixer": "^10.4.20",
    "postcss": "^8.4.41",
    "tailwindcss": "^3.4.10",
    "typescript": "^5.5.4"
  }
}
EOF

cat > next.config.js <<'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = { reactStrictMode: true };
module.exports = nextConfig;
EOF

cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "es2022"],
    "strict": true,
    "noEmit": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "jsx": "preserve",
    "skipLibCheck": true,
    "baseUrl": ".",
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["next-env.d.ts", "src/**/*"],
  "exclude": ["node_modules"]
}
EOF

cat > next-env.d.ts <<'EOF'
/// <reference types="next" />
/// <reference types="next/image-types/global" />
EOF

cat > tailwind.config.js <<'EOF'
module.exports = {
  content: ["./src/**/*.{ts,tsx}"],
  theme: { extend: {} },
  plugins: []
};
EOF

cat > postcss.config.js <<'EOF'
module.exports = { plugins: { tailwindcss: {}, autoprefixer: {} } };
EOF

cat > .gitignore <<'EOF'
node_modules/
.next/
.env
.env.local
EOF

cat > .env.example <<'EOF'
NEXT_PUBLIC_FIREBASE_API_KEY="REPLACE_ME"
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN="REPLACE_ME"
NEXT_PUBLIC_FIREBASE_DATABASE_URL="REPLACE_ME"
NEXT_PUBLIC_FIREBASE_PROJECT_ID="REPLACE_ME"
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET="REPLACE_ME"
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID="REPLACE_ME"
NEXT_PUBLIC_FIREBASE_APP_ID="REPLACE_ME"
NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID="REPLACE_ME"
NEXT_PUBLIC_ADMIN_EMAILS="saqqqr676@gmail.com"
EOF

cat > README.md <<'EOF'
# Taameeni Motor

## Setup
npm install
cp .env.example .env.local
npm run dev
EOF

cat > src/app/globals.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

cat > src/app/layout.tsx <<'EOF'
import "./globals.css";

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-gray-50 text-gray-900">{children}</body>
    </html>
  );
}
EOF

cat > src/app/page.tsx <<'EOF'
"use client";

import { useEffect } from "react";
import { addVisitor } from "@/lib/firestore";

export default function HomePage() {
  useEffect(() => {
    addVisitor({ path: "/", createdAt: new Date().toISOString() }).catch(() => {});
  }, []);

  return (
    <main className="mx-auto max-w-4xl p-6">
      <h1 className="text-3xl font-bold">Taameeni Motor</h1>
      <p className="mt-2 text-gray-600">
        Home • <a className="text-blue-700 underline" href="/quote">Quote</a> •{" "}
        <a className="text-blue-700 underline" href="/contact">Contact</a> •{" "}
        <a className="text-blue-700 underline" href="/admin/login">Admin</a>
      </p>
    </main>
  );
}
EOF

cat > src/app/quote/page.tsx <<'EOF'
"use client";

import { useState } from "react";
import { createRequest } from "@/lib/firestore";

export default function QuotePage() {
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [vehicleMake, setVehicleMake] = useState("");
  const [vehicleModel, setVehicleModel] = useState("");
  const [vehicleYear, setVehicleYear] = useState("");
  const [id, setId] = useState<string | null>(null);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    const requestId = await createRequest({
      fullName,
      email,
      vehicleMake,
      vehicleModel,
      vehicleYear,
      status: "new",
      createdAt: new Date().toISOString()
    });
    setId(requestId);
  }

  return (
    <main className="mx-auto max-w-2xl p-6">
      <h1 className="text-2xl font-bold">Quote Form</h1>

      <form className="mt-6 grid gap-3" onSubmit={submit}>
        <input className="border p-2 rounded" placeholder="Full name" value={fullName} onChange={(e) => setFullName(e.target.value)} />
        <input className="border p-2 rounded" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} />
        <input className="border p-2 rounded" placeholder="Vehicle Make" value={vehicleMake} onChange={(e) => setVehicleMake(e.target.value)} />
        <input className="border p-2 rounded" placeholder="Vehicle Model" value={vehicleModel} onChange={(e) => setVehicleModel(e.target.value)} />
        <input className="border p-2 rounded" placeholder="Vehicle Year" value={vehicleYear} onChange={(e) => setVehicleYear(e.target.value)} />
        <button className="bg-black text-white rounded p-2">Submit</button>
      </form>

      {id && (
        <p className="mt-4">
          Created request: <a className="text-blue-700 underline" href={`/request/${id}`}>{id}</a>
        </p>
      )}
    </main>
  );
}
EOF

cat > src/app/request/[id]/page.tsx <<'EOF'
"use client";

import { useEffect, useState } from "react";
import { getRequestById } from "@/lib/firestore";

export default function RequestDetails({ params }: { params: { id: string } }) {
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    getRequestById(params.id)
      .then(setData)
      .catch(() => setData({ error: "Not found / no access (non-admin cannot read)" }));
  }, [params.id]);

  return (
    <main className="mx-auto max-w-2xl p-6">
      <h1 className="text-2xl font-bold">Request Details</h1>
      <pre className="mt-4 bg-white border rounded p-4 text-xs whitespace-pre-wrap">
        {JSON.stringify(data, null, 2)}
      </pre>
    </main>
  );
}
EOF

cat > src/app/contact/page.tsx <<'EOF'
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
EOF

cat > src/app/admin/login/page.tsx <<'EOF'
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
EOF

cat > src/app/admin/page.tsx <<'EOF'
"use client";

import AdminGuard from "@/components/AdminGuard";

export default function AdminPage() {
  return (
    <AdminGuard>
      <main className="mx-auto max-w-3xl p-6">
        <h1 className="text-2xl font-bold">Admin Dashboard</h1>
        <p className="mt-2 text-gray-600">You are signed in and allowed.</p>
      </main>
    </AdminGuard>
  );
}
EOF

cat > src/components/AdminGuard.tsx <<'EOF'
"use client";

import { useEffect, useState } from "react";
import { onAuthState, isAdminEmail } from "@/lib/auth";

export default function AdminGuard({ children }: { children: React.ReactNode }) {
  const [ok, setOk] = useState(false);

  useEffect(() => {
    const unsub = onAuthState((user) => {
      if (!user) return (window.location.href = "/admin/login");
      if (!isAdminEmail(user.email || "")) return (window.location.href = "/admin/login");
      setOk(true);
    });
    return () => unsub();
  }, []);

  if (!ok) return <div className="p-6">Checking access...</div>;
  return <>{children}</>;
}
EOF

cat > src/lib/firebase.ts <<'EOF'
import { initializeApp, getApps } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY!,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN!,
  databaseURL: process.env.NEXT_PUBLIC_FIREBASE_DATABASE_URL!,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID!,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET!,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID!,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID!,
  measurementId: process.env.NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID!
};

export const app = getApps().length ? getApps()[0] : initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
EOF

cat > src/lib/auth.ts <<'EOF'
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
EOF

cat > src/lib/firestore.ts <<'EOF'
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
EOF

echo "✅ Project generated in: $(pwd)"
