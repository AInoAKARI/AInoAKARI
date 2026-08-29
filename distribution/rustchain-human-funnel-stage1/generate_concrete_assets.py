from __future__ import annotations
import hashlib, shutil, subprocess
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except Exception as e:
    raise SystemExit("Pillow is required: pip install pillow") from e

ROOT = Path(__file__).resolve().parent
SHORTS = ROOT / "shorts"
MEMES = ROOT / "memes"
CARDS = ROOT / ".render-cards"
for p in (SHORTS, MEMES, CARDS):
    p.mkdir(parents=True, exist_ok=True)

W, H = 1080, 1920

def font(size: int, bold: bool=False):
    candidates = [
        r"C:\Windows\Fonts\arialbd.ttf" if bold else r"C:\Windows\Fonts\arial.ttf",
        r"C:\Windows\Fonts\segoeuib.ttf" if bold else r"C:\Windows\Fonts\segoeui.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ]
    for c in candidates:
        if c and Path(c).exists():
            return ImageFont.truetype(c, size=size)
    return ImageFont.load_default()

def wrap(draw, text, fnt, max_width):
    words = text.split()
    lines, cur = [], ""
    for word in words:
        test = word if not cur else cur + " " + word
        if draw.textbbox((0,0), test, font=fnt)[2] <= max_width:
            cur = test
        else:
            if cur: lines.append(cur)
            cur = word
    if cur: lines.append(cur)
    return lines

def card(path: Path, title: str, body: str, footer="rustchain.org", accent=(255,95,110)):
    img = Image.new("RGB", (W,H), (17,19,26))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((90,150,990,1770), 60, fill=(27,30,40), outline=accent, width=7)
    d.ellipse((120,120,380,380), fill=accent)
    d.rectangle((170,250,830,920), fill=(40,44,58))
    d.rounded_rectangle((250,330,750,760), 38, fill=(10,12,16), outline=(210,210,220), width=4)
    d.rectangle((455,760,545,930), fill=(180,180,190))
    d.rectangle((330,900,670,945), fill=(180,180,190))
    tf = font(88, True); bf = font(58); ff = font(52, True)
    y = 1030
    for line in wrap(d, title, tf, 820):
        d.text((130,y), line, font=tf, fill=(248,248,252)); y += 105
    y += 30
    for line in wrap(d, body, bf, 820):
        d.text((130,y), line, font=bf, fill=(210,214,224)); y += 74
    d.text((130,1660), footer, font=ff, fill=accent)
    img.save(path)

def meme(path: Path, title: str, lines: list[str], accent=(255,95,110)):
    img = Image.new("RGB",(W,W),(18,20,28))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((55,55,1025,1025), 48, fill=(30,33,44), outline=accent, width=6)
    tf=font(72,True); bf=font(52,True); ff=font(40)
    y=110
    for ln in wrap(d,title,tf,860):
        d.text((110,y),ln,font=tf,fill=(250,250,252)); y+=88
    y+=40
    for ln in lines:
        for wrapped in wrap(d,ln,bf,850):
            d.text((115,y),wrapped,font=bf,fill=(215,219,230)); y+=68
        y+=28
    d.text((115,945),"rustchain.org",font=ff,fill=accent)
    img.save(path)

def render_video(out: Path, cards: list[tuple[str,str,float]], freq: int):
    ffmpeg = shutil.which("ffmpeg")
    if not ffmpeg:
        raise SystemExit("ffmpeg not found on PATH")
    inputs=[]; labels=[]
    for i,(title,body,dur) in enumerate(cards):
        p=CARDS/f"{out.stem}-{i+1}.png"
        card(p,title,body)
        inputs += ["-loop","1","-t",str(dur),"-i",str(p)]
        labels.append(f"[{i}:v]scale={W}:{H},setsar=1,fps=30[v{i}]")
    total=sum(x[2] for x in cards)
    audio_index=len(cards)
    inputs += ["-f","lavfi","-t",str(total),"-i",f"sine=frequency={freq}:sample_rate=44100"]
    concat = "".join(f"[v{i}]" for i in range(len(cards))) + f"concat=n={len(cards)}:v=1:a=0[v]"
    filt = ";".join(labels+[concat])
    cmd=[ffmpeg,"-y",*inputs,"-filter_complex",filt,"-map","[v]","-map",f"{audio_index}:a",
         "-c:v","libx264","-pix_fmt","yuv420p","-r","30","-c:a","aac","-b:a","96k","-shortest",str(out)]
    subprocess.run(cmd, check=True)

def sha256(p: Path):
    h=hashlib.sha256()
    with p.open("rb") as f:
        for chunk in iter(lambda:f.read(1024*1024),b""): h.update(chunk)
    return h.hexdigest()

render_video(SHORTS/"01-proof-not-promises.mp4",[
    ("OLD COMPUTER?","Don't recycle it yet.",2.5),
    ("REAL HARDWARE","RustChain verifies distinct machines.",2.5),
    ("PROOF > PROMISES","Eligible vintage hardware can matter more.",2.5),
    ("SEE IF YOURS QUALIFIES","rustchain.org",2.5),
],220)

render_video(SHORTS/"02-old-hardware-new-proof.mp4",[
    ("NEWER ≠ ALWAYS BETTER","Proof-of-Antiquity changes the question.",3),
    ("OLD HARDWARE","Eligible vintage machines can receive bonus weighting.",3),
    ("STILL HAS A JOB","Boot the machine you already own.",3),
    ("POWER IT ON. CHECK FIRST.","rustchain.org",3),
],247)

render_video(SHORTS/"03-bottube-human-first.mp4",[
    ("OLDEST COMPUTER?","Find the oldest one that still boots.",4),
    ("BOOT IT","Give that machine one more chance.",4),
    ("SEE WHAT RUSTCHAIN SAYS","Test eligibility before buying anything.",4),
    ("SHOW THE REVIVAL","RustChain → rustchain.org • share on BoTTube",3),
],196)

meme(MEMES/"01-old-hardware.png","OLD HARDWARE",["TECH INDUSTRY: TOO OLD","RUSTCHAIN: HOW OLD, EXACTLY?","See if yours qualifies."],(255,105,120))
meme(MEMES/"02-proof-work.png","PROOF > PROMISES",["GUARANTEED EARNINGS: NO","VERIFY THE MACHINE: YES","Proof first. Second life next."],(90,210,170))
meme(MEMES/"03-bottube.png","POST THE RESURRECTION",["FOUND IN CLOSET","STILL BOOTS","TEST WITH RUSTCHAIN","SHARE THE REVIVE CLIP ON BoTTube"],(130,150,255))
meme(MEMES/"04-revive-machine.png","REVIVE TICKET",["MACHINE AGE: OLD","PROBLEM: FORGOTTEN","REPAIR: BOOT IT","NEXT: SEE IF RUSTCHAIN CAN USE IT"],(255,180,80))
meme(MEMES/"05-human-compute.png","EXHIBIT A",["A COMPUTER THAT REFUSED","TO BECOME E-WASTE","REAL HARDWARE. REAL HISTORY.","ONE MORE JOB."],(195,120,255))

hooks = [
"That old Mac in your closet is not automatically obsolete. Power it on and see if it qualifies.",
"Most tech tells you newer is better. RustChain asks what if age itself can be part of the proof?",
"Before you recycle that old computer, give it one last job interview.",
"A 2012 laptop may be slow for modern apps and still be interesting to RustChain.",
"No get-rich-quick claim: prove the machine first, then see whether it qualifies.",
"Tonight's challenge: do not buy a new computer. Test the oldest working machine you already own.",
"Vintage hardware is the feature: Proof-of-Antiquity explicitly values eligible older machines.",
"You do not need to understand blockchains first. Start from the official RustChain page on a spare machine.",
"Found an old computer that still boots? Record the revival and what RustChain reports.",
"New machines are fast. Old machines have history. Proof-of-Antiquity makes that history part of the design.",
]

lines=["# RustChain #315 — Concrete Artifact Index","","All media below is original typography/shapes/background/audio generated locally for this bounty. No copyrighted meme templates, product photography, screenshots, logos, sampled music or guaranteed-return language are used.","","## 10 RustChain-specific hooks"]
for i,h in enumerate(hooks,1): lines += [f"{i}. {h}"]
lines += ["","## Concrete binaries"]
base="https://github.com/AInoAKARI/AInoAKARI/blob/main/distribution/rustchain-human-funnel-stage1"
for p in sorted(SHORTS.glob("*.mp4")):
    lines += [f"- [{p.name}]({base}/shorts/{p.name}) — 1080x1920; SHA-256 `{sha256(p)}`"]
for p in sorted(MEMES.glob("*.png")):
    lines += [f"- [{p.name}]({base}/memes/{p.name}) — 1080x1080; SHA-256 `{sha256(p)}`"]
lines += ["","## Public-post proof","Unavailable at render time. No BoTTube/X proof URL is fabricated. The concrete files are publicly reviewable from this index once committed."]
(ROOT/"ARTIFACT_INDEX.md").write_text("\n".join(lines)+"\n",encoding="utf-8")
print("generated:", len(list(SHORTS.glob('*.mp4'))), "mp4 +", len(list(MEMES.glob('*.png'))), "png")
