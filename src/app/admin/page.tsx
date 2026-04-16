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
