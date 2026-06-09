import { NextRequest, NextResponse } from "next/server";
import { supabase } from "@/lib/supabase"; // ✅ FIXED

export async function GET(req: NextRequest) {
  try {
    const searchParams = req.nextUrl.searchParams;
    const boothId = searchParams.get("booth_id");

    let query = supabase
      .from("election_stats")
      .select("*, booths(booth_name, booth_code)");

    if (boothId) {
      query = query.eq("booth_id", boothId);
    }

    const { data, error } = await query;

    if (error) throw error;

    // ✅ Type-safe totals
    const totals = {
      totalEntries:
        data?.reduce((sum: number, stat: any) => sum + (stat.total_entries || 0), 0) || 0,

      flaggedEntries:
        data?.reduce((sum: number, stat: any) => sum + (stat.flagged_entries || 0), 0) || 0,

      duplicateAttempts:
        data?.reduce((sum: number, stat: any) => sum + (stat.duplicate_attempts || 0), 0) || 0,

      outsideGeofence:
        data?.reduce((sum: number, stat: any) => sum + (stat.outside_geofence_count || 0), 0) || 0,
    };

    return NextResponse.json({ booths: data, totals });
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 500 }
    );
  }
}