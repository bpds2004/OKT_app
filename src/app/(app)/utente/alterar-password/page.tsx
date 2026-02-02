"use client";

import { useState } from "react";
import { Shield } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";
import { supabase } from "@/lib/supabase/client";

export default function AlterarPasswordPage() {
  const { t } = useLanguage();
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [message, setMessage] = useState<{ type: "error" | "success"; text: string } | null>(
    null,
  );

  const requirements = [
    t("password.requirement1"),
    t("password.requirement2"),
    t("password.requirement3"),
    t("password.requirement4"),
    t("password.requirement5"),
  ];

  const handleSave = async () => {
    setMessage(null);
    if (newPassword !== confirmPassword) {
      setMessage({ type: "error", text: t("password.mismatch") });
      return;
    }
    const { data: userInfo } = await supabase.auth.getUser();
    if (!userInfo.user?.email) {
      setMessage({ type: "error", text: t("password.invalidCurrent") });
      return;
    }
    const { error: signInError } = await supabase.auth.signInWithPassword({
      email: userInfo.user.email,
      password: currentPassword,
    });
    if (signInError) {
      setMessage({ type: "error", text: t("password.invalidCurrent") });
      return;
    }
    const { error: updateError } = await supabase.auth.updateUser({
      password: newPassword,
    });
    if (updateError) {
      setMessage({ type: "error", text: t("password.invalidCurrent") });
      return;
    }
    setCurrentPassword("");
    setNewPassword("");
    setConfirmPassword("");
    setMessage({ type: "success", text: t("password.updateSuccess") });
  };

  return (
    <PageTransition>
      <MobileShell
        title={t("password.title")}
        icon={<Shield className="h-5 w-5" />}
        backHref="/utente/definicoes"
      >
        <div className="space-y-4">
          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("password.current")}
            </label>
            <Input
              placeholder={t("password.currentPlaceholder")}
              className="mt-2"
              type="password"
              value={currentPassword}
              onChange={(event) => setCurrentPassword(event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("password.new")}
            </label>
            <Input
              placeholder={t("password.newPlaceholder")}
              className="mt-2"
              type="password"
              value={newPassword}
              onChange={(event) => setNewPassword(event.target.value)}
            />
          </div>
          <Card className="bg-brand-50 px-4 py-4">
            <p className="text-xs font-semibold text-brand-500">
              {t("password.requirementsTitle")}
            </p>
            <ul className="mt-3 space-y-2 text-xs text-brand-500">
              {requirements.map((item) => (
                <li key={item} className="flex items-center gap-2">
                  <span className="flex h-4 w-4 items-center justify-center rounded-full border border-brand-200 text-[10px]">
                    ✕
                  </span>
                  {item}
                </li>
              ))}
            </ul>
          </Card>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("password.confirm")}
            </label>
            <Input
              placeholder={t("password.confirmPlaceholder")}
              className="mt-2"
              type="password"
              value={confirmPassword}
              onChange={(event) => setConfirmPassword(event.target.value)}
            />
          </div>
          {message ? (
            <p
              className={`text-xs ${
                message.type === "error" ? "text-red-500" : "text-emerald-600"
              }`}
            >
              {message.text}
            </p>
          ) : null}
          <div className="space-y-3 pt-4">
            <Button className="w-full" onClick={handleSave}>
              {t("common.save")}
            </Button>
            <Button
              className="w-full"
              variant="outline"
              onClick={() => window.history.back()}
            >
              {t("common.cancel")}
            </Button>
          </div>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
