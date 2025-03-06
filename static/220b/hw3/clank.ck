@import "smuck"

public class Clank extends ezInstrument {
    10 => int n_voices;
    setVoices(n_voices);

    SndBuf buf(me.dir() + "../../recs/clank_mono.wav");
    LiSa lisa[n_voices] => ADSR adsr[n_voices] => LPF lpf[n_voices] => PRCRev rev => outlet;
    .05 => rev.mix;
    SinOsc lfo => blackhole; 3.1415 => lfo.freq;
    1920::samp => dur st;
    for (int v; v < n_voices; v++) {
        buf.samples()::samp => lisa[v].duration;

        for (int i; i < buf.samples(); i++) {
            lisa[v].valueAt(buf.valueAt(i), i::samp);
        }

        adsr[v].set(10::ms, 5::second, 0.0, 10::ms);

        0 => lisa[v].loop;
        1 => lisa[v].bi;
        1 => lisa[v].play;
    }

    fun void update() {
        while (true) {
            for (int v; v < n_voices; v++) {
                lfo.last()*100 + 1300 => lpf[v].freq;
                0.995*lisa[v].gain() => lisa[v].gain;
            }
            10::ms => now;
        }
    }
    spork ~ update();

    fun void noteOn(ezNote note, int voice) {
        st => lisa[voice].loopStart;
        second/Std.mtof(note.pitch()) + st => lisa[voice].loopEnd;
        0 => lfo.phase;
        1 => lisa[voice].gain;
        adsr[voice].keyOn();
    }

    fun void noteOff(ezNote note, int voice) {
        adsr[voice].keyOff();
    }
}

fun void test() {
    ezScore score("k1f c4|q cd bu|e a|q f|e e g|q c4:e:g:b|h fd:cu:f:a|w");
    ezScorePlayer player(score);
    Clank clank => Dyno dy => dac;
    dy.limit();
    player.setInstrument(0, clank);
    player.play();
    eon => now;
}
test();
