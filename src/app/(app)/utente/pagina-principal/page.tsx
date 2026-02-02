"use client";

import Link from "next/link";
import { Bell, FileText, ClipboardList, User, Phone } from "lucide-react";
import { Card } from "@/components/ui/card";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function PaginaPrincipalPage() {
  const { t } = useLanguage();
  const shortcuts = [
    {
      title: t("home.shortcuts.reports"),
      icon: FileText,
      color: "text-sky-500",
      bg: "bg-sky-100",
      href: "/utente/relatorios",
    },
    {
      title: t("home.shortcuts.newTest"),
      icon: ClipboardList,
      color: "text-emerald-500",
      bg: "bg-emerald-100",
      href: "/utente/novo-teste",
    },
    {
      title: t("home.shortcuts.profile"),
      icon: User,
      color: "text-orange-500",
      bg: "bg-orange-100",
      href: "/utente/perfil",
    },
    {
      title: t("home.shortcuts.sos"),
      icon: Phone,
      color: "text-amber-500",
      bg: "bg-amber-100",
      href: "/utente/sos",
    },
  ];

  const articles = [
    {
      tag: t("home.articleOncology"),
      title: t("home.articlePrevention"),
    },
    {
      tag: t("home.articleResearch"),
      title: t("home.articleAdvances"),
    },
  ];

  return (
    <PageTransition>
      <div className="min-h-screen bg-white pb-10">
        <header className="flex items-center justify-between px-6 pb-4 pt-6">
          <div>
            <div className="text-sm font-semibold text-brand-800">OKT</div>
            <div className="text-xs text-brand-400">{t("common.appTagline")}</div>
          </div>
          <Link
            href="/utente/notificacoes"
            className="flex h-10 w-10 items-center justify-center rounded-full border border-brand-100 text-brand-600"
          >
            <Bell className="h-5 w-5" />
          </Link>
        </header>

        <div className="grid grid-cols-2 gap-4 px-6">
          {shortcuts.map((item) => (
            <Link key={item.title} href={item.href}>
              <Card className="flex flex-col items-center gap-3 py-6">
                <div className={`flex h-20 w-20 items-center justify-center rounded-full ${item.bg}`}>
                  <item.icon className={`h-8 w-8 ${item.color}`} />
                </div>
                <span className="text-sm font-semibold text-brand-700">
                  {item.title}
                </span>
              </Card>
            </Link>
          ))}
        </div>

        <section className="mt-6 px-6">
          <h2 className="text-base font-semibold text-brand-800">{t("home.articlesTitle")}</h2>
          <div className="mt-4 flex gap-4 overflow-x-auto pb-2">
            {articles.map((article) => (
              <div key={article.title} className="min-w-[220px]">
                <div className="h-32 rounded-2xl bg-gradient-to-br from-brand-100 via-brand-50 to-white" />
                <div className="-mt-10 space-y-2 rounded-2xl bg-white p-4 shadow-soft">
                  <span className="inline-flex rounded-full bg-brand-700 px-3 py-1 text-xs font-semibold text-white">
                    {article.tag}
                  </span>
                  <p className="text-sm font-semibold text-brand-800">
                    {article.title}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </section>
      </div>
    </PageTransition>
  );
}
