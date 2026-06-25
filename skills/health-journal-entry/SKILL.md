---
name: health-journal-entry
description: >
  Add a dated entry to Jean's health journey journal at
  jeanius-health-journey/journal.md. Asks each field in its own
  question, writes the entry in the established format, and offers
  to commit when done. Usage: /health-journal-entry [date]
---

# /health-journal-entry — Journal Entry

Add a new dated entry to `journal.md` in the jeanius-health-journey repo.

## Journal file

`/Users/jeanseely/git/jeanius-health-journey/journal.md`

## Steps

1. **Determine the date.** If $ARGUMENTS contains a date (e.g. "5/26" or
   "2026-05-26"), use it. Otherwise use today's date. Confirm with the
   user if ambiguous.

2. **Check for an existing entry.** Search the journal for that date. If
   an entry already exists, offer to append to it rather than creating a
   new one.

3. **Gather fields — one AskUserQuestion call per group of 3:**

   Round 1:
   - Overall feeling (Good / Fine / Tired / Other)
   - Energy (Good / OK / Low / Other)
   - Mood (Good / OK / Low / Other)

   Round 2:
   - Weight (skip or type in Other)
   - Sleep (Good / OK / Poor / Other)
   - Kidney / stone status if relevant based on recent entries
     (Gone / Better / Same / Worse / Not applicable)

   Round 3:
   - Exercise (None / Dog walk(s) / Gym / Other)
   - If dog walk(s): follow up with duration and distance (e.g. "20 min,
     0.8 miles") — ask in a single question; skip if user doesn't know
   - GI (Good / Some issues / Bad day)
   - Food (Good choices / Mostly good / I'll describe)

   Round 4:
   - Caffeine — only ask if recent entries show it's been notable
   - One positive thing (Skip / type in Other)

   Round 5 (optional — ask only if not already covered):
   - Appointments, medications, or other notable events today?

4. **Write the entry** in this format:

   ```
   ---

   ## YYYY-MM-DD

   **Overall:** Good/Fine/Tired
   **Energy:** Good/OK/Low
   **Mood:** Good/OK/Low

   **Weight:** NNN (morning)         ← omit if skipped

   **Sleep:** [description]

   **Kidney:** [status]              ← omit if not applicable

   **Exercise:** Dog walk — [duration], [distance]   ← include if known
   **Exercise:** [description]                        ← for non-walk exercise

   **GI:** Good. / [description]

   **Caffeine:** [description]       ← omit if not notable

   **Food:** [description]

   **[Appointment name]:**           ← omit if none
   - [bullet notes]

   **One positive thing:** [text]    ← omit if skipped
   ```

   Omit any section the user skipped or said was not applicable.
   Keep language concise and in the voice of the existing entries.

5. **Append** the entry to the end of journal.md using the Edit tool.

6. **Offer to commit** with a conventional commit message:
   `feat(journal): add entry YYYY-MM-DD`

## Format notes

- Look at the last 3–5 entries in the journal before writing to match
  the current voice and which fields are being tracked.
- For kidney/stone status, check the last few entries to know if it's
  an active issue worth asking about.
- Ankle swelling has been a recurring item — ask about it on travel
  days or when eating out frequently.
- Do not invent or infer details the user didn't provide.
- After writing, offer to commit but do not push unless asked.
