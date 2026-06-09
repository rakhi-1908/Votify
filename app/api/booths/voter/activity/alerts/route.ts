import { NextRequest, NextResponse } from "next/server";
import { supabase } from "@/lib/supabase"; // ✅ FIX

// GET all alerts
export async function GET(req: NextRequest) {
  try {
    const searchParams = req.nextUrl.searchParams;
    const boothId = searchParams.get("booth_id");
    const isResolved = searchParams.get("is_resolved");
    const severity = searchParams.get("severity");

    let query = supabase
      .from("alerts")
      .select("*, booths(booth_name), voter_activity_log(*)")
      .order("created_at", { ascending: false });

    if (boothId) {
      query = query.eq("booth_id", boothId);
    }

    if (isResolved !== null) {
      query = query.eq("is_resolved", isResolved === "true");
    }

    if (severity) {
      query = query.eq("severity", severity);
    }

    const { data, error } = await query;

    if (error) throw error;

    return NextResponse.json(data);
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 500 }
    );
  }
}