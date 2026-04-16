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
