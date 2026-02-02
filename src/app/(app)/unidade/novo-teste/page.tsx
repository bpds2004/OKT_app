"use client";

import { useState } from "react";
import { Wifi, ClipboardCheck } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function UnidadeNovoTestePage() {
  const { t } = useLanguage();
  const [status, setStatus] = useState<"disconnected" | "connecting" | "connected" | "unsupported">(
    "disconnected",
  );
  const [deviceName, setDeviceName] = useState<string | null>(null);

  const connectDevice = async () => {
    const bluetooth = (
      navigator as Navigator & {
        bluetooth?: {
          requestDevice: (options: { acceptAllDevices: boolean }) => Promise<{ name?: string | null }>;
        };
      }
    ).bluetooth;
    if (!bluetooth) {
      setStatus("unsupported");
      return;
    }
    try {
      setStatus("connecting");
      const device = await bluetooth.requestDevice({ acceptAllDevices: true });
      setDeviceName(device.name ?? "OncoKit");
      setStatus("connected");
    } catch {
      setStatus("disconnected");
    }
  };

  const statusLabel =
    status === "connected"
      ? t("novoTeste.connected")
      : status === "connecting"
        ? t("novoTeste.connecting")
        : status === "unsupported"
          ? t("novoTeste.bluetoothUnsupported")
          : t("novoTeste.disconnected");

  return (
    <PageTransition>
      <MobileShell
        title={t("novoTeste.title")}
        icon={<ClipboardCheck className="h-5 w-5" />}
        backHref="/unidade/pagina-principal"
      >
        <div className="space-y-4">
          <Card className="p-6 text-center">
            <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-brand-50 text-brand-700">
              <Wifi className="h-6 w-6" />
            </div>
            <p className="mt-4 text-sm text-brand-600">
              {t("novoTeste.instructions")}
            </p>
          </Card>
          <Card className="flex items-center justify-between px-4 py-3">
            <span className="text-sm font-semibold text-brand-600">
              {t("novoTeste.connectionStatus")}
            </span>
            <span
              className={`text-sm font-semibold ${
                status === "connected" ? "text-emerald-500" : "text-red-500"
              }`}
            >
              {statusLabel}
            </span>
          </Card>
          {deviceName ? (
            <Card className="px-4 py-3 text-sm text-brand-600">
              {t("novoTeste.deviceSelected", { name: deviceName })}
            </Card>
          ) : null}
          <Button variant="outline" className="w-full" onClick={connectDevice}>
            {t("novoTeste.connectDevice")}
          </Button>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("novoTeste.testId")}
            </label>
            <Input placeholder={t("novoTeste.testIdPlaceholder")} className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              {t("novoTeste.patientName")}
            </label>
            <Input placeholder={t("novoTeste.patientNamePlaceholder")} className="mt-2" />
          </div>
          <Button className="w-full" disabled={status !== "connected"}>
            {t("common.continue")}
          </Button>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
