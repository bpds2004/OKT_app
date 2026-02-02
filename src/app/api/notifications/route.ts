import { NextResponse } from "next/server";
import { requireSessionUser } from "@/lib/api-auth";
import { prisma } from "@/lib/prisma";

export async function GET() {
  try {
    const sessionUser = await requireSessionUser();
    const user = await prisma.user.findUnique({
      where: { email: sessionUser.email ?? "" },
    });
    if (!user) {
      return NextResponse.json({ error: "NOT_FOUND" }, { status: 404 });
    }

    const notifications = await prisma.notification.findMany({
      where: { userId: user.id },
      orderBy: { createdAt: "desc" },
    });

    return NextResponse.json({ notifications });
  } catch (error) {
    if (error instanceof Error && error.message === "UNAUTHORIZED") {
      return NextResponse.json({ error: "UNAUTHORIZED" }, { status: 401 });
    }
    return NextResponse.json({ error: "SERVER_ERROR" }, { status: 500 });
  }
}
