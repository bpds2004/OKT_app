"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { signIn } from "next-auth/react";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { useMemo, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { Mail, Lock } from "lucide-react";
import { useLanguage } from "@/lib/i18n";

export default function LoginPage() {
  const { t } = useLanguage();
  const router = useRouter();
  const [authError, setAuthError] = useState<string | null>(null);
  const schema = useMemo(
    () =>
      z.object({
        email: z.string().email(t("login.invalidEmail")),
        password: z.string().min(6, t("login.passwordMin")),
      }),
    [t],
  );
  type LoginForm = z.infer<typeof schema>;

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<LoginForm>({
    resolver: zodResolver(schema),
  });

  const onSubmit = async (data: LoginForm) => {
    setAuthError(null);
    const response = await signIn("credentials", {
      ...data,
      redirect: false,
    });
    if (response?.error) {
      setAuthError(t("login.invalidCredentials"));
      return;
    }
    const meResponse = await fetch("/api/me");
    if (meResponse.ok) {
      const { user } = (await meResponse.json()) as { user: { role: string } };
      router.push(
        user.role === "UNIDADE_SAUDE"
          ? "/unidade/pagina-principal"
          : "/utente/pagina-principal",
      );
      return;
    }
    router.push("/utente/pagina-principal");
  };

  return (
    <PageTransition>
      <div className="min-h-screen bg-white">
        <header className="border-b border-brand-50 px-6 py-5 text-center">
          <div className="text-sm font-semibold text-brand-700">OKT</div>
          <div className="text-xs text-brand-400">{t("common.appTagline")}</div>
        </header>
        <main className="px-6 py-8">
          <h1 className="text-center text-xl font-semibold text-brand-800">
            {t("login.title")}
          </h1>
          <form
            onSubmit={handleSubmit(onSubmit)}
            className="mt-8 space-y-6"
          >
            <div className="space-y-2">
              <label className="text-sm font-semibold text-brand-700">
                {t("login.emailLabel")}
              </label>
              <div className="relative">
                <Mail className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-brand-300" />
                <Input
                  placeholder={t("login.emailPlaceholder")}
                  className="pl-11"
                  type="email"
                  {...register("email")}
                />
              </div>
              {errors.email ? (
                <p className="text-xs text-red-500">{errors.email.message}</p>
              ) : null}
            </div>
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <label className="text-sm font-semibold text-brand-700">
                  {t("login.passwordLabel")}
                </label>
                <Link href="#" className="text-xs font-semibold text-brand-400">
                  {t("login.forgotPassword")}
                </Link>
              </div>
              <div className="relative">
                <Lock className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-brand-300" />
                <Input
                  placeholder={t("login.passwordPlaceholder")}
                  className="pl-11"
                  type="password"
                  {...register("password")}
                />
              </div>
              {errors.password ? (
                <p className="text-xs text-red-500">{errors.password.message}</p>
              ) : null}
            </div>
            {authError ? (
              <p className="text-xs text-red-500">{authError}</p>
            ) : null}
            <Button type="submit" className="w-full text-lg" disabled={isSubmitting}>
              {t("login.submit")}
            </Button>
            <Link
              href="/registo"
              className="block w-full text-center text-sm font-semibold text-brand-600"
            >
              {t("login.noAccount")}
            </Link>
          </form>
        </main>
      </div>
    </PageTransition>
  );
}
