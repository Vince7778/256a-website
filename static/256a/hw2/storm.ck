// AUDIO GENERATION STUFF

// this is input for the graphics side
UGen stormAudio;
stormAudio => UGen dacOut => dac;
0.2 => dacOut.gain;

// put stuff into this for reverb!
JCRev stormRev => stormAudio;
0.1 => stormRev.mix;

// audio constants
0.4 => float RAIN_MAX_GAIN;
0.4 => float THUNDER_GAIN;
0.8 => float STAGE5_GAIN;
1 => float STAGE6_GAIN;
0.5 => float STAGE7_GAIN;

40::ms => dur KICK_LEN;
40::ms => dur SNARE_LEN;

// audio to graphics variables
0.0 => float cloudBrightness;
0.0 => float skyBrightness;
@(0,0,0)/255.0 => vec3 SKY_COLOR; // after daytime shift
@(0.1, 0.1, 0.1) => vec3 BALL_COLOR;
false => int raiseClouds;
now => time cloudRaiseStart;
now => time cloudRaiseEnd;
1.0 => float cloudRaiseSpeed;
1::second => dur cloudWiggleRate;

// lightning fade time
350::ms => dur BASE_FADE; // default: 400 ms

// strike threshold
0.12 => float THRESHOLD; // default: 0.12

// whether to draw colored blocks going back from lightning strike
0 => int drawBackLines;

// stages
// times may be set lower for debugging
5::second => dur rainFadeTime; // default: 5 secs
5::second => dur thunderTime; // default: 5 secs
3::second => dur thunderFadeTime; // default: 3 secs

// stage beat length
350::ms => dur BEAT3; // default: 350ms
350::ms => dur BEAT4; // default: 350ms
350::ms => dur BEAT5;
350::ms => dur BEAT6;
350::ms => dur BEAT7;

CNoise rain("pink");
false => int stopRain;

fun playThunder() {
    SndBuf thunder("thunder.wav", 1.0, 51900);
    THUNDER_GAIN => thunder.gain;
    thunder => stormAudio;

    thunderTime => now;

    now => time startTime;
    now + thunderFadeTime => time endTime;
    while (now <= endTime) {
        1::samp => now;
        (now - startTime) / (endTime - startTime) => float progress;
        THUNDER_GAIN * (1 - progress) => thunder.gain;
    }

    thunder =< stormAudio;
}

5 => int numBloopers;
Osc bloopers[0];

Envelope blooperEnvs[0];
for (int i; i < numBloopers; i++) {
    bloopers << new TriOsc();
    bloopers[i] => Envelope blooperEnv => stormRev;
    10::ms => blooperEnv.duration;
    blooperEnvs << blooperEnv;
}
fun bloop(int ind, int note, dur onDur, float gain) {
    Std.mtof(note) => bloopers[ind].freq;
    gain => bloopers[ind].gain;
    blooperEnvs[ind].keyOn();
    onDur => now;
    blooperEnvs[ind].keyOff();
}

// bloop with gain fade
fun bloopWavy(int ind, int note, dur onDur, float startGain, float endGain) {
    Std.mtof(note) => bloopers[ind].freq;
    1 => bloopers[ind].gain;
    blooperEnvs[ind].keyOn();

    now => time startTime;
    now + onDur => time endWavyTime;
    while (now < endWavyTime) {
        1::samp => now;
        (now - startTime) / (endWavyTime - startTime) => float progress;
        startGain + (endGain - startGain) * progress => bloopers[ind].gain;
    }

    blooperEnvs[ind].keyOff();
}

[ 36, 55, 63, 67, 63, 55, 36, 55, 63, 67, 63, 55,
  35, 55, 62, 67, 62, 55, 35, 55, 62, 67, 62, 55,
  34, 53, 62, 67, 62, 53, 34, 53, 62, 67, 62, 53,
  33, 53, 60, 65, 60, 53,
  35, 55, 62, 67, 62, 55 ] @=> int stage3Notes[];

[ 39, 58, 63, 67, 63, 58, 39, 58, 63, 67, 63, 58,
  34, 58, 62, 65, 62, 58, 34, 58, 62, 65, 62, 58,
  32, 56, 60, 63, 60, 56, 32, 56, 60, 63, 60, 56,
  39, 58, 63, 67, 63, 58,
  34, 58, 62, 65, 62, 58 ] @=> int stage6Notes[];

fun bloopLine(int notes[], dur beat, float gain) {
    for (int i; i < notes.size(); i++) {
        notes[i] => int note;
        if (note < 48) {
            spork ~ bloopWavy(0, note, beat*5.5, 2.2*gain, 0.8*gain);
        } else {
            spork ~ bloop(1, note, beat/4, gain);
        }
        beat => now;
    }
    // just wait a bit for extra shreds to exit
    10*beat => now;
}

Rhodey rhodey => stormRev;
2 => rhodey.gain;
200::ms => dur rhodeyBufferTime;
fun rhode(int note, dur onDur) {
    rhodeyBufferTime => dur bt;
    if (onDur < bt) {
        0.2 * onDur => bt;
    }
    Std.mtof(note) => rhodey.freq;
    rhodey.noteOn(0.5);
    onDur - bt => now;
    rhodey.noteOff(0.5);
}

TriOsc kick => Envelope kickEnv;
1.6 => kick.gain;
55 => kick.freq;
2::ms => kickEnv.duration;

Noise snare => Envelope snareEnv;
0.2 => snare.gain;
2::ms => snareEnv.duration;

fun playEnv(Envelope e, dur len) {
    e.keyOn();
    len => now;
    e.keyOff();
}

// six beats per rep
fun playDrums(int reps, dur beat) {
    for (int m; m < reps; m++) {
        spork ~ playEnv(kickEnv, KICK_LEN);
        2 * beat => now;
        if (Math.randomf() < 0.5) {
            spork ~ playEnv(kickEnv, KICK_LEN);
        }
        beat => now;
        spork ~ playEnv(snareEnv, SNARE_LEN);
        2 * beat => now;
        if (Math.randomf() < 0.5) {
            spork ~ playEnv(kickEnv, KICK_LEN);
        }
        beat => now;
    }
}

fun fadeOutRain(dur len) {
    now => time startTime;
    now + rainFadeTime => time endTime;
    while (now <= endTime) {
        1::samp => now;
        (now - startTime) / (endTime - startTime) => float progress;
        (1 - progress) * RAIN_MAX_GAIN => rain.gain;
    }
}

fun transitionToDay(dur len) {
    now => cloudRaiseStart;
    true => raiseClouds;

    now => time startTime;
    now + len => time endTime;
    while (now <= endTime) {
        1::samp => now;
        (now - startTime) / (endTime - startTime) => float progress;
        Math.max(0.0, progress-0.5)*2 => skyBrightness;
        0.1 + progress/20 => stormRev.mix;
    }

    now => cloudRaiseEnd;
}

fun doAudio() {
    // secret stage 0: 2 second delay for recording
    2::second => now;

    // stage 1: rain fade in
    0.0 => rain.gain;
    rain => stormAudio;

    now => time startTime;
    now + rainFadeTime => time endTime;
    while (now <= endTime) {
        1::samp => now;
        (now - startTime) / (endTime - startTime) => float progress;
        progress => cloudBrightness;
        progress * RAIN_MAX_GAIN => rain.gain;
    }

    // stage 2: thunder noises

    // raise threshold to prevent early strike
    100 => THRESHOLD;

    spork ~ playThunder();
    thunderTime + thunderFadeTime => now;

    // stage 3: blooping begins
    0.15 => THRESHOLD;

    spork ~ playThunder();
    spork ~ bloopLine(stage3Notes, BEAT3, 0.8);
    stage3Notes.size() * BEAT3 => now;

    // stage 4: piano!

    0.25 => THRESHOLD;

    // randomly choose from sets of notes
    [ [72, 74, 75, 79], [72, 74, 75, 79],
      [67, 71, 74, 79], [67, 71, 74, 79],
      [70, 74, 75, 77], [70, 74, 75, 77],
      [69, 70, 72, 77], [67, 71, 74, 79] ] @=> int stage4Notes[][];

    // run it twice
    for (int pianoIter; pianoIter < 2; pianoIter++) {
        spork ~ bloopLine(stage3Notes, BEAT4, 0.4);

        for (int i; i < stage4Notes.size(); i++) {
            for (int rep; rep < 2; rep++) {
                int choices[3];
                for (int j; j < 3; j++) {
                    Math.random2(0, stage4Notes[i].size()-1) => int ind;
                    stage4Notes[i][ind] => choices[j];
                }

                // pattern 1
                Math.randomf() => float rand;
                if (rand < 0.4) {
                    spork ~ rhode(choices[0], 3 * BEAT4);
                    3 * BEAT4 => now;
                } else if (rand < 0.8) {
                    for (int j; j < 3; j++) {
                        spork ~ rhode(choices[j], BEAT4);
                        BEAT4 => now;
                    }
                } else {
                    spork ~ rhode(choices[0], 2 * BEAT4);
                    2 * BEAT4 => now;
                    spork ~ rhode(choices[1], BEAT4);
                    BEAT4 => now;
                }
            }
        }
    }

    // stage 5: bridge to happy part

    spork ~ rhode(72, 6*BEAT5);
    spork ~ transitionToDay(12*BEAT5);

    // fractional part represents duration
    [ 36.6, 55.1, 63.1, 67.1, 63.1, 55.1, 
      36.3, 0, 0, 34.1, 36.1, 38.1 ] @=> float stage5Notes[];
    for (int i; i < stage5Notes.size(); i++) {
        if (i == 6) {
            100 => THRESHOLD;
            true => stopRain;
            spork ~ fadeOutRain(BEAT5 * 6);
        }

        Math.floor(stage5Notes[i]) $ int => int note;
        (stage5Notes[i] - note) * 10 => float noteDur;
        if (note <= 0) {
            BEAT5 => now;
            continue;
        }
        if (note < 48) {
            spork ~ bloopWavy(0, note, BEAT5*(noteDur-0.2), 2.2*STAGE5_GAIN, 0.8*STAGE5_GAIN);
        } else {
            spork ~ bloop(1, note, BEAT5/4, STAGE5_GAIN);
        }
        BEAT5 => now;
    }

    // stage 6: happy!

    0.25 => THRESHOLD;

    spork ~ playDrums(16, BEAT6);

    [ [70, 75, 77, 79], [70, 75, 77, 79],
      [70, 72, 74, 77], [70, 72, 74, 77],
      [68, 70, 72, 75], [68, 70, 72, 74, 75],
      [67, 70, 75],     
      [68, 70, 74, 77] ] @=> int stage6PianoNotes[][];
    for (int pianoIter; pianoIter < 2; pianoIter++) {
        spork ~ bloopLine(stage6Notes, BEAT6, 0.4);

        for (int i; i < stage6PianoNotes.size(); i++) {
            for (int rep; rep < 2; rep++) {
                int choices[3];
                for (int j; j < 3; j++) {
                    Math.random2(0, stage6PianoNotes[i].size()-1) => int ind;
                    stage6PianoNotes[i][ind] => choices[j];
                }

                // pattern 1
                Math.randomf() => float rand;
                if (rand < 0.4) {
                    spork ~ bloop(2, choices[0], 2.5 * BEAT6, STAGE6_GAIN);
                    3 * BEAT6 => now;
                } else if (rand < 0.8) {
                    for (int j; j < 3; j++) {
                        spork ~ bloop(2, choices[j], 0.5*BEAT6, STAGE6_GAIN);
                        BEAT6 => now;
                    }
                } else {
                    spork ~ bloop(2, choices[0], 1.5 * BEAT6, STAGE6_GAIN);
                    2 * BEAT6 => now;
                    spork ~ bloop(2, choices[1], 0.5*BEAT6, STAGE6_GAIN);
                    BEAT6 => now;
                }
            }
        }
    }

    // stage 7: ending
    spork ~ bloop(2, 75, 4*BEAT7, STAGE6_GAIN);

    [ 39, 58, 63, 67, 63, 58 ] @=> int stage7Notes[];
    spork ~ bloopLine(stage7Notes, BEAT7, STAGE7_GAIN);

    6*BEAT7 => now;
    spork ~ bloop(0, 39, 11*BEAT7, STAGE7_GAIN*1.7);

    [58, 63, 67] @=> int endingTriad[];
    [1, 3, 4] @=> int endingBloopers[];
    for (int i; i < endingBloopers.size(); i++) {
        BEAT7/3 => now;
        STAGE7_GAIN => float gain;
        if (i == 2) {
            // high note is too loud
            0.7 *=> gain;
        }
        spork ~ bloop(endingBloopers[i], endingTriad[i], (33.0-i)/3*BEAT7, gain);
    }

    // manual fade out of bloopers
    now => startTime;
    now + 6*BEAT7 => endTime;
    while (now < endTime) {
        1::samp => now;
        (now - startTime) / (endTime - startTime) => float progress;
        1.7*(1-progress)*STAGE7_GAIN => bloopers[0].gain;
        for (1 => int i; i < bloopers.size(); i++) {
            (1-progress)*STAGE7_GAIN => bloopers[i].gain;
            if (i == 4) {
                Math.max(0.0, (1-progress*2)*STAGE7_GAIN) => bloopers[i].gain;
            }
        }
    }

    while (true) {
        1::ms => now;
    }
}
spork ~ doAudio();







//      GRAPHICS AND OTHER STUFF

2048 => int WINDOW_SIZE;
64 => int NUM_BARS;
56 => int NUM_WAVES;
0.5 => float INTERP_AMOUNT; // lower = more

300::ms => dur BASE_TIMEOUT;
11 => float SKY_HEIGHT;
16 => float CLOUD_HEIGHT;
16 => float CLOUD_RADIUS;
0.1 => float LINE_WIDTH;
0.7 => float CLOUD_BRIGHT;
1.0/20 => float CLOUD_FLASH_COLOR;
0.01 => float CLOUD_INTERP;
20 => float CLOUD_AMP;
3 => float CLOUD_SPEED;

-3 => float FLOOR_POS;
// max height of a sound bar
3 => float MAX_HEIGHT;
// left/rightmost sound bar x
5 => float SIDE_POS;
-18 => float INITIAL_DEPTH;
2*SIDE_POS / (NUM_BARS - 1) => float BAR_WIDTH;
2*BAR_WIDTH => float BAR_DEPTH;

100 => float BALL_COUNT;

@(0.2, 0.2, 0.2) => vec3 CUBE_COLOR;

GWindow.title("storm");
// uncomment to fullscreen
GWindow.fullscreen();

GG.renderPass() --> BloomPass bloom_pass --> GG.outputPass();
bloom_pass.input( GG.renderPass().colorOutput() );
GG.outputPass().input( bloom_pass.colorOutput() );

bloom_pass.intensity(0.4);
bloom_pass.radius(0.2);
bloom_pass.levels(5);

// ------ scene + background setup ------
GG.scene().camera() @=> GCamera camera;
camera.rotX(-0.1);

// GPlane floor --> GG.scene();
// floor.pos(@(0, FLOOR_POS, 0));
// floor.rotX(pi/2);
// floor.sca(@(100, 100, 1));
// floor.color(@(0, 1, 0));

// GPlane cubeFloor --> GG.scene();
// cubeFloor.pos(@(0, FLOOR_POS+0.001, 0));
// cubeFloor.rotX(pi/2);
// cubeFloor.sca(@(SIDE_POS*2 + BAR_WIDTH, 100, 1));
// cubeFloor.color(CUBE_COLOR*2);

// GPlane skybox --> GG.scene();
// skybox.pos(@(0, 0, -60));
// skybox.sca(@(1000, 1000, 1));
// skybox.color(BALL_COLOR);
// skybox.aoFactor(0);

GG.scene().light() @=> GLight skyLight;
skyLight.rotX(-0.01);
0.2 => skyLight.intensity;

// GDirLight dayLight;
// dayLight.rot(@(5*pi/8, 0, pi/4));
// 0 => dayLight.intensity;
// dayLight --> GG.scene();

// cloud balls
fun float sampleNormal() {
    1 - Math.randomf() => float u;
    Math.randomf() => float v;
    return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
}

SphereGeometry cloudGeo;
PhongMaterial cloudMat;
cloudMat.color(cloudBrightness * BALL_COLOR);
cloudMat.aoFactor(0);

GMesh clouds[0];
for (-20 => int zz; zz >= -80; 9 -=> zz) {
    for (-80 => int xx; xx <= 80; 6 +=> xx) {
        GMesh ball(cloudGeo, cloudMat) --> GG.scene();
        zz + sampleNormal() => float ballZ;
        xx + sampleNormal() => float ballX;
        sampleNormal() * 0.5 + CLOUD_HEIGHT => float ballY;
        sampleNormal() * 0.5 + CLOUD_RADIUS => float ballR;
        ball.pos(@(ballX, ballY, ballZ));
        ball.sca(@(ballR, ballR, ballR));
        clouds << ball;
    }
}

PhongMaterial whiteCloudMat;
whiteCloudMat.color(@(1.2, 1.2, 1.2));
cloudMat.aoFactor(0);

GMesh whiteClouds[0];
float originalCloudY[0];
for (-SIDE_POS-2 => float xx; xx <= SIDE_POS+2; 0.5 +=> xx) {
    GMesh ball(cloudGeo, whiteCloudMat) --> GG.scene();
    xx + sampleNormal()/2 => float ballX;
    INITIAL_DEPTH + sampleNormal()/2 => float ballZ;
    sampleNormal() * 0.2 + 2.6*SKY_HEIGHT => float ballY;
    sampleNormal() * 0.3 + CLOUD_RADIUS/5 => float ballR;
    ball.pos(@(ballX, ballY, ballZ));
    ball.sca(@(ballR, ballR, ballR));
    whiteClouds << ball;
    originalCloudY << ballY;
}

// ------ lightning stuff ------

fun vec2 randomNextPos(vec2 cur) {
    // get random segment length
    Std.clampf(sampleNormal()*0.3 + 0.2, 0.1, 1) => float len;
    // get random angle
    sampleNormal()*pi/6 + pi/2 => float angle;
    cur.x + Math.cos(angle) * len => float dx;
    cur.y + Math.sin(angle) * len => float dy;
    return @(dx, dy);
}

float heights[NUM_BARS];
float heightsDiff[NUM_BARS];
float potential[NUM_BARS];
class Lightning extends GGen {
    GLines lines;
    GLines white; // inner white part
    BASE_FADE => dur fadeTime;
    int detached;
    vec3 color;

    vec2 positions[0];
    @(0, 0) => vec2 curPos;
    positions << curPos;
    while (curPos.y < SKY_HEIGHT) {
        randomNextPos(curPos) => curPos;
        positions << curPos;
    }

    lines.positions(positions);
    lines.width(LINE_WIDTH);
    lines --> this;

    white.positions(positions);
    white.posZ(lines.posZ() + 0.001);
    white.color(@(1, 1, 1));
    white.width(LINE_WIDTH * 0.4);
    white --> this;

    fun update(float dt) {
        if (detached) return;

        dt::second -=> fadeTime;
        if (fadeTime < 0::samp) {
            detach();
            1 => detached;
            return;
        }

        fadeTime / BASE_FADE => float fadeRatio;
        skyBrightness * SKY_COLOR => vec3 skyColor;
        (color + (1 - fadeRatio) * (skyColor - color)) => lines.color;
        (@(1, 1, 1) + (1 - fadeRatio) * (skyColor - @(1, 1, 1))) => white.color;

        // prevent z-fighting
        lines.posZ(fadeRatio*0.005);
        white.posZ(lines.posZ()+0.001);
    }
}

Lightning lnings[0];

// ------ sound wave stuff ------

CubeGeometry cubeGeo;
PhongMaterial matDark[NUM_BARS];
PhongMaterial matMid[NUM_BARS];
PhongMaterial matLight[NUM_BARS];

PlaneGeometry backWaveGeo;
GMesh backWaves[0];
-100 => float backZ;
for (int i; i < NUM_BARS; i++) {
    Color.hsv2rgb(@(i*360.0/NUM_BARS, 1, 1)) => vec3 color;
    matDark[i].color(color / 10);

    Color.hsv2rgb(@(i*360.0/NUM_BARS, 0.7, 0.2)) => vec3 midColor;
    matMid[i].color(midColor);
    matMid[i].aoFactor(0);
    
    matLight[i].color(color);
    matLight[i].shine(100);
    
    GMesh plane(backWaveGeo, matMid[i]);
    (i $ float) / (NUM_BARS-1) => float iRatio;
    plane.posX(SIDE_POS * (2*iRatio-1)/2);
    plane.posY(FLOOR_POS);
    plane.posZ((backZ + INITIAL_DEPTH) / 2);
    plane.scaX(BAR_WIDTH);
    plane.scaY(INITIAL_DEPTH - backZ);
    plane.rotX(pi/2);

    // cheat a lil to make it look like they converge
    plane.rotY((2*iRatio-1)/16.5);
    plane --> GG.scene();
    backWaves << plane;
}

class SoundBar extends GGen {
    GMesh cube(cubeGeo, matDark[0]);
    int colorInd;

    cube.sca(@(BAR_WIDTH, 0, BAR_DEPTH));
    cube --> this;

    int lightOn;
    GPointLight light;
    
    BAR_WIDTH*5 => light.radius;
    10 => light.intensity;

    fun setHeight(float height) {
        cube.scaY(height * MAX_HEIGHT);
        light.posY(height * MAX_HEIGHT / 2 + BAR_WIDTH / 2);
        light.posZ(BAR_DEPTH);
    }

    fun setLightColor(int ind) {
        light.color(matLight[ind].color());
        cube.material(matDark[ind]);
        ind => colorInd;
    }

    fun activate(int lightning) {
        if (!lightOn) {
            cube.material(matLight[colorInd]);

            if (lightning) {
                light --> this; // light may be disabled due to performance issues
                10 => light.intensity;
                Lightning lning;
                lning.pos(posLocalToWorld(@(0, cube.scaY() / 2, 0)));
                lning.posZ(INITIAL_DEPTH);
                light.color() => lning.color;
                lning --> GG.scene();
                lnings << lning;
                1 => lightOn;
            }
        }
    }

    fun reset() {
        if (lightOn) {
            light --< this;
            0 => lightOn;
        }
        cube.material(matDark[colorInd]);
    }
}

class SoundWave extends GGen {
    SoundBar bars[NUM_BARS];
    for (int i; i < NUM_BARS; i++) {
        bars[i] @=> SoundBar bar;
        bar --> this;
        (i $ float) / (NUM_BARS-1) => float iRatio;
        bar.posX(SIDE_POS*(2*iRatio-1));
        bar.setLightColor(i);
    }

    fun setHeights(float heights[]) {
        for (int i; i < NUM_BARS; i++) {
            bars[i].setHeight(heights[i]);
        }
    }

    // Resets lights, not heights
    fun reset() {
        for (SoundBar bar : bars) {
            bar.reset();
        }
    }

    fun strike(int pos, int lightning) {
        bars[pos].activate(lightning);
    }
}

class Waterfall extends GGen {
    0 => int playhead;
    SoundWave waves[NUM_WAVES];

    int striking[NUM_BARS];

    for (SoundWave wave : waves) {
        wave --> this;
    }

    fun latest(float heights[]) {
        playhead++;
        NUM_WAVES %=> playhead;
        waves[playhead].reset();
        waves[playhead].setHeights(heights);
        for (int i; i < NUM_BARS; i++) {
            if (striking[i]) {
                if (heightsDiff[i] < 0) {
                    false => striking[i];
                } else {
                    waves[playhead].strike(i, false);
                }
            }
        }
    }

    fun strike(int pos) {
        for (-1 => int i; i <= 1; i++) {
            if (pos + i >= 0 && pos + i < NUM_BARS) {
                waves[playhead].strike(pos+i, i == 0);
            }
        }
        if (drawBackLines) {
            true => striking[pos];
        }
    }

    fun update(float dt) {
        playhead => int pos;
        for (int i; i < NUM_WAVES; i++) {
            waves[pos].posZ(i * BAR_DEPTH);
            waves[pos].scaY((NUM_WAVES-i)*1.0/NUM_WAVES);
            pos--; if (pos < 0) waves.size()-1 => pos;
        }
    }
}

Waterfall wfall --> GG.scene();
wfall.pos(@(0, FLOOR_POS, INITIAL_DEPTH));

// ------ audio stuff ------

stormAudio => UGen input;
// new SndBuf("test_song3.wav", 1, 15*44100) => UGen input => dac;
.8 => input.gain;

// spectrum
input => PoleZero dcbloke => FFT fft => blackhole;
.95 => dcbloke.blockZero;
Windowing.hann(WINDOW_SIZE) => fft.window;
WINDOW_SIZE*2 => fft.size;
complex response[0];

// waveform
input => Flip accum => blackhole;
WINDOW_SIZE => accum.size;
Windowing.hann(WINDOW_SIZE) @=> float window[];
float samples[0];

fun doAudioCalc() {
    while (true) {
        fft.upchuck();
        fft.spectrum( response );
        accum.upchuck();
        accum.output(samples);
        WINDOW_SIZE::samp/2 => now;
    }
}
spork ~ doAudioCalc();

[0.04, 0.16, 0.6, 0.16, 0.04] @=> float gaussKernel[];
fun gaussSmooth(float in[], float out[]) {
    for (int i; i < out.size(); i++) {
        0 => out[i];
        for (-2 => int j; j <= 2; j++) {
            i + j => int ind;
            if (i + j >= 0 && i + j < in.size()) {
                in[ind] * gaussKernel[j+2] +=> out[i];
            }
        }
    }
}

float samplesSmooth[WINDOW_SIZE];
float cloudBins[WINDOW_SIZE];
fun updateClouds() {
    while (true) {
        GG.nextFrame() => now;

        // interpolate and recalculate cloud bins
        gaussSmooth(samples, samplesSmooth);
        for (int i; i < WINDOW_SIZE; i++) {
            samplesSmooth[i] * CLOUD_AMP * window[i] => float val;
            (val - cloudBins[i]) * CLOUD_INTERP +=> cloudBins[i];
        }

        GG.dt() * CLOUD_SPEED => float moveAmt;
        for (GMesh cloud : clouds) {
            if (!raiseClouds) {
                cloud.posZ() + moveAmt => cloud.posZ;
                if (cloud.posZ() > -20) {
                    cloud.posZ() - 54 => cloud.posZ;
                }
            }

            cloud.posX() / cloud.posZ() => float approxX;
            Math.floor((approxX + 1.2) / 2.4 * WINDOW_SIZE) $ int => int bin;
            Std.clamp(bin, 0, WINDOW_SIZE-1) => bin;

            CLOUD_HEIGHT => float baseY;
            if (cloud.posZ() <= -60) {
                (-cloud.posZ() - 60)/3 +=> baseY;
            }
            if (raiseClouds) {
                (now - cloudRaiseStart) / 1::second => float amt;
                amt * amt * cloudRaiseSpeed +=> baseY;
            }
            cloud.posY(baseY-cloudBins[bin]);
        }

        for (int i; i < whiteClouds.size(); i++) {
            float newY;
            if (skyBrightness < 1) {
                originalCloudY[i] - SKY_HEIGHT * 2 * (1-(1-skyBrightness) * (1-skyBrightness)) => newY;
            } else {
                originalCloudY[i] - SKY_HEIGHT * 2 + Math.sin((now - cloudRaiseEnd) / cloudWiggleRate) => newY;
            }
            Math.floor((i * 1.0 / whiteClouds.size()) * WINDOW_SIZE) $ int => int bin;
            newY - cloudBins[bin] => newY;
            whiteClouds[i].posY(newY);
        }
    }
}
spork ~ updateClouds();

// convert fft output to the bar heights
// take log of frequency and magnitude
fun discretize(complex in[], float out[]) {
    for (int i; i < NUM_BARS; i++) {
        0 => out[i];
    }
    -1 => int prevBin;
    for (1 => int i; i < WINDOW_SIZE; i++) {
        Math.floor(Math.log(i) / Math.log(WINDOW_SIZE) * NUM_BARS) $ int => int bin;

        // fill in bins that were skipped
        if (prevBin <= bin-2) {
            for (prevBin+1 => int j; j < bin; j++) {
                out[prevBin] => out[j];
            }
        }

        10 * Math.sqrt((in[i]$polar).mag) => float sampleVal;
        if (sampleVal > out[bin]) {
            sampleVal => out[bin];
        }
        bin => prevBin;
    }
}

fun interpolate(float in[], float out[], float outDiff[]) {
    for (int i; i < in.size(); i++) {
        (in[i] - out[i]) * INTERP_AMOUNT => outDiff[i];
        outDiff[i] +=> out[i];
    }
}

fun doLightning() {
    1::second => dur timeout; // base delay
    while (true) {
        now => time oldTime;
        GG.nextFrame() => now;
        now - oldTime => dur dt;

        // clear old lightning strikes
        // also recalculate cloud color
        0.0 => float maxBright;
        @(0, 0, 0) => vec3 sumColor;
        for (lnings.size()-1 => int i; i >= 0; i--) {
            if (lnings[i].detached) {
                lnings.erase(i);
            } else {
                lnings[i].fadeTime / BASE_FADE => float brightness;
                if (brightness > maxBright) {
                    brightness => maxBright;
                }
                // <<< brightness >>>;
                lnings[i].color * brightness +=> sumColor;
            }
        }
        maxBright * CLOUD_BRIGHT + 1.0 => float cloudBright;
        cloudMat.color((BALL_COLOR + sumColor*CLOUD_FLASH_COLOR) * cloudBright * cloudBrightness);

        for (int i; i < NUM_BARS; i++) {
            if (heightsDiff[i] > 0) {
                heightsDiff[i] +=> potential[i];
            } else {
                heightsDiff[i] / 2 +=> potential[i];
            }
            Math.max(0, potential[i] - 0.1) => potential[i];
        }
        
        dt -=> timeout;
        if (timeout > 0::samp) {
            continue;
        }

        // find maximum element and index
        int maxInd; float maxVal;
        for (int i; i < NUM_BARS; i++) {
            if (potential[i] > maxVal) {
                potential[i] => maxVal;
                i => maxInd;
            }
        }
        
        // <<< maxVal >>>;
        if (maxVal >= THRESHOLD) {
            // <<< "Lightning strike at", maxInd >>>;
            wfall.strike(maxInd);
            0 => potential[maxInd];

            BASE_TIMEOUT => timeout;
        }
    }
}
spork ~ doLightning();

fun setRandomRainPos(GLines rain, float maxY) {
    Math.random2f(-25.0, 25.0) => rain.posX;
    Math.random2f(SKY_HEIGHT, SKY_HEIGHT+maxY) => rain.posY;
    Math.random2f(0.0, -30.0) => rain.posZ;
}

fun doRain() {
    1000 => int RAIN_COUNT; // default 1000
    @(0.4, 0.8, 0.8) => vec3 RAIN_COLOR;

    GLines rains[0];
    for (int i; i < RAIN_COUNT; i++) {
        GLines rain;
        rain.positions([@(0.0, 0.0), @(0.0, 0.2)]);
        setRandomRainPos(rain, 30.0);
        RAIN_COLOR * cloudBrightness => rain.color;
        0.005 => rain.width;
        rain --> GG.scene();
        rains << rain;
    }

    while (true) {
        GG.nextFrame() => now;
        for (GLines rain : rains) {
            RAIN_COLOR * cloudBrightness * cloudBrightness => rain.color;
            rain.posY(rain.posY() - 0.5);
            if (!stopRain && rain.posY() < -SKY_HEIGHT) {
                setRandomRainPos(rain, 2.0);
            }
        }
    }
}
spork ~ doRain();

// fps printer
// fun void printFPS( dur howOften )
// {
//     while( true )
//     {
//         <<< "fps:", GG.fps() >>>;
//         howOften => now;
//     }
// }
// spork ~ printFPS(.25::second);

// stars!
1000 => int NUM_STARS;

GPoints stars;
vec3 starPos[0];
for (int i; i < NUM_STARS; i++) {
    Math.random2f(-60, 60) => float starX;
    Math.random2f(-50, 30) => float starY;
    Math.random2f(-90, -80) => float starZ;
    starPos << @(starX, starY, starZ);
}

stars.positions(starPos);
stars.sizes([1.0, 2.0]);

stars.color(@(0, 0, 0));
stars --> GG.scene();

// interpolation is only used visually, for more accurate lightning strikes
float heightsUnsmooth[NUM_BARS];
float heightsInterp[NUM_BARS];
while (true) {
    GG.nextFrame() => now;

    GG.scene().backgroundColor(skyBrightness * skyBrightness * SKY_COLOR);
    for (int i; i < NUM_BARS; i++) {
        Color.hsv2rgb(@(i*360.0/NUM_BARS, 1, 1)) => vec3 color;
        matDark[i].color(color / 10 * (1 + 6*skyBrightness));

        Color.hsv2rgb(@(i*360.0/NUM_BARS, 0.7, 0.2 + 0.3*skyBrightness)) => vec3 midColor;
        matMid[i].color(midColor);
    }
    if (skyBrightness > 0) {
        skyBrightness/5 + 0.2 => skyLight.intensity;
        -0.01 + skyBrightness/70.0 => skyLight.rotX;
    }
    skyBrightness * @(1, 1, 1) => stars.color;

    // stars twinkly!!
    if (skyBrightness > 0) {
        vec3 starColors[0];
        for (int i; i < 7; i++) {
            Math.sin(i * (now - cloudRaiseStart)/3::second)*0.5 + 0.5 => float mult;
            starColors << mult * @(1, 1, 1);
        }
        stars.colors(starColors);
    }

    // skyBrightness * 10 => dayLight.intensity;

    discretize(response, heightsUnsmooth);
    interpolate(heightsUnsmooth, heightsInterp, heightsDiff);
    gaussSmooth(heightsInterp, heights);
    wfall.latest(heights);
}
