# -*- coding: utf-8 -*-
import json, sys
sys.stdout.reconfigure(encoding="utf-8")
from pathlib import Path
from collections import Counter, defaultdict

src = Path(r"C:\Users\Thanh Son\Videos\edit\transcripts\2026-06-20 21-25-12.json")
d = json.loads(src.read_text(encoding="utf-8"))
words = d.get("words", [])

def mmss(s):
    if s is None: return "--:--"
    s = int(s); return f"{s//60:02d}:{s%60:02d}"

# ---- stats ----
types = Counter(w.get("type") for w in words)
spk_words = Counter(); spk_time = defaultdict(float)
for w in words:
    if w.get("type") == "word":
        sid = w.get("speaker_id"); spk_words[sid]+=1
        st,en = w.get("start"), w.get("end")
        if st is not None and en is not None: spk_time[sid]+=(en-st)
events = Counter(w.get("text") for w in words if w.get("type")=="audio_event")
total_dur = max((w.get("end") or 0) for w in words) if words else 0

print("=== THONG KE ===")
print("lang:", d.get("language_code"), round(d.get("language_probability",0),3))
print("duration:", mmss(total_dur), f"({int(total_dur)}s)")
print("types:", dict(types))
print("speakers by words:", dict(spk_words.most_common()))
print("speakers by seconds:", {k: round(v) for k,v in sorted(spk_time.items(), key=lambda x:-x[1])})
print("audio events:", dict(events.most_common()))

# ---- build readable transcript grouped by speaker, with audio events inline ----
lines = []
cur_spk = None; buf = []; seg_start = None
def flush():
    global buf, cur_spk, seg_start
    if buf:
        txt = "".join(buf).strip()
        if txt:
            lines.append(f"\n**[{mmss(seg_start)}] {cur_spk}:** {txt}")
    buf = []
for w in words:
    t = w.get("type")
    if t == "audio_event":
        flush(); cur_spk=None
        lines.append(f"\n  > 🎵 *audio event: {w.get('text')}* [{mmss(w.get('start'))}]")
    elif t in ("word","spacing"):
        sid = w.get("speaker_id")
        if t=="word" and sid != cur_spk:
            flush(); cur_spk = sid; seg_start = w.get("start")
        buf.append(w.get("text",""))
flush()

out = Path(r"C:\Users\Thanh Son\Videos\edit\transcripts\2026-06-20_TKT_doc.md")
out.write_text("# Transcript webinar Tran Khanh Tu - 2026-06-20\n" + "\n".join(lines), encoding="utf-8")
print("\nsaved doc:", out, f"({out.stat().st_size//1024} KB)")

# also plain full text for quick grep
ft = Path(r"C:\Users\Thanh Son\Videos\edit\transcripts\2026-06-20_TKT_fulltext.txt")
ft.write_text(d.get("text",""), encoding="utf-8")
print("saved fulltext:", ft, f"({ft.stat().st_size//1024} KB)")
