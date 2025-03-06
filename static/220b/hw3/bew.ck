@import "smuck"

public class Bew extends ezInstrument {
    setVoices(1);

    TriOsc osc => Gain g => Gain main => outlet;
    g => Delay delay => g;
    0.1 => osc.freq;
    0.0 => osc.gain;
    0.2 => main.gain;

    fun void update() {
        while (true) {
            osc.freq() * 0.9999 => osc.freq;
            if (osc.freq() < 10) {
                0.2*osc.freq()/10 => main.gain;
            } else {
                0.2 => main.gain;
            }
            samp => now;
        }
    }
    spork ~ update();

    fun void noteOn(ezNote note, int voice) {
        delay.clear();
        second/Std.mtof(note.pitch()) => delay.delay;
        Math.pow(0.999, delay.delay()/samp) => delay.gain;
        Std.mtof(note.pitch())*4 => osc.freq;
        note.velocity() => osc.gain;
    }

    fun void noteOff(ezNote note, int voice) {}
}

fun void test() {
    ezScore score("k1f c4|q cd bu|e a|q f|e e g|q c4");
    score.parts[0].measures[0].printNotes();
    ezScorePlayer player(score);
    Bew bew => Dyno dy => dac;
    dy.limit();
    player.setInstrument(0, bew);
    player.play();
    eon => now;
}
test();
