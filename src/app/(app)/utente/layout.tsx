"use client";

import { ReactNode, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase/client";

export default function UtenteLayout({ children }: { children: ReactNode }) {
  const router = useRouter();
  const [checking, setChecking] = useState(true);

  useEffect(() => {
    const checkSession = async () => {
      const { data: userInfo } = await supabase.auth.getUser();
      if (!userInfo.user) {
        router.replace("/login");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", userInfo.user.id)
        .single();
      if (!profile || profile.role !== "UTENTE") {
        router.replace("/login");
        return;
      }
      setChecking(false);
    };
    checkSession();
  }, [router]);

  if (checking) {
    return <div className="min-h-screen bg-white" />;
  }

  return children;
}
