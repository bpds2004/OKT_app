import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { getToken } from "next-auth/jwt";

const LOGIN_URL = "/login";

export async function middleware(request: NextRequest) {
  const token = await getToken({
    req: request,
    secret: process.env.NEXTAUTH_SECRET ?? "okt-dev-secret",
  });
  const { pathname } = request.nextUrl;

  if (pathname.startsWith("/utente")) {
    if (!token || token.role !== "UTENTE") {
      const url = request.nextUrl.clone();
      url.pathname = LOGIN_URL;
      return NextResponse.redirect(url);
    }
  }

  if (pathname.startsWith("/unidade")) {
    if (!token || token.role !== "UNIDADE_SAUDE") {
      const url = request.nextUrl.clone();
      url.pathname = LOGIN_URL;
      return NextResponse.redirect(url);
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/utente/:path*", "/unidade/:path*"],
};
