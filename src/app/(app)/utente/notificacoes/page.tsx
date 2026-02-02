"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Bell, FileText } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";
import { supabase } from "@/lib/supabase/client";

type NotificationItem = {
  id: string;
  title: string;
  message: string;
  read: boolean;
  createdAt: string;
};

export default function NotificacoesPage() {
  const [filter, setFilter] = useState<"all" | "unread">("all");
  const [items, setItems] = useState<NotificationItem[]>([]);
  const { t } = useLanguage();
  const [loading, setLoading] = useState(true);

  const filtered = items.filter((item) => (filter === "unread" ? !item.read : true));
  const unreadCount = items.filter((item) => !item.read).length;

  useEffect(() => {
    fetchNotifications();
  }, []);

  const fetchNotifications = async () => {
    try {
      const { data, error } = await supabase
        .from("notifications")
        .select("id, title, message, read, created_at")
        .order("created_at", { ascending: false });
      if (error || !data) {
        setItems([]);
        setLoading(false);
        return;
      }
      setItems(
        data.map((item) => ({
          id: item.id,
          title: item.title,
          message: item.message,
          read: item.read,
          createdAt: item.created_at,
        })),
      );
    } catch {
      setItems([]);
    } finally {
      setLoading(false);
    }
  };

  const markAllAsRead = async () => {
    await supabase
      .from("notifications")
      .update({ read: true })
      .eq("read", false);
    await fetchNotifications();
  };

  const markAsRead = async (id: string) => {
    await supabase.from("notifications").update({ read: true }).eq("id", id);
    await fetchNotifications();
  };

  return (
    <PageTransition>
      <MobileShell
        title={t("notifications.title")}
        icon={<Bell className="h-5 w-5" />}
        backHref="/utente/pagina-principal"
      >
        <div className="space-y-4">
          <button
            type="button"
            onClick={markAllAsRead}
            className="text-sm font-semibold text-brand-500"
            disabled={unreadCount === 0}
          >
            {t("notifications.markAll")}
          </button>
          <div className="flex gap-3">
            <button
              type="button"
              onClick={() => setFilter("all")}
              className={`flex-1 rounded-lg px-4 py-2 text-sm font-semibold ${
                filter === "all" ? "bg-brand-800 text-white" : "bg-brand-50 text-brand-600"
              }`}
            >
              {t("notifications.all")}
            </button>
            <button
              type="button"
              onClick={() => setFilter("unread")}
              className={`flex-1 rounded-lg px-4 py-2 text-sm font-semibold ${
                filter === "unread" ? "bg-brand-800 text-white" : "bg-brand-50 text-brand-600"
              }`}
            >
              {t("notifications.unread")}
            </button>
          </div>
        </div>

        <div className="mt-4 space-y-3">
          {loading ? (
            <Card className="p-6 text-center text-sm text-brand-500">
              {t("common.loading")}
            </Card>
          ) : filtered.length > 0 ? (
            filtered.map((item) => (
              <Card
                key={item.id}
                className="relative cursor-pointer p-4"
                onClick={() => markAsRead(item.id)}
              >
                {!item.read ? (
                  <span className="absolute left-2 top-4 h-14 w-1 rounded-full bg-brand-700" />
                ) : null}
                <div className="flex items-start gap-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-full bg-brand-50 text-brand-700">
                    <FileText className="h-5 w-5" />
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center justify-between">
                      <p className="text-sm font-semibold text-brand-800">{item.title}</p>
                      <span className="text-xs text-brand-400">
                        {new Date(item.createdAt).toLocaleDateString()}
                      </span>
                    </div>
                    <p className="mt-2 text-xs text-brand-500">{item.message}</p>
                    <Badge variant={item.read ? "neutral" : "negative"} className="mt-2">
                      {item.read ? t("notifications.read") : t("notifications.unreadBadge")}
                    </Badge>
                    <Link
                      href="/utente/relatorios"
                      className="mt-2 inline-block text-xs font-semibold text-brand-600"
                    >
                      {t("notifications.viewReport")}
                    </Link>
                  </div>
                </div>
              </Card>
            ))
          ) : (
            <Card className="p-6 text-center">
              <p className="text-sm font-semibold text-brand-700">
                {t("notifications.emptyTitle")}
              </p>
              <p className="mt-2 text-xs text-brand-500">
                {t("notifications.emptyDescription")}
              </p>
            </Card>
          )}
        </div>
      </MobileShell>
    </PageTransition>
  );
}
