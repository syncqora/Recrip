# WhatsApp Business API — Pricing & Product Guide for Recrip

**Document version:** 1.0  
**Last updated:** May 2026  
**Audience:** Recrip product / engineering / business planning  
**Region focus:** India (+91 recipients)  
**Delivery model:** WhatsApp Business Platform (Cloud API) via backend APIs  

---

## 1. Executive summary

Recrip will send **payment and renewal reminders** (plus **on-demand “spot” messages**) through a **WhatsApp Business account** integrated via **backend APIs** — not the free WhatsApp Business phone app.

- **Meta charges per delivered template message**, by **category** (utility vs marketing), not by media type.
- **India utility rate:** ₹0.1150 per delivered message (text, image header, or video header — same price).
- **India marketing rate:** ₹0.8631 per delivered message (text, image, or video — same price).
- **Proactive reminders** (scheduled or “Send now”) are almost always **utility templates** billed at ₹0.115 each.
- **Volume** must include **scheduled reminders + spot sends** (not 1–2 messages per member only).
- **BSP/platform fees** (₹0–₹4,000+/month per account) are often larger than Meta cost at low volume.

---

## 2. Recrip project context

**Recrip** (`saas` package) is a membership and renewal dashboard (Flutter + GetX + MVVM).

### Existing product surface (UI)

- Members with **WhatsApp / email** reminder channel toggles
- **Reminders** section: rules, message templates, WhatsApp channel selection
- **Payments & renewals** settings; Razorpay integration
- Plans advertising “WhatsApp/Email Reminders”
- **Send Reminders** / **Send Reminder** actions in dashboard

### Current technical gap

- No WhatsApp API integration in codebase yet
- e.g. `onSendRemindersNow()` is a stub; sends are mostly UI/toasts
- Backend required (`ApiEndPoints.baseUrl`) for scheduling, sending, webhooks, consent

### Recommended architecture

```
Flutter app → Recrip backend API → WhatsApp Cloud API (or BSP) → Member WhatsApp
                                      ↑
                              Webhooks (delivered / failed)
```

- **Never** call Meta from Flutter; use server-side credentials.
- Store **WhatsApp opt-in** per member.
- Use **approved utility templates** for renewal/payment/spot reminders.

---

## 3. WhatsApp Business App vs Business Platform

| | WhatsApp Business App (free) | WhatsApp Business Platform (API) |
|---|------------------------------|-------------------------------------|
| Automation | Limited | Full (cron, rules, spot send) |
| Bulk / proactive reminders | Not suitable | Supported (templates + opt-in) |
| Backend integration | No | Yes (Cloud API) |
| Cost | Free | Meta per message + optional BSP |
| Use for Recrip | ❌ No | ✅ Yes |

---

## 4. Meta pricing model (India, 2026)

**Source:** [Meta WhatsApp Business Platform Pricing](https://developers.facebook.com/documentation/business-messaging/whatsapp/pricing)

### Billing rules

- Charged on **delivered template messages** (`type: template`).
- Rate depends on **template category** and recipient **country code** (+91 = India).
- **Not charged** if delivery fails.
- Model is **per-message** (conversation-based pricing deprecated July 2025).

### India rate card (per delivered template)

| Category | Purpose | Rate (INR) |
|----------|---------|------------|
| **Utility** | Payment due, renewal date, receipts, account updates | **₹0.1150** |
| **Marketing** | Promos, discounts, campaigns, upsell | **₹0.8631** |
| **Authentication** | OTP, login codes | **₹0.1150** |
| **Service** | Replies within 24h after customer messages you | **Free** |

### Free scenarios

- **Non-template** messages (text, image, video) inside open **24-hour customer service window** → free.
- **Utility templates** inside that same window → free.
- Proactive reminders to members who have **not** messaged recently → **paid utility** (typical Recrip case).

### Volume discounts

- Utility/authentication tiers apply at **very high** monthly volume (crores of messages).
- **10 gyms / thousands of messages** → use flat **₹0.115**; no tier discount expected.

---

## 5. Text vs image vs video — same Meta price

Meta does **not** add extra per-message fees for image or video in template headers.

### Utility (recommended for Recrip)

| Format | Meta price per delivered message (India) |
|--------|------------------------------------------|
| Normal text | **₹0.1150** |
| Text + image header | **₹0.1150** |
| Text + video header | **₹0.1150** |

### Marketing

| Format | Meta price per delivered message (India) |
|--------|------------------------------------------|
| Normal text | **₹0.8631** |
| Text + image header | **₹0.8631** |
| Text + video header | **₹0.8631** |

### Free-form chat (after customer initiates)

| Format | Meta price |
|--------|------------|
| Text / image / video inside 24h CSW | **₹0 (free)** |

**Formula:**

```
Monthly Meta cost ≈ delivered_messages × ₹0.115  (if all utility)
```

---

## 6. Utility vs marketing — content difference

**Category = business intent**, not media type. Image/video layout can be identical; **price and policy** differ.

| | Utility | Marketing |
|---|---------|-----------|
| Purpose | Transactional: amount, date, plan, pay link | Promotional: offers, % off, campaigns |
| India rate | ₹0.115 / message | ₹0.863 / message |
| Text vs image vs video | Same rate within category | Same rate within category |
| Free in 24h CSW? | Utility template can be free | Marketing template still charged |
| Recrip default | Renewal/payment/spot reminders | Optional promo campaigns only |

### Utility examples (use these)

- “Your Gold plan expires on 15 Jun 2026. Amount due: ₹2,500. Pay: [link]”
- “Payment of ₹2,500 received. Valid until 15 Jul 2026.”
- “Reminder: renewal due in 3 days.”

### Marketing examples (separate templates)

- “Renew this week and get 30% OFF!”
- “Limited time — don’t miss out”
- “Upgrade to Premium and get free PT sessions”

### Gray area (may be reclassified as marketing)

- “Plan expires soon — **renew now and save 20%**”
- Header image that is primarily a **SALE** banner with little account detail

### Decision checklist

| Question | Utility | Marketing |
|----------|---------|-----------|
| Main content is amount / date / plan / pay link? | ✅ | |
| Main goal is discount / campaign / upsell? | | ✅ |
| Could this be a neutral SMS receipt? | ✅ | |
| Would it fit a Facebook ad? | | ✅ |

---

## 7. Visual examples (member phone)

### 7.1 Utility — renewal / payment reminder (~₹0.115)

```
┌─────────────────────────────────────────┐
│  WhatsApp                    FitLife Gym ✓│
├─────────────────────────────────────────┤
│     ┌─────────────────────────────┐     │
│     │  [  Gym logo – header img ] │     │
│     └─────────────────────────────┘     │
│     Hi Rahul,                           │
│     Your Gold Membership expires on     │
│     15 Jun 2026.                        │
│     Amount due: ₹2,500                  │
│     ┌─────────────────────────────┐     │
│     │      Pay now  →               │     │
│     └─────────────────────────────┘     │
│     FitLife Gym · Account update        │
└─────────────────────────────────────────┘
```

### 7.2 Marketing — promo / offer (~₹0.863)

```
┌─────────────────────────────────────────┐
│  WhatsApp                    FitLife Gym ✓│
├─────────────────────────────────────────┤
│     ┌─────────────────────────────┐     │
│     │  SUMMER SALE – 30% OFF      │     │
│     │  RENEW THIS WEEK ONLY       │     │
│     └─────────────────────────────┘     │
│     Hey Rahul! Renew this week and      │
│     get 30% OFF! Limited time.          │
│     ┌─────────────────────────────┐     │
│     │    Claim offer  →             │     │
│     └─────────────────────────────┘     │
└─────────────────────────────────────────┘
```

### 7.3 Template configuration (Meta)

**Utility:** `renewal_payment_reminder`  
- Category: Utility  
- Header: Image (optional)  
- Body: `Hi {{1}}, your {{2}} expires on {{3}}. Amount due: ₹{{4}}.`  
- Button: URL — Pay now  

**Marketing:** `renewal_promo_offer`  
- Category: Marketing  
- Header: Image (offer banner)  
- Body: `Hi {{1}}, renew this week and get {{2}}% off!`  
- Button: URL — Claim offer  

---

## 8. Message volume planning

Do **not** assume 1–2 messages per member per month.

### Message types

| Type | Trigger | Typical billing |
|------|---------|-----------------|
| Rule-based reminders | Cron / scheduler | Utility template |
| Spot “Send now” | Gym owner in app | Utility template |
| Chat reply | After member messages | Often free (non-template in CSW) |

### Volume formula

```
Monthly messages ≈ active_members × (scheduled_per_member + spot_per_member)
```

| Gym behavior | Scheduled / member / mo | Spot / member / mo | Total / member / mo |
|--------------|-------------------------|--------------------|---------------------|
| Light | 1–2 | 0–0.5 | 1–2.5 |
| Typical | 2 | 0.5–1 | 2.5–3 |
| Heavy | 2–3 | 1–3+ | 3–6+ |

**Planning defaults:**

- Average: **3–4** messages per active member per month  
- Buffer / busy season: **6+**  
- Peak renewal weeks: scheduled + spot can **exceed** normal monthly average  

---

## 9. Cost scaling tables (Meta utility only)

| Total delivered messages | Meta cost (INR) |
|--------------------------|-----------------|
| 100 | ₹11.50 |
| 500 | ₹57.50 |
| 1,000 | ₹115 |
| 2,500 | ₹287.50 |
| 5,000 | ₹575 |
| 10,000 | ₹1,150 |
| 25,000 | ₹2,875 |
| 50,000 | ₹5,750 |

**Mixed format example (same total):**

| Mix | Messages | Meta total |
|-----|----------|------------|
| 100% text | 1,000 | ₹115 |
| 70% text + 20% image + 10% video | 1,000 | ₹115 |

---

## 10. BSP / platform costs (on top of Meta)

```
Total monthly ≈ (messages × ₹0.115) + BSP_subscription + (messages × BSP_markup_if_any)
```

| Item | Typical range (India) |
|------|------------------------|
| BSP monthly plan | ₹0 – ₹4,000+ / month |
| BSP per-message markup | ₹0 – ₹0.50+ / msg (some pass through at ₹0) |
| GST | Often 18% on BSP fees |

**Integration options:**

| Approach | Notes |
|----------|--------|
| Direct Cloud API | Meta billing in Business Suite; no BSP markup |
| Via BSP (Interakt, Wati, AiSensy, 360dialog, Twilio, Gupshup) | Easier ops; may add monthly + per-msg fees |

---

## 11. Scenario: 10 gyms, varying members

**Assumptions:** Utility templates only; India numbers; includes scheduled + spot sends.

| Gym | Members | Msgs / member / mo | Messages / mo |
|-----|---------|--------------------|---------------|
| 1 | 50 | 3 | 150 |
| 2 | 80 | 4 | 320 |
| 3 | 120 | 3 | 360 |
| 4 | 150 | 4 | 600 |
| 5 | 200 | 3 | 600 |
| 6 | 250 | 4 | 1,000 |
| 7 | 300 | 5 | 1,500 |
| 8 | 350 | 3 | 1,050 |
| 9 | 400 | 4 | 1,600 |
| 10 | 500 | 3 | 1,500 |
| **Total** | **2,400** | — | **8,680** |

### Meta only

**8,680 × ₹0.1150 ≈ ₹998/month (~₹1,000)**

### Format split (same Meta total)

| Format | Share | Count | Subtotal |
|--------|-------|-------|----------|
| Text | 65% | 5,642 | ₹648 |
| Image header | 25% | 2,170 | ₹250 |
| Video header | 10% | 868 | ₹100 |
| **Total** | 100% | 8,680 | **₹998** |

### All-in monthly (Meta + BSP)

| Setup | Meta | BSP | Approx. total |
|-------|------|-----|----------------|
| 1 shared platform WABA | ₹998 | ₹2,000 | **~₹3,000** |
| 10 separate numbers/plans | ₹998 | ₹20,000 | **~₹21,000** |

### Heavy month (+50% volume → ~13,020 msgs)

- Meta utility: **~₹1,497**

### If 10% of sends are marketing

| Type | Count | Rate | Cost |
|------|-------|------|------|
| Utility | 7,812 | ₹0.115 | ₹898 |
| Marketing | 868 | ₹0.8631 | ₹749 |
| **Total** | 8,680 | | **~₹1,647** |

### Per-gym Meta (utility)

| Gym | Members | Msgs/mo | Meta |
|-----|---------|---------|------|
| 1 | 50 | 150 | ₹17 |
| 2 | 80 | 320 | ₹37 |
| 3 | 120 | 360 | ₹41 |
| 4 | 150 | 600 | ₹69 |
| 5 | 200 | 600 | ₹69 |
| 6 | 250 | 1,000 | ₹115 |
| 7 | 300 | 1,500 | ₹173 |
| 8 | 350 | 1,050 | ₹121 |
| 9 | 400 | 1,600 | ₹184 |
| 10 | 500 | 1,500 | ₹173 |

---

## 12. Backend API requirements (Recrip)

### Responsibilities

1. **Credentials** — WABA ID, phone_number_id, access token (server env only)  
2. **Templates** — create/sync approved templates in Meta  
3. **Opt-in** — persist member consent for WhatsApp  
4. **Send API** — `POST /{phone_number_id}/messages` with template + variables  
5. **Scheduler** — cron for rule-based reminders  
6. **Spot send** — endpoint for “Send now” from dashboard  
7. **Webhooks** — delivery status, failures, billing analytics  
8. **Logging** — category, template, member, cost attribution per gym  

### Suggested Recrip endpoints

- `POST /api/reminders/send` — spot send  
- `POST /api/reminders/schedule` — rule execution (internal/cron)  
- `POST /api/webhooks/whatsapp` — Meta status callbacks  

### WABA strategy

| Model | Pros | Cons |
|-------|------|------|
| One platform WABA | Lower BSP cost, central ops | Less per-gym branding |
| One WABA per gym | Their number & brand | Higher BSP × gyms |

Meta per-message rate unchanged; BSP subscription structure changes.

---

## 13. SaaS pricing suggestions (charging gyms)

Optional models for Recrip subscriptions:

1. **Included message quota** per plan (e.g. 500 / 1,500 / 5,000 per month)  
2. **Overage** at ₹0.15–₹0.25/msg (covers Meta ₹0.115 + margin)  
3. **Same overage** for text, image, video utility  
4. **Separate marketing bucket** at higher overage if gyms run promos  
5. **Fair-use cap** on “unlimited” spot sends (e.g. max 10× member count/month)

---

## 14. Recommendations

1. **Default to utility templates** for all renewal/payment/spot reminders.  
2. **Start text-only utility** templates; add image/video headers when needed for branding.  
3. **Keep marketing templates separate** for offers; track cost separately.  
4. **Budget 3–4 utility messages per active member per month**; use 6+ for heavy spot usage.  
5. **Pick BSP with pass-through Meta pricing** if volume will grow.  
6. **Implement backend-first**; Flutter triggers your API only.  
7. **Log webhook `pricing.category`** for reconciliation and gym-level reporting.

---

## 15. Quick reference card

| What you send | Category | Text | + Image | + Video |
|---------------|----------|------|---------|---------|
| Renewal / payment reminder (proactive) | Utility | ₹0.115 | ₹0.115 | ₹0.115 |
| Promo / offer blast | Marketing | ₹0.863 | ₹0.863 | ₹0.863 |
| Reply after member messaged you (24h) | Service | Free | Free | Free |

**10 gyms · ~2,400 members · ~4 msgs/member/month → ~8,700 msgs → Meta ~₹1,000/mo (utility) + BSP ₹2k–₹20k depending on account model.**

---

## 16. References

- [Meta — Pricing on the WhatsApp Business Platform](https://developers.facebook.com/documentation/business-messaging/whatsapp/pricing)  
- [Meta — Template categorization](https://developers.facebook.com/documentation/business-messaging/whatsapp/templates/template-categorization)  
- Recrip codebase: reminders UI, member WhatsApp toggle, Razorpay payments (integration pending)

---

*End of document*
