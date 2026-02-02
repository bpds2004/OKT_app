"use client";

import { FormEvent, useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function RegistoPage() {
  const { t } = useLanguage();
  const [role, setRole] = useState<"utente" | "unidade">("utente");
  const [message, setMessage] = useState<{ type: "error" | "success"; text: string } | null>(
    null,
  );

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setMessage(null);
    const formData = new FormData(event.currentTarget);
    const email = String(formData.get("email") ?? "");
    const password = String(formData.get("password") ?? "");
    const confirmPassword = String(formData.get("confirmPassword") ?? "");

    if (password !== confirmPassword) {
      setMessage({ type: "error", text: t("register.passwordMismatch") });
      return;
    }

    const payload = {
      role: role === "utente" ? "UTENTE" : "UNIDADE_SAUDE",
      name: String(formData.get("fullName") ?? ""),
      email,
      password,
      phone: String(formData.get("phone") ?? ""),
      nif: String(formData.get("nif") ?? ""),
      birthDate: String(formData.get("birthDate") ?? ""),
      address: String(formData.get("address") ?? ""),
      healthNumber: String(formData.get("healthNumber") ?? ""),
      healthUnitName: String(formData.get("fullName") ?? ""),
      healthUnitAddress: String(formData.get("unitAddress") ?? ""),
      healthUnitCode: String(formData.get("unitCode") ?? ""),
    };

    const response = await fetch("/api/auth/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const data = (await response.json()) as { error?: string };
      if (data.error === "EMAIL_EXISTS") {
        setMessage({ type: "error", text: t("register.emailExists") });
        return;
      }
      setMessage({ type: "error", text: t("register.error") });
      return;
    }

    event.currentTarget.reset();
    setMessage({ type: "success", text: t("register.success") });
  };

  return (
    <PageTransition>
      <div className="min-h-screen bg-white px-6 py-6">
        <div className="text-center">
          <div className="text-sm font-semibold text-brand-700">OKT</div>
          <div className="text-xs text-brand-400">{t("common.appTagline")}</div>
        </div>
        <h1 className="mt-6 text-center text-lg font-semibold text-brand-800">
          {t("register.title")}
        </h1>
        <p className="mt-2 text-center text-xs text-brand-400">
          {t("register.subtitle")}
        </p>
        <form className="mt-6 space-y-4" onSubmit={handleSubmit}>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("register.fullName")}
            </label>
            <Input
              name="fullName"
              placeholder={
                role === "utente"
                  ? t("register.fullNamePlaceholderUser")
                  : t("register.fullNamePlaceholderUnit")
              }
              className="mt-2"
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("register.email")}
            </label>
            <Input
              name="email"
              placeholder={
                role === "utente"
                  ? t("register.emailPlaceholderUser")
                  : t("register.emailPlaceholderUnit")
              }
              className="mt-2"
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("register.phone")}
            </label>
            <Input
              name="phone"
              placeholder={t("register.phonePlaceholder")}
              className="mt-2"
            />
          </div>
          <div className="flex items-center gap-4 text-sm text-brand-700">
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={role === "utente"}
                onChange={() => setRole("utente")}
                className="h-4 w-4 rounded border-brand-200 text-brand-700"
              />
              {t("register.roleUser")}
            </label>
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={role === "unidade"}
                onChange={() => setRole("unidade")}
                className="h-4 w-4 rounded border-brand-200 text-brand-700"
              />
              {t("register.roleUnit")}
            </label>
          </div>

          {role === "utente" ? (
            <>
              <div>
                <label className="text-sm font-semibold text-brand-700">
                  {t("register.healthNumber")}
                </label>
                <Input
                  name="healthNumber"
                  placeholder={t("register.healthNumberPlaceholder")}
                  className="mt-2"
                />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">
                  {t("register.nif")}
                </label>
                <Input name="nif" placeholder={t("register.nifPlaceholder")} className="mt-2" />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">
                  {t("register.birthDate")}
                </label>
                <Input name="birthDate" placeholder="" className="mt-2" />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">
                  {t("register.medicalHistory")}
                </label>
                <textarea
                  name="medicalHistory"
                  className="mt-2 h-24 w-full rounded-lg border border-brand-100 px-4 py-3 text-sm text-brand-700 focus-visible:border-brand-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-200"
                  placeholder={t("register.medicalHistoryPlaceholder")}
                />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">
                  {t("register.familyDoctor")}
                </label>
                <Input
                  name="familyDoctor"
                  placeholder={t("register.familyDoctorPlaceholder")}
                  className="mt-2"
                />
              </div>
            </>
          ) : (
            <>
              <div>
                <label className="text-sm font-semibold text-brand-700">
                  {t("register.unitAddress")}
                </label>
                <Input
                  name="unitAddress"
                  placeholder={t("register.unitAddressPlaceholder")}
                  className="mt-2"
                />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">
                  {t("register.unitCode")}
                </label>
                <Input
                  name="unitCode"
                  placeholder={t("register.unitCodePlaceholder")}
                  className="mt-2"
                />
              </div>
            </>
          )}

          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("register.password")}
            </label>
            <Input
              name="password"
              type="password"
              placeholder={t("register.passwordPlaceholder")}
              className="mt-2"
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("register.confirmPassword")}
            </label>
            <Input
              name="confirmPassword"
              type="password"
              placeholder={t("register.confirmPasswordPlaceholder")}
              className="mt-2"
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
          <Button className="w-full" type="submit">
            {t("register.submit")}
          </Button>
          <Link href="/login" className="block w-full text-center text-sm font-semibold text-brand-600">
            {t("register.hasAccount")}
          </Link>
        </form>
      </div>
    </PageTransition>
  );
}
