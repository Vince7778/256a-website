
// z-level guide:
// cursor tool: 1.0
// toolbox: 0.6-0.8
// platforms: 0.4
// controlled source: 0.48-0.58
// rhythm control: 0.43-0.47
// waterfall+sources: 0.1-0.2
// circlemakers: -0.2 (platforms - 0.6)
// guidelines: -0.4

// can change this, idk why but my home computer is really loud
0.1 => float BASE_GAIN; 

200::ms => dur TEMPO;
0 => int globalBeat;
now => time startTime;

GWindow.fullscreen();
// make sure window is fullscreen before code runs
// else aspect ratio is messed up
GG.nextFrame() => now;

Mouse mouse;
0 => int MO_HOVER;
1 => int MO_CLICKEND;
2 => int MO_DRAG;
3 => int MO_CLICKSTART;

// click states:
// 0: not clicking
// 1: regular playfield click
// 2: toolbox click
// 3: rc click
0 => int clicking;

vec3 mouseDownPos;
spork ~ mouse.selfUpdate();

GG.scene() @=> GScene @ scene;
GG.camera() @=> GCamera @ cam;
cam.orthographic();
@(0, 0, 0) => scene.backgroundColor;


// code from drum_machine.ck
fun vec2 getScreenSize() {
    // recalculate aspect
    (GG.frameWidth() * 1.0) / (GG.frameHeight() * 1.0) => float aspect;
    // calculate ratio between old and new height/width
    cam.viewSize() => float frustrumHeight;  // height of screen in world-space units
    frustrumHeight * aspect => float frustrumWidth;  // width of the screen in world-space units
    return @(frustrumWidth, frustrumHeight);
}




// /------------------------------------------------------\
// |                      BACKGROUND                      |
// \------------------------------------------------------/

FlatMaterial globalBgMat;
Color.hsv2rgb(@(30, 0.57, 1.2)) => globalBgMat.color;
GMesh globalBg(new PlaneGeometry(), globalBgMat) --> scene;
@(100, 100, 1) => globalBg.sca;
-1 => globalBg.posZ;

fun void createBG() {
    GG.nextFrame() => now;

    getScreenSize() => vec2 sz;
    @(sz.x, sz.y, 1) => globalBg.sca;

    // stolen from my own hw2 code
    // stars!
    1000 => int NUM_STARS;

    GPoints stars --> scene;
    vec3 starPos[0];
    for (int i; i < NUM_STARS; i++) {
        Math.random2f(-sz.x, sz.x) => float starX;
        Math.random2f(-sz.x, sz.x) => float starY;
        -2 => float starZ;
        starPos << @(starX, starY, starZ);
    }

    stars.positions(starPos);
    stars.sizes([0.2, 0.4]);

    stars.color(@(1, 1, 1));

    while (true) {
        GG.nextFrame() => now;
        vec3 starColors[0];
        for (int i; i < 7; i++) {
            Math.sin(i * (now - startTime)/3::second)*0.5 + 0.5 => float mult;
            starColors << mult * @(1, 1, 1);
        }
        stars.colors(starColors);
    }
}
spork ~ createBG();




// /---------------------------------------------------\
// |                      CIRCLES                      |
// \---------------------------------------------------/

// unfilled circle
50 => int CIRCLE_RES;
class Circle extends GGen {
    GLines circle --> this;
    float rad;
    
    fun void radius(float _rad) {
        _rad => rad;
        vec2 pos[CIRCLE_RES+2];
        for (int i; i < pos.size(); i++) {
            i * 1.0 / CIRCLE_RES => float theta;
            Math.cos(theta * 2 * pi) * rad => pos[i].x;
            Math.sin(theta * 2 * pi) * rad => pos[i].y;
        }
        pos => circle.positions;
    }

    fun void width(float val) {
        val => circle.width;
    }

    fun void color(vec3 val) {
        val => circle.color;
    }
}

4 => int MAKER_CIRCLE_COUNT;
1 => float MAKER_SPEED;
// circle scales range between 0 and 1
class CircleMaker extends GGen {
    Circle circles[MAKER_CIRCLE_COUNT];
    vec3 baseColor;

    for (int i; i < MAKER_CIRCLE_COUNT; i++) {
        circles[i] --> this;
        circles[i].radius(i * 1.0 / MAKER_CIRCLE_COUNT);
        circles[i].width(0.08);
    }

    fun void color(vec3 val) {
        val => baseColor;
        for (int i; i < MAKER_CIRCLE_COUNT; i++) {
            circles[i].rad => float sca;
            val * (1 - sca * sca) + globalBgMat.color() * sca * sca => circles[i].color;
        }
    }

    fun void update(float dt) {
        for (int i; i < MAKER_CIRCLE_COUNT; i++) {
            circles[i].rad => float sca;
            MAKER_SPEED * dt +=> sca;
            1 %=> sca;
            circles[i].radius(sca);
        }
        color(baseColor);
    }
}



// /-----------------------------------------------------\
// |                      PLATFORMS                      |
// \-----------------------------------------------------/

class Deleteable extends GGen {
    fun float getDist(vec2 p) {
        return 0.0;
    }

    fun void setHighlighted(int val) {}

    fun void delete() {}
}

25 => int NUM_NOTES;
fun float hueToFreq(float hue) {
    Math.round(hue * NUM_NOTES) $ int => int noteOff;
    return Std.mtof(52 + noteOff);
}

CircleGeometry endCircleGeo;
GGen platformGroup --> scene;
0.4 => platformGroup.posZ;
Platform platforms[0];
Platform activePlatform;
false => int isPlacingPlatform;
class Platform extends Deleteable {
    float x1, y1, x2, y2;
    float hue;
    false => int shown;
    false => int highlighted;
    false => int deleted;

    GLines floor --> this;

    FlatMaterial endCircleMat;
    GMesh ends[0];
    for (int i; i < 2; i++) {
        ends << new GMesh(endCircleGeo, endCircleMat);
        ends[i] --> this;
    }

    CircleMaker maker;
    maker.sca(@(0.3, 0.3, 0.3));

    0.1 => static float PLATFORM_WIDTH;
    PLATFORM_WIDTH => floor.width;
    @(1, 1, 1) * PLATFORM_WIDTH => ends[0].sca;
    @(1, 1, 1) * PLATFORM_WIDTH => ends[1].sca;

    false => int playing;
    10::ms => static dur RAMP_TIME;
    TriOsc osc => Envelope env => dac;
    BASE_GAIN => osc.gain;
    now => time lastHit;

    fun void show() {
        if (!shown) {
            true => shown;
            this --> platformGroup;
        }
    }

    fun void hide() {
        if (shown) {
            false => shown;
            this --< platformGroup;
            if (playing) {
                false => playing;
                env.keyOff();
                maker --< this;
            }
        }
    }

    fun void color(float _hue) {
        _hue => hue;

        Color.hsv2rgb(@(hue * 360, 0.8, 0.7)) => vec3 color;
        if (highlighted) {
            0.4 => color.y;
            0.85 => color.z;
        }
        color => floor.color;
        color => endCircleMat.color;

        maker.color(Color.hsv2rgb(@(hue * 360, 1, 1)));

        hueToFreq(hue) => osc.freq;
    }

    fun void pos(float _x1, float _y1, float _x2, float _y2) {
        _x1 => x1;
        _y1 => y1;
        _x2 => x2;
        _y2 => y2;

        [@(x1, y1), @(x2, y2)] => floor.positions;
        @(x1, y1, 0.0) => ends[0].pos;
        @(x2, y2, 0.0) => ends[1].pos;
    }

    fun void pos2(float _x2, float _y2) {
        _x2 => x2;
        _y2 => y2;

        [@(x1, y1), @(x2, y2)] => floor.positions;
        @(x2, y2, 0.0) => ends[1].pos;
    }

    fun void getSegs(WfSeg out[]) {
        norm(@(x2 - x1, y2 - y1)) * PLATFORM_WIDTH / 2 => vec2 offset;
        @(-offset.y, offset.x) => vec2 perp;

        // top and bottom
        // i hope sidedness is correct
        WfSeg s;
        @(x1, y1) - offset + perp => s.a;
        @(x2, y2) + offset + perp => s.b;
        this @=> s.p;
        out << s;
        new WfSeg @=> s;
        @(x2, y2) + offset - perp => s.a;
        @(x1, y1) - offset - perp => s.b;
        this @=> s.p;
        out << s;

        // end caps
        new WfSeg @=> s;
        @(x1, y1) - offset - perp => s.a;
        @(x1, y1) - offset + perp => s.b;
        this @=> s.p;
        out << s;
        new WfSeg @=> s;
        @(x2, y2) + offset + perp => s.a;
        @(x2, y2) + offset - perp => s.b;
        this @=> s.p;
        out << s;
    }

    // return the centered WfSeg
    fun WfSeg oneSeg() {
        return new WfSeg(x1, y1, x2, y2);
    }

    // dist is the % of the screen height that the water fell
    fun void hit(time t, float dist, vec2 hitPos) {
        if (!shown) return;
        t => lastHit;
        // env.ramp(RAMP_TIME, dist);
        env.keyOn();
        if (!playing) {
            true => playing;
            maker --> this;
        }
        maker.pos(@(hitPos.x, hitPos.y, -0.6));
    }

    fun void checkUnhit(time t) {
        if (lastHit == t) return;
        if (playing) {
            false => playing;
            env.keyOff();
            maker --< this;
        }
    }

    fun float getDist(vec2 p) {
        return segDist(oneSeg(), p);
    }

    fun void setHighlighted(int val) {
        val => highlighted;
        color(hue);
    }

    fun void delete() {
        hide();
        true => deleted;
        for (int i; i < platforms.size(); i++) {
            if (platforms[i] == this) {
                platforms.popOut(i);
                break;
            }
        }
    }
}

fun void activePlatformUpdate(vec3 pos, int mode) {
    if (mode == MO_HOVER) {
        if (!isPlacingPlatform) {
            // show preview
            activePlatform.pos(pos.x, pos.y, pos.x, pos.y);
        } else {
            activePlatform.pos2(pos.x, pos.y);
        }
    } else if (mode == MO_CLICKEND) {
        if (!isPlacingPlatform) {
            true => isPlacingPlatform;
            activePlatform.pos(pos.x, pos.y, pos.x, pos.y);
        } else {
            false => isPlacingPlatform;
            pushActivePlatform();
            activePlatform.pos(pos.x, pos.y, pos.x, pos.y);
        }
    } else if (mode == MO_DRAG) {
        if (!isPlacingPlatform) {
            pos - mouseDownPos => vec3 offset;
            if (offset.magnitude() >= 0.1) {
                true => isPlacingPlatform;
                activePlatform.pos(mouseDownPos.x, mouseDownPos.y, pos.x, pos.y);
            }
        } else {
            activePlatform.pos2(pos.x, pos.y);
        }
    } else if (mode == MO_CLICKSTART) {
        pos => mouseDownPos;
    }
}

fun void pushActivePlatform() {
    platforms << activePlatform;
    new Platform() @=> activePlatform;
    activePlatform.show();
}






// /-----------------------------------------------------\
// |                      WATERFALL                      |
// \-----------------------------------------------------/

0.4 => float waterfallSpeed; // how many sweeps per second

class WfSeg {
    vec2 a, b; // endpoints
    Platform @ p; // original platform (optional)

    fun WfSeg(float x1, float y1, float x2, float y2) {
        @(x1, y1) => a;
        @(x2, y2) => b;
    }

    fun WfSeg(vec2 _a, vec2 _b) {
        _a => a;
        _b => b;
    }

    fun GLines asGLines() {
        GLines lines;
        @(0, 0, 1) => lines.color;
        return lines;
    }
}



// geometry stuff

1e-6 => float EPS;
fun int ptsEqual(vec2 a, vec2 b) {
    return Math.fabs(a.x - b.x) < EPS && Math.fabs(a.y - b.y) < EPS;
}

// accounts for epsilons
fun int sgn(float x) {
    return (x > -EPS) - (x < EPS);
}

fun float dotProd(vec2 a, vec2 b) {
    return a.x * b.x + a.y * b.y;
}

fun float cross(vec2 a, vec2 b) {
    return a.x * b.y - a.y * b.x;
}

fun float cross(vec2 a, vec2 b, vec2 c) {
    return cross(b-a, c-a);
}

fun float magsqr(vec2 x) {
    return x.x * x.x + x.y * x.y;
}

fun float mag(vec2 x) {
    return Math.sqrt(magsqr(x));
}

fun vec2 norm(vec2 x) {
    return x / mag(x);
}

// Returns the distance between a point and a segment.
fun float segDist(WfSeg s, vec2 p) {
    if (ptsEqual(s.a, s.b)) return mag(p-s.a);
    // geometry magic
    magsqr(s.b - s.a) => float d;
    Std.clampf(dotProd(p-s.a, s.b-s.a), 0, d) => float t;
    return mag((p-s.a)*d - (s.b-s.a)*t) / d;
}

fun int onSegment(WfSeg s, vec2 p) {
    return segDist(s, p) < EPS;
}

fun int sideOf(vec2 s, vec2 e, vec2 p) {
	cross(e-s, p-s) => float a;
	mag(e-s)*EPS => float l;
	return (a > l) - (a < -l);
}

// computes the point where two segments intersect
// returns NULL_PT if no point exists, or infinitely many exist
@(-727, -727) => vec2 NULL_PT;
fun vec2 segIntersect(WfSeg s1, WfSeg s2) {
    // magic code
    cross(s2.a, s2.b, s1.a) => float oa;
    cross(s2.a, s2.b, s1.b) => float ob;
    cross(s1.a, s1.b, s2.a) => float oc;
    cross(s1.a, s1.b, s2.b) => float od;
    if (sgn(oa) * sgn(ob) < 0 && sgn(oc) * sgn(od) < 0) {
        return (s1.a * ob - s1.b * oa) / (ob - oa);
    }
    NULL_PT => vec2 res;
    if (onSegment(s2, s1.a)) {
        if (res != NULL_PT) return NULL_PT;
        s1.a => res;
    }
    if (onSegment(s2, s1.b)) {
        if (res != NULL_PT) return NULL_PT;
        s1.b => res;
    }
    if (onSegment(s1, s2.a)) {
        if (res != NULL_PT) return NULL_PT;
        s2.a => res;
    }
    if (onSegment(s1, s2.b)) {
        if (res != NULL_PT) return NULL_PT;
        s2.b => res;
    }
    return res;
}

// returns downwards endpoint of the segment
// if horizontal, returns arbitrary
fun vec2 downSlope(WfSeg s, vec2 down, vec2 bias) {
    if (dotProd(s.a, down) == dotProd(s.b, down)) {
        return s.b;
    } else if (dotProd(s.a, down) > dotProd(s.b, down)) {
        return s.a;
    } else {
        return s.b;
    }
}

// algorithm for computing the waterfall
fun void computeSegs(vec2 startPos, WfSeg waterfallSegs[], time checkTime, int shouldAudio, vec2 down) {
    // getScreenSize().y / 2.0 => float yLimit;

    startPos => vec2 pt;
    WfSeg checkSeg(pt, pt + down*100);

    WfSeg pSegs[0];
    for (Platform @ p : platforms) {
        p.getSegs(pSegs);
    }
    if (isPlacingPlatform && tool == TOOL_PLATFORM) activePlatform.getSegs(pSegs);
    
    true => int isVert;

    while (true) {
        // check for highest intersecting platform
        pt + down*10000 => vec2 highPt;
        WfSeg highSeg;
        for (WfSeg pSeg : pSegs) {
            segIntersect(checkSeg, pSeg) => vec2 curPt;
            if (ptsEqual(curPt, NULL_PT)) continue;
            // ignore endpoints
            if (ptsEqual(curPt, pSeg.a) || ptsEqual(curPt, pSeg.b)) {
                continue;
            }
            // only ignore check endpoint if sideof is correct
            // i think
            if (ptsEqual(curPt, checkSeg.a) && sideOf(pSeg.a, pSeg.b, checkSeg.b) == 1) continue;
            if (dotProd(curPt, down) < dotProd(highPt, down)) {
                curPt => highPt;
                pSeg @=> highSeg;
            } 
        }

        if (ptsEqual(highPt, pt + down*10000)) {
            // no intersections
            checkSeg.b => pt;
            waterfallSegs << checkSeg;
            if (mag(pt) > 80) break;
            // fall down edge
            new WfSeg(pt, pt + down*100) @=> checkSeg;
            true => isVert;
            continue;
        }

        if (ptsEqual(highPt, pt)) {
            // stuck in a V
            break;
        }

        // intersects with some segment
        // if checkSeg is vertical, cause a hit
        if (isVert) {
            // (pt.y - highPt.y) / (2 * yLimit) => float dist;
            if (shouldAudio) highSeg.p.hit(checkTime, 0.0, highPt);
        }

        waterfallSegs << new WfSeg(pt, highPt);
        highPt => pt;
        false => isVert;
        new WfSeg(pt, downSlope(highSeg, down, checkSeg.b - checkSeg.a)) @=> checkSeg;
    }
}

fun vec2 downFromRot(float r) {
    3*pi/2 +=> r;
    return @(Math.cos(r), Math.sin(r));
}


CircleGeometry wfCircGeo;
FlatMaterial wfHoleMat;
@(0, 0, 0) => wfHoleMat.color;
FlatMaterial wfHiHoleMat;
@(0.3, 0.3, 0.3) => wfHiHoleMat.color;
FlatMaterial wfEdgeMat;
@(176, 44, 48) / 255.0 => wfEdgeMat.color;
fun GGen makeWfHole() {
    GGen wfHole;

    GMesh wfHoleInside(wfCircGeo, wfHoleMat) --> wfHole;
    0.05 => wfHoleInside.posZ;
    @(1, 1, 1) * 0.2 => wfHoleInside.sca;

    GMesh wfHoleEdge(wfCircGeo, wfEdgeMat) --> wfHole;
    @(1, 1, 1) * 0.24 => wfHoleEdge.sca;

    return wfHole;
}

// do not set the source's pos directly! keep it at origin
// instead use setPos
GGen sourceGroup --> scene;
WfSource sources[0];
0 => float wrot;
class WfSource extends Deleteable {
    0.1 => this.posZ;

    vec2 wpos;
    WfSeg segs[0];
    false => int isActive;
    false => int isFlowing;
    false => int isHighlighted;

    [false] @=> int rhythm[];

    GLines wfLines;
    @(0, 0, 1) => wfLines.color;
    0.1 => wfLines.posZ;

    makeWfHole() @=> GGen wfHole;
    wfHole --> this;

    // replace hole inside when highlighted
    GMesh wfHiHole(wfCircGeo, wfHiHoleMat);
    0.06 => wfHiHole.posZ;
    @(1, 1, 1) * 0.2 => wfHiHole.sca;

    fun void setPos(vec2 p) {
        p => wpos;
        @(p.x, p.y, 0) => wfHole.pos;
    }
    
    fun void compute(time checkTime) {
        if (!isActive) return;
        new WfSeg[0] @=> segs;
        downFromRot(wrot) => vec2 down;
        computeSegs(wpos, segs, checkTime, isFlowing, down);
    }

    fun void draw() {
        if (!isActive) return;
        if (segs.size() == 0) {
            new vec2[0] => wfLines.positions;
            // nothing to draw
            return;
        }

        vec2 linesPos[0];
        linesPos << @(segs[0].a.x, segs[0].a.y);
        for (WfSeg seg : segs) {
            linesPos << @(seg.b.x, seg.b.y);
        }

        linesPos => wfLines.positions;
    }

    fun void setActive(int na) {
        if (na && !isActive) {
            true => isActive;
            this --> sourceGroup;
        } else if (!na && isActive) {
            false => isActive;
            this --< sourceGroup;
        }
    }

    fun void setFlowing(int nf) {
        if (nf && !isFlowing) {
            wfLines --> this;
        } else if (!nf && isFlowing) {
            wfLines --< this;
        }
        nf => isFlowing;
    }

    fun void checkFlowing(int beat) {
        setFlowing(rhythm[beat % rhythm.size()]);
    }

    fun float getDist(vec2 p) {
        return mag(p - wpos);
    }

    fun void setHighlighted(int val) {
        if (val && !isHighlighted) {
            wfHiHole --> wfHole;
        } else if (!val && isHighlighted) {
            wfHiHole --< wfHole;
        }
        val => isHighlighted;
    }

    fun void delete() {
        setActive(false);
        for (int i; i < sources.size(); i++) {
            if (sources[i] == this) {
                sources.popOut(i);
                break;
            }
        }
    }

    fun int isWithin(vec2 p) {
        return getDist(p) < 0.12;
    }
}

WfSource defaultSource;
defaultSource.setPos(@(0, 0));
[1, 1, 0, 0, 1, 1, 0, 0] @=> defaultSource.rhythm;
defaultSource.setActive(true);
sources << defaultSource;

WfSource handSource;
fun void placeSource() {
    // set new random rhythm
    int newRhy[0];
    for (int i; i < 8; i++) {
        newRhy << (Math.random() % 2);
    }
    newRhy @=> handSource.rhythm;
    sources << handSource;
    new WfSource() @=> handSource;
    handSource.setActive(true);
}









// /-----------------------------------------------------------\
// |                      RHYTHM SELECTOR                      |
// \-----------------------------------------------------------/

FlatMaterial RCWhite;
FlatMaterial RCGray; @(1, 1, 1) * 0.8 => RCGray.color;
FlatMaterial RCGreen; @(54, 189, 49) / 255.0 => RCGreen.color;
FlatMaterial RCRed; @(240, 22, 49) / 255.0 => RCRed.color;
FlatMaterial RCBlue; @(0.1, 0.1, 1) => RCBlue.color;
FlatMaterial RCBlack; @(0, 0, 0) => RCBlack.color;

PlaneGeometry RCPlane;

class RhythmCtrl extends GGen {
    0.3 => static float BX; // box size
    0.06 => static float MG; // margin

    null @=> WfSource @ src;

    GMesh bg(RCPlane, RCWhite) --> this;
    GGen boxes --> this;
    0.01 => boxes.posZ;

    GGen minus --> this;
    true => int minusConn;
    GGen plus --> this;
    true => int plusConn;

    GMesh beatMarker(RCPlane, RCRed) --> this;

    // creates the stuff that doesn't change
    fun void init() {
        // minus sign
        @(BX, BX, 1) => minus.sca;
        @(-BX-MG, 0, 0.01) => minus.pos;

        GMesh minusBg(RCPlane, RCGray) --> minus;
        0.01 => minusBg.posZ;

        GMesh minusH(RCPlane, RCRed) --> minus;
        @(0.8, 0.2, 1) => minusH.sca;
        0.02 => minusH.posZ;

        // plus sign
        @(BX, BX, 1) => plus.sca;
        @(BX+MG, 0, 0.01) => plus.pos;

        GMesh plusBg(RCPlane, RCGray) --> plus;
        0.01 => plusBg.posZ;

        GMesh plusH(RCPlane, RCGreen) --> plus;
        @(0.8, 0.2, 1) => plusH.sca;
        0.02 => plusH.posZ;

        GMesh plusV(RCPlane, RCGreen) --> plus;
        @(0.2, 0.8, 1) => plusV.sca;
        0.02 => plusV.posZ;

        // beat marker
        @(BX, BX/6, 1) => beatMarker.sca;
        BX/2 + MG + BX/12 => beatMarker.posY;
        0.02 => beatMarker.posZ;

        rebuild();
    }
    
    // resizes the stuff that changes with rhythm
    fun void rebuild() {
        src.rhythm.size() => int rs;
        Math.max(3, rs) => int w;

        if (rs <= 1 && minusConn) {
            false => minusConn;
            minus --< this;
        } else if (rs > 1 && !minusConn) {
            true => minusConn;
            minus --> this;
        }

        BX * w + MG * (w+1) => bg.scaX;
        BX * 2 + MG * 3 => bg.scaY;
        BX / 2 + MG / 2 => bg.posY;

        boxes.detachChildren();

        (BX + MG) * (rs - 1) / 2 => float farx;
        for (int i; i < rs; i++) {
            0 => float ratio;
            // prevent div by 0
            if (rs > 1) i * 1.0 / (rs - 1) => ratio;

            null => GMesh box;
            if (src.rhythm[i]) {
                new GMesh(RCPlane, RCBlue) @=> box;
            } else {
                new GMesh(RCPlane, RCBlack) @=> box;
            }

            farx * (ratio * 2 - 1) => box.posX;
            BX + MG => box.posY;
            BX => box.scaX;
            BX => box.scaY;
            box --> boxes;
        }

        placeBeatMarker(globalBeat);
    }

    fun void placeBeatMarker(int beat) {
        src.rhythm.size() => int rs;
        beat % rs=> int i;

        0 => float ratio;
        // prevent div by 0
        if (rs > 1) i * 1.0 / (rs - 1) => ratio;

        (BX + MG) * (rs - 1) / 2 => float farx;
        farx * (ratio * 2 - 1) => beatMarker.posX;
    }

    // -100 = plus
    // -101 = minus
    // -102 = nothing, but inside
    //   -1 = outside
    // 0..n = on rhythm pad
    fun int testMouse(vec3 p) {
        // convert to local coordinates
        this.posX() -=> p.x;
        this.posY() -=> p.y;

        src.rhythm.size() => int rs;
        Math.max(3, rs) => int w;

        BX * w + MG * (w+1) => float width;
        if (p.x < -width/2 || p.x > width/2 || p.y < (-BX / 2 - MG) || p.y > (BX * 1.5 + MG * 2)) {
            return -1;
        }

        // test plus and minus
        if (p.y >= -BX/2 && p.y <= BX/2) {
            BX/2 + MG => float inx;
            inx + BX => float outx;
            if (p.x >= -outx && p.x <= -inx && rs > 1) {
                return -101;
            }
            if (p.x >= inx && p.x <= outx) {
                return -100;
            }
        }

        // test boxes
        else if (p.y >= BX/2 + MG && p.y <= BX * 1.5 + MG) {
            (BX + MG) * (rs - 1) / 2 => float farx;
            for (int i; i < rs; i++) {
                0 => float ratio;
                // prevent div by 0
                if (rs > 1) i * 1.0 / (rs - 1) => ratio;

                farx * (ratio * 2 - 1) => float midx;
                if (p.x >= midx - BX/2 && p.x <= midx + BX/2) {
                    return i;
                }
            }
        }

        return -102;
    }

    fun void handleClick(int ty) {
        if (ty == -102 || ty == -1) return;
        if (ty == -100) {
            src.rhythm << false;
        } else if (ty == -101) {
            if (src.rhythm.size() > 1) {
                src.rhythm.popBack();
            }
        } else {
            !src.rhythm[ty] => src.rhythm[ty];
        }
        rebuild();
    }
}

null => RhythmCtrl globalRC;

fun void startRC(int ind) {
    new RhythmCtrl() @=> globalRC;
    sources[ind] @=> globalRC.src;
    sources[ind].wpos.x => globalRC.posX;
    sources[ind].wpos.y => globalRC.posY;
    0.43 => globalRC.posZ;
    0.48 => sources[ind].posZ;
    globalRC.init();
    globalRC --> scene;
}

fun void endRC() {
    if (globalRC == null) return;
    0.1 => globalRC.src.posZ;
    globalRC --< scene;
    null => globalRC;
}





// /-------------------------------------------------\
// |                      TOOLS                      |
// \-------------------------------------------------/

4 => int numTools;
0 => int TOOL_DELETE;
1 => int TOOL_PLATFORM;
2 => int TOOL_SOURCE;
3 => int TOOL_ROTATE; // secret tool!
-1 => int TOOL_NONE; // fake nothing tool, used for rc stuff

TOOL_PLATFORM => int tool;
TOOL_PLATFORM => int swapTool; // store to swap back after delete

Deleteable @ selectedDelete;
GMesh darkPlane;

fun GGen makeDeleteIcon() {
    GGen gen;
    0.07 => float sz;
    @(240, 22, 49) / 255.0 => vec3 color;

    GLines l1;
    [@(-sz, -sz), @(sz, sz)] => l1.positions;
    color => l1.color;
    0.05 => l1.width;
    l1 --> gen;

    GLines l2;
    [@(-sz, sz), @(sz, -sz)] => l2.positions;
    color => l2.color;
    0.05 => l2.width;
    l2 --> gen;

    return gen;
}
makeDeleteIcon() @=> GGen deleteIcon;
1.0 => deleteIcon.posZ;

fun void disableTool(int id) {
    if (id == TOOL_PLATFORM) {
        activePlatform.hide();
        false => isPlacingPlatform;
    } else if (id == TOOL_DELETE) {
        deleteIcon --< scene;
        if (selectedDelete != null) {
            selectedDelete.setHighlighted(false);
            null @=> selectedDelete;
        }
    } else if (id == TOOL_SOURCE) {
        handSource.setActive(false);
    }
}

fun void enableTool(int id) {
    if (id == TOOL_PLATFORM) {
        activePlatform.pos(-727, -727, -727, -727);
        activePlatform.show();
    } else if (id == TOOL_DELETE) {
        mouse.worldPos => deleteIcon.pos;
        1.0 => deleteIcon.posZ;
        deleteIcon --> scene;
    } else if (id == TOOL_SOURCE) {
        handSource.setActive(true);
    }
}

fun void switchTool(int id) {
    disableTool(tool);
    id => tool;
    if (id != TOOL_NONE) moveDarkPlane();
    enableTool(tool);
}

fun void checkDelete(vec3 pos3) {
    @(pos3.x, pos3.y) => vec2 pos;
    1e9 => float closest;
    null @=> Deleteable @ newDelete;

    for (Platform @ p : platforms) {
        p.getDist(pos) => float curDist;
        if (curDist < closest) {
            curDist => closest;
            p @=> newDelete;
        }
    }

    for (WfSource @ p : sources) {
        p.getDist(pos) => float curDist;
        if (curDist < closest) {
            curDist => closest;
            p @=> newDelete;
        }
    }

    if (closest > 0.4) {
        if (selectedDelete != null) {
            selectedDelete.setHighlighted(false);
            null => selectedDelete;
        }
    } else {
        if (selectedDelete != null) {
            selectedDelete.setHighlighted(false);
        }
        newDelete @=> selectedDelete;
        selectedDelete.setHighlighted(true);
    }
}

fun void deleteSelected() {
    if (selectedDelete != null) {
        selectedDelete.delete();
    }
}

fun void moveDarkPlane() {
    if (tool == TOOL_NONE) return;
    getScreenSize() => vec2 bounds;
    bounds.y / 15.0 => float toolSize;
    bounds.y / 50.0 => float margin;
    -bounds.x / 2.0 + margin => float baseX;
    -bounds.y / 2.0 + margin => float baseY;
    toolSize + 2 * margin => float boxWidth;

    baseX + boxWidth / 2.0 => darkPlane.posX;
    baseY + toolSize * (tool + 0.5) + margin * (tool + 1) => darkPlane.posY;
    if (tool == TOOL_ROTATE) {
        darkPlane.posX() + Math.random2f(-0.03, 0.03) => darkPlane.posX;
        darkPlane.posY() + Math.random2f(-0.03, 0.03) => darkPlane.posY;
    }
}

fun void updateDarkPlane() {
    while (true) {
        GG.nextFrame() => now;
        moveDarkPlane();
    }
}
spork ~ updateDarkPlane();


GGen gToolbox --> scene;
false => int toolboxCreated;
fun void createToolbox() {
    if (toolboxCreated) return;
    true => toolboxCreated;
    getScreenSize() => vec2 bounds;

    bounds.y / 15.0 => float toolSize;
    bounds.y / 50.0 => float margin;
    -bounds.x / 2.0 + margin => float baseX;
    -bounds.y / 2.0 + margin => float baseY;
    toolSize + 2 * margin => float boxWidth;
    toolSize * (numTools-1) + margin * (numTools) => float boxHeight;

    PlaneGeometry planeGeo;
    FlatMaterial planeMat;
    GMesh backPlane(planeGeo, planeMat) --> gToolbox;
    boxWidth => backPlane.scaX;
    boxHeight => backPlane.scaY;
    baseX + boxWidth / 2.0 => backPlane.posX;
    baseY + boxHeight / 2.0 => backPlane.posY;

    FlatMaterial darkPlaneMat;
    @(0.6, 0.6, 0.6) => darkPlaneMat.color;
    new GMesh(planeGeo, darkPlaneMat) @=> darkPlane;
    darkPlane --> gToolbox;
    toolSize + margin => darkPlane.scaX;
    toolSize + margin => darkPlane.scaY;
    0.05 => darkPlane.posZ;
    moveDarkPlane();

    for (int i; i < numTools-1; i++) {
        GMesh toolPlane(planeGeo, planeMat) --> gToolbox;
        toolSize => toolPlane.scaX;
        toolSize => toolPlane.scaY;
        baseX + boxWidth / 2.0 => toolPlane.posX;
        baseY + toolSize * (i + 0.5) + margin * (i + 1) => toolPlane.posY;
        0.1 => toolPlane.posZ;
    }

    Platform toolboxPlatform --> gToolbox;
    toolboxPlatform.pos(baseX + 2*margin, baseY + toolSize + 3*margin, baseX + boxWidth - 2*margin, baseY + toolSize * 2 + margin);
    0.15 => toolboxPlatform.posZ;
    toolboxPlatform.color(0);

    makeDeleteIcon() @=> GGen toolboxDeleteIcon;
    baseX + boxWidth / 2.0 => toolboxDeleteIcon.posX;
    baseY + toolSize / 2.0 + margin => toolboxDeleteIcon.posY;
    0.15 => toolboxDeleteIcon.posZ;
    @(1, 1, 1) * 1.8 => toolboxDeleteIcon.sca;
    toolboxDeleteIcon --> gToolbox;

    makeWfHole() @=> GGen toolboxWfHole;
    baseX + boxWidth / 2.0 => toolboxWfHole.posX;
    baseY + toolSize * 2.5 + margin * 3 => toolboxWfHole.posY;
    0.15 => toolboxWfHole.posZ;
    @(1, 1, 1) * 1.4 => toolboxWfHole.sca;
    toolboxWfHole --> gToolbox;

    0.6 => gToolbox.posZ;
}

// returns -2 if outside of toolbox
// returns -1 if inside toolbox, but not on a tool
// returns tool # if inside toolbox and on tool
fun int getToolboxPos(vec3 pos) {
    if (!toolboxCreated) return -2;

    getScreenSize() => vec2 bounds;

    bounds.y / 15.0 => float toolSize;
    bounds.y / 50.0 => float margin;
    -bounds.x / 2.0 + margin => float baseX;
    -bounds.y / 2.0 + margin => float baseY;
    toolSize + 2 * margin => float boxWidth;
    toolSize * numTools + margin * (numTools + 1) => float boxHeight;

    for (int i; i < numTools; i++) {
        baseX + margin => float x1;
        baseY + margin + (toolSize + margin) * i => float y1;
        x1 + toolSize => float x2;
        y1 + toolSize => float y2;
        if (pos.x >= x1 && pos.x <= x2 && pos.y >= y1 && pos.y <= y2) {
            return i;
        }
    }

    baseX => float x1;
    baseY => float y1;
    baseX + boxWidth => float x2;
    baseY + boxHeight => float y2;
    if (pos.x >= x1 && pos.x <= x2 && pos.y >= y1 && pos.y <= y2) {
        return -1;
    }
    return -2;
}



// /-------------------------------------------------\
// |                      INPUT                      |
// \-------------------------------------------------/

// Mouse class from drum_machine.ck
class Mouse {
    vec3 worldPos;

    // update mouse world position
    fun void selfUpdate() {
        while (true) {
            GG.nextFrame() => now;
            // calculate mouse world X and Y coords
            GG.camera().screenCoordToWorldPos(GWindow.mousePos(), 1.0) => worldPos;
            0 => worldPos.z;
        }
    }
}

fun int handleHoverOverSource(vec3 mpos) {
    for (int i; i < sources.size(); i++) {
        if (sources[i].isWithin(@(mpos.x, mpos.y))) {
            startRC(i);
            return true;
        }
    }
    return false;
}

0 => float wrotaccel;
fun void thefunny() {
    0.00003 +=> wrotaccel;
    Std.clampf(wrotaccel, 0, 0.05) => wrotaccel;
    wrotaccel +=> wrot;
    cam.rotZ() + wrotaccel => cam.rotZ;
}

fun void handleClicks() {
    while (true) {
        GG.nextFrame() => now;

        // handle toolbox clicks
        getToolboxPos(mouse.worldPos) => int tboxPos;

        -1 => int rcPos;
        if (globalRC != null) {
            globalRC.testMouse(mouse.worldPos) => rcPos;
        }

        if (GWindow.mouseLeft() && clicking == 0) {
            // mouse click start
            if (tboxPos != -2) {
                2 => clicking;
            } else if (rcPos != -1) {
                3 => clicking;
            } else {
                1 => clicking;
                if (tool == TOOL_PLATFORM) activePlatformUpdate(mouse.worldPos, MO_CLICKSTART);
            }
        } else if (!GWindow.mouseLeft() && clicking != 0) {
            // mouse click end
            if (tboxPos >= 0 && clicking == 2) switchTool(tboxPos);
            else if (rcPos != -1 && clicking == 3 && tool == TOOL_NONE) globalRC.handleClick(rcPos);
            else if (tool == TOOL_PLATFORM && clicking == 1) activePlatformUpdate(mouse.worldPos, MO_CLICKEND);
            else if (tool == TOOL_DELETE && clicking == 1) deleteSelected();
            else if (tool == TOOL_SOURCE && clicking == 1) placeSource();
            0 => clicking;
        } else if (GWindow.mouseLeft() && clicking != 0) {
            // mouse dragged
            if (clicking == 1 && tool == TOOL_PLATFORM) activePlatformUpdate(mouse.worldPos, MO_DRAG);
            else if (tool == TOOL_ROTATE && clicking == 1) thefunny();
        } else if (!GWindow.mouseLeft() && clicking == 0) {
            // mouse hovered
            0.0003 -=> wrotaccel;
            if (tool != TOOL_NONE && tool != TOOL_DELETE && tool != TOOL_ROTATE && handleHoverOverSource(mouse.worldPos)) {
                tool => swapTool;
                switchTool(TOOL_NONE);
            } else if (tool == TOOL_NONE && rcPos == -1) {
                endRC();
                switchTool(swapTool);
            } else if (tool == TOOL_PLATFORM) activePlatformUpdate(mouse.worldPos, MO_HOVER);
        }

        if (tool == TOOL_DELETE) {
            mouse.worldPos => deleteIcon.pos;
            1.0 => deleteIcon.posZ;
            checkDelete(mouse.worldPos);
        } else if (tool == TOOL_SOURCE) {
            @(mouse.worldPos.x, mouse.worldPos.y) => vec2 mouse2d;
            handSource.setPos(mouse2d);
        }
    }
}
spork ~ handleClicks();

0.0 => float curHue;
TriOsc exampleOsc => Envelope exampleEnv => dac;
BASE_GAIN => exampleOsc.gain;
fun void playExample(float hue) {
    hueToFreq(hue) => exampleOsc.freq;
    exampleEnv.keyOn();
    100::ms => now;
    exampleEnv.keyOff();
}

fun void handleKeys() {
    while (true) {
        GG.nextFrame() => now;
        if (GWindow.keyDown(GWindow.Key_Backspace)) {
            if (tool != TOOL_DELETE) {
                if (tool != TOOL_NONE) tool => swapTool;
                else endRC();
                switchTool(TOOL_DELETE);
            } else {
                switchTool(swapTool);
            }
        }

        if (tool == TOOL_PLATFORM) {
            false => int playSound;
            if (GWindow.keyDown(GWindow.Key_Right)) {
                1.0 / NUM_NOTES +=> curHue;
                1.0 %=> curHue;
                true => playSound;
            }
            if (GWindow.keyDown(GWindow.Key_Left)) {
                (NUM_NOTES - 1.0) / NUM_NOTES +=> curHue;
                1.0 %=> curHue;
                true => playSound;
            }
            if (playSound) {
                spork ~ playExample(curHue);
            }
        }
    }
}
spork ~ handleKeys();

fun void updateBeat() {
    while (true) {
        TEMPO => now;
        1 +=> globalBeat;

        for (WfSource src : sources) {
            src.checkFlowing(globalBeat);
        }
        handSource.checkFlowing(globalBeat);

        if (globalRC != null) {
            globalRC.placeBeatMarker(globalBeat);
        }
    }
}
spork ~ updateBeat();

fun void updateWaterfall() {
    GG.nextFrame() => now;

    while (true) {
        GG.nextFrame() => now;

        now => time checkTime;
        for (WfSource src : sources) {
            src.compute(checkTime);
            src.draw();
        }
        handSource.compute(checkTime);
        handSource.draw();

        for (Platform @ p : platforms) {
            p.checkUnhit(checkTime);
        }
        activePlatform.checkUnhit(checkTime);
    }
}
spork ~ updateWaterfall();

fun void drone() {
    SinOsc dr => Envelope env => dac;
    Std.mtof(40) => dr.freq;
    0.25 => dr.gain;

    while (true) {
        10::ms => now;
        // funky formula
        1 - Math.fabs(pi - (wrot % (2*pi))) / (pi) => float tgain;
        env.ramp(10::ms, tgain);
    }
}
spork ~ drone();

activePlatform.show();

while (true) {
    GG.nextFrame() => now;

    createToolbox();
    activePlatform.color(curHue);

    // if (UI.begin("")) { UI.scenegraph(scene); } UI.end();
}
