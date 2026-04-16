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
