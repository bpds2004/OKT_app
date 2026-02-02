import { NextResponse } from "next/server";
import { requireSessionUser } from "@/lib/api-auth";
import { prisma } from "@/lib/prisma";

export async function PATCH(
  _request: Request,
  { params }: { params: { id: string } },
) {
  try {
    const sessionUser = await requireSessionUser();
    const user = await prisma.user.findUnique({
      where: { email: sessionUser.email ?? "" },
    });
    if (!user) {
      return NextResponse.json({ error: "NOT_FOUND" }, { status: 404 });
    }

    const notification = await prisma.notification.findUnique({ where: { id: params.id } });
    if (!notification || notification.userId !== user.id) {
      return NextResponse.json({ error: "FORBIDDEN" }, { status: 403 });
    }

    const updated = await prisma.notification.update({
      where: { id: params.id },
      data: { read: true },
    });

    return NextResponse.json({ notification: updated });
  } catch (error) {
    if (error instanceof Error && error.message === "UNAUTHORIZED") {
      return NextResponse.json({ error: "UNAUTHORIZED" }, { status: 401 });
    }
    return NextResponse.json({ error: "SERVER_ERROR" }, { status: 500 });
  }
}
