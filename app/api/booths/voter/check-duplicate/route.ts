import { NextRequest, NextResponse } from "next/server";
import { supabase } from "@/lib/supabase"; // ✅ FIX

export async function POST(req: NextRequest) {
  try {
    const { voter_id, booth_id } = await req.json();

    if (!voter_id || !booth_id) {
      return NextResponse.json(
        { error: "voter_id and booth_id are required" },
        { status: 400 }
      );
    }

    const { data, error } = await supabase
      .from("voter_activity_log")
      .select("*")
      .eq("voter_id", voter_id)
      .eq("booth_id", booth_id)
      .order("entry_time", { ascending: false })
      .limit(1);

    if (error) throw error;

    const lastEntry = data?.[0] || null;
    const isDuplicate = !!lastEntry;

    return NextResponse.json({
      isDuplicate,
      lastEntry,
      warning: isDuplicate
        ? `Voter already voted at this booth at ${lastEntry.entry_time}`
        : null,
    });
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 400 }
    );
  }
}