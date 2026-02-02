"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { signIn } from "next-auth/react";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { Mail, Lock } from "lucide-react";

const schema = z.object({
  email: z.string().email("Email inválido"),
  password: z.string().min(6, "Mínimo de 6 caracteres"),
});

type LoginForm = z.infer<typeof schema>;

export default function LoginPage() {
  const router = useRouter();
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<LoginForm>({
    resolver: zodResolver(schema),
  });

  const onSubmit = async (data: LoginForm) => {
    await signIn("credentials", {
      ...data,
      role: "UTENTE",
      redirect: false,
    });
    router.push("/utente/pagina-principal");
  };

  return (
    <PageTransition>
      <div className="min-h-screen bg-white">
        <header className="border-b border-brand-50 px-6 py-5 text-center">
          <div className="text-sm font-semibold text-brand-700">OKT</div>
          <div className="text-xs text-brand-400">OncoKit test</div>
        </header>
        <main className="px-6 py-8">
          <h1 className="text-center text-xl font-semibold text-brand-800">
            Entrar na sua conta
          </h1>
          <form
            onSubmit={handleSubmit(onSubmit)}
            className="mt-8 space-y-6"
          >
            <div className="space-y-2">
              <label className="text-sm font-semibold text-brand-700">Email</label>
              <div className="relative">
                <Mail className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-brand-300" />
                <Input
                  placeholder="Introduza o seu email"
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
                <label className="text-sm font-semibold text-brand-700">Password</label>
                <Link href="#" className="text-xs font-semibold text-brand-400">
                  Esqueceu a password?
                </Link>
              </div>
              <div className="relative">
                <Lock className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-brand-300" />
                <Input
                  placeholder="Introduza a sua password"
                  className="pl-11"
                  type="password"
                  {...register("password")}
                />
              </div>
              {errors.password ? (
                <p className="text-xs text-red-500">{errors.password.message}</p>
              ) : null}
            </div>
            <Button type="submit" className="w-full text-lg" disabled={isSubmitting}>
              Entrar
            </Button>
            <Link
              href="/registo"
              className="block w-full text-center text-sm font-semibold text-brand-600"
            >
              Não tenho conta
            </Link>
          </form>
        </main>
      </div>
    </PageTransition>
  );
}
