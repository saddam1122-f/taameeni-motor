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
