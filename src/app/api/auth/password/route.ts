import { NextResponse } from "next/server";
import { z } from "zod";
import { compare, hash } from "bcryptjs";
import { requireSessionUser } from "@/lib/api-auth";
import { prisma } from "@/lib/prisma";

const passwordSchema = z.object({
  currentPassword: z.string().min(6),
  newPassword: z.string().min(6),
});

export async function PATCH(request: Request) {
  try {
    const sessionUser = await requireSessionUser();
    const payload = passwordSchema.safeParse(await request.json());
    if (!payload.success) {
      return NextResponse.json({ error: payload.error.flatten() }, { status: 400 });
    }

    const user = await prisma.user.findUnique({
      where: { email: sessionUser.email ?? "" },
    });
    if (!user) {
      return NextResponse.json({ error: "NOT_FOUND" }, { status: 404 });
    }

    const isValid = await compare(payload.data.currentPassword, user.passwordHash);
    if (!isValid) {
      return NextResponse.json({ error: "INVALID_PASSWORD" }, { status: 400 });
    }

    const passwordHash = await hash(payload.data.newPassword, 10);
    await prisma.user.update({
      where: { id: user.id },
      data: { passwordHash },
    });

    return NextResponse.json({ success: true });
  } catch (error) {
    if (error instanceof Error && error.message === "UNAUTHORIZED") {
      return NextResponse.json({ error: "UNAUTHORIZED" }, { status: 401 });
    }
    return NextResponse.json({ error: "SERVER_ERROR" }, { status: 500 });
  }
}
