import { getServerSession } from "next-auth";
import { authOptions } from "@/lib/auth";

export const getSessionUser = async () => {
  const session = await getServerSession(authOptions);
  if (!session?.user?.email) return null;
  return session.user;
};

export const requireSessionUser = async () => {
  const user = await getSessionUser();
  if (!user) {
    throw new Error("UNAUTHORIZED");
  }
  return user;
};

export const requireRole = async (role: string) => {
  const user = await requireSessionUser();
  if (user.role !== role) {
    throw new Error("FORBIDDEN");
  }
  return user;
};
