"use client";

import { useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";

export default function RegistoPage() {
  const [role, setRole] = useState<"utente" | "unidade">("utente");

  return (
    <PageTransition>
      <div className="min-h-screen bg-white px-6 py-6">
        <div className="text-center">
          <div className="text-sm font-semibold text-brand-700">OKT</div>
          <div className="text-xs text-brand-400">OncoKit test</div>
        </div>
        <h1 className="mt-6 text-center text-lg font-semibold text-brand-800">
          Registo de Utilizador
        </h1>
        <p className="mt-2 text-center text-xs text-brand-400">
          Por favor, preencha os seus dados para criar a sua conta OKT.
        </p>
        <form className="mt-6 space-y-4">
          <div>
            <label className="text-sm font-semibold text-brand-700">Nome Completo</label>
            <Input
              placeholder={
                role === "utente"
                  ? "Ex: João Silva"
                  : "Ex: Hospital Central de Lisboa"
              }
              className="mt-2"
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Email</label>
            <Input
              placeholder={
                role === "utente"
                  ? "Ex: joao.silva@email.com"
                  : "Ex: unidade.saude@email.com"
              }
              className="mt-2"
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Número de Telemóvel</label>
            <Input placeholder="Ex: 912 345 678" className="mt-2" />
          </div>
          <div className="flex items-center gap-4 text-sm text-brand-700">
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={role === "utente"}
                onChange={() => setRole("utente")}
                className="h-4 w-4 rounded border-brand-200 text-brand-700"
              />
              Utente
            </label>
            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={role === "unidade"}
                onChange={() => setRole("unidade")}
                className="h-4 w-4 rounded border-brand-200 text-brand-700"
              />
              Unidade de Saúde
            </label>
          </div>

          {role === "utente" ? (
            <>
              <div>
                <label className="text-sm font-semibold text-brand-700">Número de Utente</label>
                <Input placeholder="Ex: 123456789" className="mt-2" />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">NIF</label>
                <Input placeholder="Ex: 234567890" className="mt-2" />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">Data de Nascimento</label>
                <Input placeholder="" className="mt-2" />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">Histórico Médico</label>
                <textarea
                  className="mt-2 h-24 w-full rounded-lg border border-brand-100 px-4 py-3 text-sm text-brand-700 focus-visible:border-brand-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-200"
                  placeholder="Descreva brevemente o seu histórico médico relevante..."
                />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">Nome do Médico de Família</label>
                <Input placeholder="Ex: Dra. Ana Santos" className="mt-2" />
              </div>
            </>
          ) : (
            <>
              <div>
                <label className="text-sm font-semibold text-brand-700">Endereço da Unidade</label>
                <Input placeholder="Ex: Rua da Saúde, nº1, 1000-000 Lisboa" className="mt-2" />
              </div>
              <div>
                <label className="text-sm font-semibold text-brand-700">Código da Unidade</label>
                <Input placeholder="Ex: 12345" className="mt-2" />
              </div>
            </>
          )}

          <Button className="w-full">Registar</Button>
          <Link href="/login" className="block w-full text-center text-sm font-semibold text-brand-600">
            Já tenho conta
          </Link>
        </form>
      </div>
    </PageTransition>
  );
}
