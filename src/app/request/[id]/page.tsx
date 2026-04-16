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
