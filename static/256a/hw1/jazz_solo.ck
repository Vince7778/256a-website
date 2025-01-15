
// blues scale
[ 0, 3, 5, 6, 7, 10, 12 ] @=> int scale[];

// chord progression (twelve bar blues)
[ 0, 0, 0, 0, 5, 5, 0, 0, 7, 5, 0, 7 ] @=> int changes[];

Blit voc => Envelope e => dac;

20::ms => dur d => e.duration;
0.5 => voc.gain;
3 => voc.harmonics;

fun playNote(float note, dur t) {
    t - 2*d => dur playTime;
    Std.mtof(note) => voc.freq;
    
    e.keyOn();
    d => now;
    
    playTime => now;
    
    e.keyOff();
    d => now;
}

// play scale
for (int note : scale) {
    playNote(60 + note, 100::ms);
}

300::ms => now;

// one triplet beat
120::ms => dur baseDur;

fun float sample_normal() {
    1 - Math.randomf() => float u;
    Math.randomf() => float v;
    return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
}

// randomly change the note according to normal distribution
fun int getChangedNote(int curNote) {
    Math.round(sample_normal() * 3) $ int => int offset;
    // prevent it from getting stuck on the edges
    if ((curNote == 28 && offset < 0) || (curNote == 49 && offset > 0)) {
        -offset => offset;
    }
    return Std.clamp(curNote + offset, 28, 49);
}

fun int getScaledNote(int curNote) {
    curNote / scale.size() * 12 => int curOctave;
    return curOctave + scale[curNote % scale.size()];
}

fun play_solo() {
    35 => int curNote;
    
    // improvise!
    while (true) {
        for (0 => int curChord; curChord < changes.size(); curChord++) {
            for (0 => int rep; rep < 4; rep++) {
                if (Math.randomf() < 0.9) {
                    getChangedNote(curNote) => curNote;
                    playNote(changes[curChord] + getScaledNote(curNote), baseDur * 2);
                } else {
                    baseDur * 2 => now;
                }
                
                if (Math.randomf() < 0.8) {
                    getChangedNote(curNote) => curNote;
                    playNote(changes[curChord] + getScaledNote(curNote), baseDur);
                } else {
                    baseDur => now;
                }
            }
        }
    }
}

fun play_snare() {
    Noise snare => dac;
    0 => snare.gain;
    
    while (true) {
        3 * baseDur => now;
        0.1 => snare.gain;
        baseDur/5 => now;
        0 => snare.gain;
        baseDur*14/5 => now;
    }
}

fun one_kick(Envelope env) {
    env.keyOn();
    40::ms => now;
    env.keyOff();
    baseDur - 40::ms => now;
}

fun play_kick() {
    TriOsc kick => Envelope e => dac;
    0.2 => kick.gain;
    55 => kick.freq;
    2::ms => e.duration;
    
    while (true) {
        one_kick(e);
        baseDur*4 => now;
        one_kick(e);
    }
}

spork ~ play_solo();
spork ~ play_snare();
spork ~ play_kick();

while (true) {
    1::samp => now;
}
