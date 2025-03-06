@import "smuck"

// very simple just pitch shifted but it sounds funny
public class MouthClick extends ezInstrument {
    5 => int n_voices;
    setVoices(n_voices);

    225 => float baseFreq;

    SndBuf buf[n_voices] => PitShift ps[n_voices] => outlet;
    for (int v; v < n_voices; v++) {
        me.dir() + "../../recs/mouth_click.wav" => buf[v].read;
        buf[v].samples() => buf[v].pos;
        1.0 => ps[v].mix;
    }

    fun void noteOn(ezNote note, int v) {
        0 => buf[v].pos;
        Std.mtof(note.pitch()) / baseFreq => ps[v].shift;
        Math.random2f(0.9, 1.1) => buf[v].gain; // more variation
    }

    fun void noteOff(ezNote note, int v) {}
}

fun void test() {
    ezScore score("k1f c4|q cd bu|e a|q f|e e g|q c4:e:g:b|h fd:cu:f:a|w");
    ezScorePlayer player(score);
    MouthClick mc => Dyno dy => dac;
    dy.limit();
    player.setInstrument(0, mc);
    player.play();
    eon => now;
}
test();
