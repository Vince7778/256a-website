@import "smuck"

public class FryingPan extends ezInstrument {
    setVoices(3);

    // send a4 for kick, b4 for snare, c5 for ding
    SndBuf kick(me.dir() + "../../recs/pan-03.wav", 0.8, 1000000) => LPF lpf => Gain gk => outlet;
    SndBuf snare(me.dir() + "../../recs/pan-02.wav", 1.0, 1000000) => Gain gs => outlet;
    SndBuf ding(me.dir() + "../../recs/pan-01.wav", 1.0, 1000000) => Gain gd => outlet;
    600 => lpf.freq;
    3 => gk.gain;
    1.5 => gs.gain;
    1.5 => gd.gain; // recordings are a bit quiet

    fun void noteOn(ezNote note, int voice) {
        // velocity gives odds note will play (1.0 = certain)
        if (Math.randomf() > note.velocity()) return;
        SndBuf @ whichBuf;
        if (note.pitch() == 72) {
            ding @=> whichBuf;
        } else if (note.pitch() == 69) {
            kick @=> whichBuf;
        } else if (note.pitch() == 71) {
            snare @=> whichBuf;
        } else {
            <<< "FryingPan does not support note", note.pitch() >>>;
            return;
        }
        0 => whichBuf.pos;
        note.velocity() => whichBuf.gain;
    }

    fun void noteOff(ezNote note, int voice) {}
}

fun void test() {
    ezPart drums("a a b:c|e a|q b|e a|q a b:c");
    ezScore score;
    score.addPart(drums);
    ezScorePlayer player(score);
    FryingPan fp => Dyno dy => dac;
    player.setInstrument(0, fp);
    player.play();
    eon => now;
}
test();
