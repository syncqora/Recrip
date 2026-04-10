#!/usr/bin/env node
/**
 * Minimal dev server: creates Razorpay orders (uses Key Secret server-side only).
 *
 * Setup:
 *   export RAZORPAY_KEY_ID=rzp_test_...
 *   export RAZORPAY_KEY_SECRET=...
 *   node scripts/razorpay_order_server.mjs
 *
 * Flutter web:
 *   flutter run -d chrome \
 *     --dart-define=RAZORPAY_KEY_ID=$RAZORPAY_KEY_ID \
 *     --dart-define=RAZORPAY_ORDER_API_URL=http://localhost:3777/create-order
 *
 * If you ever pasted the Key Secret in chat or commits, rotate it in Razorpay Dashboard.
 */

import http from "node:http";
import { randomBytes } from "node:crypto";

const PORT = Number(process.env.PORT || 3777);
const KEY_ID = process.env.RAZORPAY_KEY_ID;
const KEY_SECRET = process.env.RAZORPAY_KEY_SECRET;

if (!KEY_ID || !KEY_SECRET) {
  console.error("Set RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET in the environment.");
  process.exit(1);
}

const auth = Buffer.from(`${KEY_ID}:${KEY_SECRET}`).toString("base64");

function sendJson(res, status, body) {
  const data = JSON.stringify(body);
  res.writeHead(status, {
    "Content-Type": "application/json; charset=utf-8",
    "Content-Length": Buffer.byteLength(data),
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
  });
  res.end(data);
}

const server = http.createServer(async (req, res) => {
  if (req.method === "OPTIONS") {
    res.writeHead(204, {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
    });
    res.end();
    return;
  }

  if (req.method !== "POST" || req.url !== "/create-order") {
    sendJson(res, 404, { error: "not_found" });
    return;
  }

  let body = "";
  for await (const chunk of req) {
    body += chunk;
  }

  let json;
  try {
    json = JSON.parse(body || "{}");
  } catch {
    sendJson(res, 400, { error: "invalid_json" });
    return;
  }

  const amount = json.amount;
  const currency = json.currency || "INR";
  if (typeof amount !== "number" || !Number.isFinite(amount) || amount < 100) {
    sendJson(res, 400, { error: "amount must be a number (paise), min 100" });
    return;
  }

  const receipt = `rcpt_${randomBytes(4).toString("hex")}`;

  try {
    const r = await fetch("https://api.razorpay.com/v1/orders", {
      method: "POST",
      headers: {
        Authorization: `Basic ${auth}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        amount,
        currency,
        receipt,
      }),
    });
    const text = await r.text();
    if (!r.ok) {
      sendJson(res, 502, { error: "razorpay_error", status: r.status, body: text });
      return;
    }
    res.writeHead(200, {
      "Content-Type": "application/json; charset=utf-8",
      "Access-Control-Allow-Origin": "*",
    });
    res.end(text);
  } catch (e) {
    sendJson(res, 500, { error: String(e) });
  }
});

server.listen(PORT, () => {
  console.log(`Razorpay order server http://localhost:${PORT}/create-order`);
});
