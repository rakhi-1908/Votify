import { NextRequest, NextResponse } from "next/server";
import { supabase } from "@/lib/supabase"; // ✅ FIX

// GET activity log with filters
export async function GET(req: NextRequest) {
  try {
    const searchParams = req.nextUrl.searchParams;
    const boothId = searchParams.get("booth_id");
    const isSuspicious = searchParams.get("is_suspicious");

    let query = supabase
      .from("voter_activity_log")
      .select("*, booths(booth_name, booth_code)")
      .order("entry_time", { ascending: false });

    if (boothId) {
      query = query.eq("booth_id", boothId);
    }

    if (isSuspicious !== null) {
      query = query.eq("is_suspicious", isSuspicious === "true");
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

// POST new activity entry
export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const {
      voter_id,
      booth_id,
      latitude,
      longitude,
      geofence_status,
      image_url,
    } = body;

    if (!voter_id || !booth_id) {
      return NextResponse.json(
        { error: "voter_id and booth_id are required" },
        { status: 400 }
      );
    }

    // Check for duplicate entry
    const { data: recentActivity, error: checkError } = await supabase
      .from("voter_activity_log")
      .select("*")
      .eq("voter_id", voter_id)
      .eq("booth_id", booth_id)
      .order("entry_time", { ascending: false })
      .limit(1);

    if (checkError) throw checkError;

    let flags: string[] = [];
    let isSuspicious = false;

    // Duplicate check (within 5 mins)
    if (recentActivity?.length) {
      const lastEntry = new Date(recentActivity[0].entry_time);
      const currentTime = new Date();
      const timeDiff =
        (currentTime.getTime() - lastEntry.getTime()) / 1000 / 60;

      if (timeDiff < 5) {
        flags.push("duplicate_entry");
        isSuspicious = true;
      }
    }

    // Geofence check
    if (geofence_status === "outside") {
      flags.push("outside_geofence");
      isSuspicious = true;
    }

    // Insert activity
    const { data, error } = await supabase
      .from("voter_activity_log")
      .insert([
        {
          voter_id,
          booth_id,
          latitude,
          longitude,
          geofence_status,
          is_suspicious: isSuspicious,
          flags,
          image_url,
        },
      ])
      .select();

    if (error) throw error;

    // Create alert if suspicious
    if (isSuspicious && data?.length) {
      const alertType = flags.includes("duplicate_entry")
        ? "duplicate_voter"
        : "outside_geofence";

      await supabase.from("alerts").insert([
        {
          alert_type: alertType,
          severity: "high",
          booth_id,
          voter_id,
          activity_id: data[0].id,
          description: `Suspicious activity detected: ${flags.join(", ")}`,
        },
      ]);
    }

    return NextResponse.json(data[0], { status: 201 });
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 400 }
    );
  }
}