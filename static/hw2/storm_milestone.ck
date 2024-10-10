
1024 => int WINDOW_SIZE;
32 => int NUM_BARS;
16 => int NUM_WAVES;
0.5 => float INTERP_AMOUNT; // lower = more

0.1 => float MIN_THRESHOLD;
0.12 => float THRESHOLD;
0.5 => float MAX_THRESHOLD;
200::ms => dur BASE_TIMEOUT;
400::ms => dur BASE_FADE;
11 => float SKY_HEIGHT;
0.1 => float LINE_WIDTH;

-3 => float FLOOR_POS;
// max height of a sound bar
5 => float MAX_HEIGHT;
// left/rightmost sound bar x
5 => float SIDE_POS;
-10 => float INITIAL_DEPTH;
2*SIDE_POS / (NUM_BARS - 1) => float BAR_WIDTH;
2*BAR_WIDTH => float BAR_DEPTH;

100 => float BALL_COUNT;
@(0.1, 0.1, 0.1) => vec3 BALL_COLOR;

@(0.2, 0.2, 0.2) => vec3 CUBE_COLOR;

GWindow.title("storm");
// uncomment to fullscreen
// GWindow.fullscreen();

// GG.renderPass() --> BloomPass bloom_pass --> GG.outputPass();
// bloom_pass.input( GG.renderPass().colorOutput() );
// GG.outputPass().input( bloom_pass.colorOutput() );

// bloom_pass.intensity(0.6);
// bloom_pass.radius(0.4);
// bloom_pass.levels(5);

// ------ scene + background setup ------
GG.scene().camera() @=> GCamera camera;
camera.rotX(-0.1);

GPlane floor --> GG.scene();
floor.pos(@(0, FLOOR_POS, 0));
floor.rotX(pi/2);
floor.sca(@(100, 100, 1));
floor.color(@(0, 1, 0));

GPlane cubeFloor --> GG.scene();
cubeFloor.pos(@(0, FLOOR_POS+0.001, 0));
cubeFloor.rotX(pi/2);
cubeFloor.sca(@(SIDE_POS*2 + BAR_WIDTH, 100, 1));
cubeFloor.color(CUBE_COLOR*2);

GPlane skybox --> GG.scene();
skybox.pos(@(0, 0, -60));
skybox.sca(@(1000, 1000, 1));
skybox.color(BALL_COLOR);
skybox.aoFactor(0);

GG.scene().light() @=> GLight skyLight;
skyLight.rotX(-0.01);
0.2 => skyLight.intensity;

// cloud balls
fun float sampleNormal() {
    1 - Math.randomf() => float u;
    Math.randomf() => float v;
    return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
}

for (40 => int zz; zz >= -70; 10 -=> zz) {
    for (zz => int xx; xx <= -zz; 8 +=> xx) {
        GSphere ball --> GG.scene();
        zz + sampleNormal() => float ballZ;
        xx + sampleNormal() => float ballX;
        sampleNormal() * 0.5 + SKY_HEIGHT+10 => float ballY;
        sampleNormal() * 0.5 + 20 => float ballR;
        ball.pos(@(ballX, ballY, ballZ));
        ball.sca(@(ballR, ballR, ballR));
        ball.color(BALL_COLOR);
        ball.aoFactor(0);
    }
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
        color * fadeRatio => lines.color;
        @(1,1,1) * fadeRatio => white.color;

        // prevent z-fighting
        lines.posZ(fadeRatio*0.005);
        white.posZ(lines.posZ()+0.001);
    }
}

Lightning lnings[0];

// ------ sound wave stuff ------

class SoundBar extends GGen {
    GCube cube;
    vec3 color;

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

    fun setLightColor(vec3 _color) {
        _color => color;
        light.color(color);
        cube.color(color/10);
    }

    fun activate(int lightning) {
        if (!lightOn) {
            cube.color(color);
            cube.shine(100);

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
        cube.color(color/10);
        cube.shine(5);
    }
}

class SoundWave extends GGen {
    SoundBar bars[NUM_BARS];
    for (int i; i < NUM_BARS; i++) {
        bars[i] @=> SoundBar bar;
        bar --> this;
        (i $ float) / (NUM_BARS-1) => float iRatio;
        bar.posX(SIDE_POS*(2*iRatio-1));
        bar.setLightColor(Color.hsv2rgb(@(i*360.0/NUM_BARS, 1, 1)));
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
        waves[playhead].strike(pos, true);
        true => striking[pos];
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

// adc => UGen input;
new SndBuf("demo.wav") => UGen input => dac;
input => PoleZero dcbloke => FFT fft => blackhole;
.95 => dcbloke.blockZero;

Windowing.hann(WINDOW_SIZE) => fft.window;
WINDOW_SIZE*2 => fft.size;

complex response[0];

fun doAudio() {
    while (true) {
        fft.upchuck();
        fft.spectrum( response );
        WINDOW_SIZE::samp/2 => now;
    }
}
spork ~ doAudio();

// convert fft output to the bar heights
// take log of frequency and magnitude
fun discretize(complex in[], float out[]) {
    for (int i; i < NUM_BARS; i++) {
        0 => out[i];
    }
    for (1 => int i; i < WINDOW_SIZE; i++) {
        Math.floor(Math.log(i) / Math.log(WINDOW_SIZE) * NUM_BARS) $ int => int bin;
        10 * Math.sqrt((in[i]$polar).mag) => float sampleVal;
        if (sampleVal > out[bin]) {
            sampleVal => out[bin];
        }
    }
}

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

fun interpolate(float in[], float out[], float outDiff[]) {
    for (int i; i < in.size(); i++) {
        (in[i] - out[i]) * INTERP_AMOUNT => outDiff[i];
        outDiff[i] +=> out[i];
    }
}

now => time lastStrike;
0 => int recentStrikes;

fun doLightning() {
    1::second => dur timeout; // base delay
    while (true) {
        now => time oldTime;
        GG.nextFrame() => now;
        now - oldTime => dur dt;

        // clear old lightning strikes
        for (lnings.size()-1 => int i; i >= 0; i--) {
            if (lnings[i].detached) {
                lnings.erase(i);
            }
        }

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

            now => lastStrike;
            1 +=> recentStrikes;

            BASE_TIMEOUT => timeout;
        }
    }
}
spork ~ doLightning();

fun adjustThreshold() {
    while (true) {
        now - lastStrike => dur strikeTime;
        if (strikeTime > 4.0 * BASE_TIMEOUT) {
            // not enough lightning
            Std.clampf(THRESHOLD / 1.1, MIN_THRESHOLD, MAX_THRESHOLD) => THRESHOLD;
        }
        if (GG.fps() < 40 || recentStrikes >= 2) {
            // too much lightning
            Std.clampf(THRESHOLD * 1.1, MIN_THRESHOLD, MAX_THRESHOLD) => THRESHOLD;
        }
        // <<< THRESHOLD >>>;
        0 => recentStrikes;
        BASE_TIMEOUT => now;
    }
}
// spork ~ adjustThreshold();

// fps printer
fun void printFPS( dur howOften )
{
    while( true )
    {
        <<< "fps:", GG.fps() >>>;
        howOften => now;
    }
}
spork ~ printFPS(.25::second);

// interpolation is only used visually, for more accurate lightning strikes
float heightsUnsmooth[NUM_BARS];
float heightsInterp[NUM_BARS];
while (true) {
    GG.nextFrame() => now;

    discretize(response, heightsUnsmooth);
    interpolate(heightsUnsmooth, heightsInterp, heightsDiff);
    gaussSmooth(heightsInterp, heights);
    wfall.latest(heights);
}
