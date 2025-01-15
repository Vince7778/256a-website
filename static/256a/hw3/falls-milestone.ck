
// z-level guide:
// platforms: 0.4
// waterfall: 0.2
// circlemakers: -0.2 (platforms - 0.6)
// guidelines: -0.4

// change this, idk why but my home computer is really loud
0.1 => float BASE_GAIN;

GWindow.fullscreen();
// make sure window is fullscreen before code runs
// else aspect ratio is messed up
GG.nextFrame() => now;

Mouse mouse;
false => int clicking;
vec3 mouseDownPos;
spork ~ mouse.selfUpdate();

GG.scene() @=> GScene @ scene;
GG.camera() @=> GCamera @ cam;
cam.orthographic();
Color.hsv2rgb(@(30, 0.57, 1.2)) => scene.backgroundColor;


// code from drum_machine.ck
fun vec2 getScreenSize() {
    // recalculate aspect
    (GG.frameWidth() * 1.0) / (GG.frameHeight() * 1.0) => float aspect;
    // calculate ratio between old and new height/width
    cam.viewSize() => float frustrumHeight;  // height of screen in world-space units
    frustrumHeight * aspect => float frustrumWidth;  // width of the screen in world-space units
    return @(frustrumWidth, frustrumHeight);
}




// /-------------------------------------------------------\
// |                      GUIDE LINES                      |
// \-------------------------------------------------------/

0.6 => float FALL_AREA;
9 => int NUM_GUIDES;
GGen guidelineGroup --> scene;
guidelineGroup.posZ(-0.4);
// must be done after one frame
false => int guidelinesCreated;
fun void createGuidelines() {
    if (guidelinesCreated) return;
    true => guidelinesCreated;
    for (int i; i < NUM_GUIDES; i++) {
        GLines curLine --> guidelineGroup;

        getScreenSize() => vec2 ss;
        FALL_AREA * ss.x / (NUM_GUIDES - 1) * i - FALL_AREA / 2 * ss.x => float xpos;
        [@(xpos, ss.y / 2), @(xpos, -ss.y / 2)] => curLine.positions;
        if (i == 0) {
            @(141, 219, 81) / 255.0 => curLine.color;
        } else if (i == NUM_GUIDES - 1) {
            @(232, 154, 125) / 255.0 => curLine.color;
        }
        0.05 => curLine.width;
    }
}

fun vec3 snapToGuideline(vec3 pos) {
    getScreenSize().x => float xx;
    (pos.x + FALL_AREA / 2 * xx) / (FALL_AREA * xx / (NUM_GUIDES - 1)) => float rel;
    Math.clampf(rel, 0, NUM_GUIDES-1) => rel;
    Math.round(rel) $ int => int ind;
    FALL_AREA * xx / (NUM_GUIDES - 1) * ind - FALL_AREA / 2 * xx => float xpos;
    return @(xpos, pos.y, pos.z);
}




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
            val * (1 - sca * sca) + GG.scene().backgroundColor() * sca * sca => circles[i].color;
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
class Platform extends GGen {
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

    fun void setHighlighted(int val) {
        val => highlighted;
        color(hue);
    }

    fun void delete() {
        hide();
        true => deleted;
    }
}

// mode = 0: hovering
// mode = 1: click end
// mode = 2: dragging
// mode = 3: click start
fun void activePlatformUpdate(vec3 pos, int mode) {
    if (!GWindow.key(GWindow.Key_LeftShift) && !GWindow.key(GWindow.Key_RightShift)) {
        snapToGuideline(pos) => pos;
    }
    if (mode == 0) {
        if (!isPlacingPlatform) {
            // show preview
            activePlatform.pos(pos.x, pos.y, pos.x, pos.y);
        } else {
            activePlatform.pos2(pos.x, pos.y);
        }
    } else if (mode == 1) {
        if (!isPlacingPlatform) {
            true => isPlacingPlatform;
            activePlatform.pos(pos.x, pos.y, pos.x, pos.y);
        } else {
            false => isPlacingPlatform;
            pushActivePlatform();
            activePlatform.pos(pos.x, pos.y, pos.x, pos.y);
        }
    } else if (mode == 2) {
        if (!isPlacingPlatform) {
            pos - mouseDownPos => vec3 offset;
            if (offset.magnitude() >= 0.1) {
                true => isPlacingPlatform;
                activePlatform.pos(mouseDownPos.x, mouseDownPos.y, pos.x, pos.y);
            }
        } else {
            activePlatform.pos2(pos.x, pos.y);
        }
    } else if (mode == 3) {
        pos => mouseDownPos;
    }
}

fun void pushActivePlatform() {
    platforms << activePlatform;
    new Platform() @=> activePlatform;
    activePlatform.show();
}







// /-------------------------------------------------\
// |                      TOOLS                      |
// \-------------------------------------------------/

0 => int TOOL_PLATFORM;
1 => int TOOL_DELETE;

TOOL_PLATFORM => int tool;

Platform @ selectedDeletePlatform;
GGen deleteIcon;

fun makeDeleteIcon() {
    0.07 => float sz;
    @(240, 22, 49) / 255.0 => vec3 color;

    GLines l1;
    [@(-sz, -sz), @(sz, sz)] => l1.positions;
    color => l1.color;
    0.05 => l1.width;
    l1 --> deleteIcon;

    GLines l2;
    [@(-sz, sz), @(sz, -sz)] => l2.positions;
    color => l2.color;
    0.05 => l2.width;
    l2 --> deleteIcon;
}
makeDeleteIcon();

fun void disableTool(int id) {
    if (id == TOOL_PLATFORM) {
        activePlatform.hide();
        false => isPlacingPlatform;
    } else if (id == TOOL_DELETE) {
        deleteIcon --< scene;
        if (selectedDeletePlatform != null) {
            selectedDeletePlatform.setHighlighted(false);
            null @=> selectedDeletePlatform;
        }
    }
}

fun void enableTool(int id) {
    if (id == TOOL_PLATFORM) {
        activePlatform.pos(-727, -727, -727, -727);
        activePlatform.show();
    } else if (id == TOOL_DELETE) {
        mouse.worldPos => deleteIcon.pos;
        deleteIcon --> scene;
    }
}

fun void switchTool(int id) {
    disableTool(tool);
    id => tool;
    enableTool(tool);
}

fun void checkDeletePlatform(vec3 pos3) {
    @(pos3.x, pos3.y) => vec2 pos;
    1e9 => float closest;
    null @=> Platform @ newDeletePlatform;
    for (Platform @ p : platforms) {
        segDist(p.oneSeg(), pos) => float curDist;
        if (curDist < closest) {
            curDist => closest;
            p @=> newDeletePlatform;
        }
    }
    if (closest > 0.4) {
        if (selectedDeletePlatform != null) {
            selectedDeletePlatform.setHighlighted(false);
            null => selectedDeletePlatform;
        }
    } else {
        if (selectedDeletePlatform != null) {
            selectedDeletePlatform.setHighlighted(false);
        }
        newDeletePlatform @=> selectedDeletePlatform;
        selectedDeletePlatform.setHighlighted(true);
    }
}

fun void deleteSelected() {
    if (selectedDeletePlatform != null) {
        selectedDeletePlatform.delete();
        for (int i; i < platforms.size(); i++) {
            if (platforms[i] == selectedDeletePlatform) {
                platforms.popOut(i);
                break;
            }
        }
    }
}





// /-----------------------------------------------------\
// |                      WATERFALL                      |
// \-----------------------------------------------------/

0.4 => float waterfallSpeed; // how many sweeps per second

WfSeg waterfallSegs[0];
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
    cross(s2.b - s2.a, s1.a - s2.a) => float oa;
    cross(s2.b - s2.a, s1.b - s2.a) => float ob;
    cross(s1.b - s1.a, s2.a - s1.a) => float oc;
    cross(s1.b - s1.a, s2.b - s1.a) => float od;
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
// if horizontal, returns endpoint in bias direction
fun vec2 downSlope(WfSeg s, vec2 bias) {
    if (s.a.y == s.b.y) {
        if (bias.x >= 0) {
            if (s.a.x >= s.b.x) return s.a;
            return s.b;
        } else {
            if (s.a.x <= s.b.x) return s.a;
            return s.b;
        }
    } else if (s.a.y > s.b.y) {
        return s.b;
    } else {
        return s.a;
    }
}

// algorithm for computing the waterfall
fun void computeSegs(float waterfallX) {
    new WfSeg[0] @=> waterfallSegs;
    getScreenSize().y / 2.0 => float yLimit;

    @(waterfallX, yLimit) => vec2 pt;
    WfSeg checkSeg(pt, pt + @(0, -100));

    WfSeg pSegs[0];
    for (Platform @ p : platforms) {
        p.getSegs(pSegs);
    }
    if (isPlacingPlatform && tool == TOOL_PLATFORM) activePlatform.getSegs(pSegs);

    now => time checkTime;
    while (true) {
        // check for highest intersecting platform
        NULL_PT => vec2 highPt;
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
            if (curPt.y > highPt.y) {
                curPt => highPt;
                pSeg @=> highSeg;
            } 
        }

        if (ptsEqual(highPt, NULL_PT)) {
            // no intersections
            checkSeg.b => pt;
            waterfallSegs << checkSeg;
            if (pt.y < -yLimit) break;
            // fall down edge
            new WfSeg(pt, pt + @(0, -100)) @=> checkSeg;
            continue;
        }

        if (ptsEqual(highPt, pt)) {
            // stuck in a V
            break;
        }

        // intersects with some segment
        // if checkSeg is vertical, cause a hit
        if (checkSeg.b.x == checkSeg.a.x) {
            (pt.y - highPt.y) / (2 * yLimit) => float dist;
            highSeg.p.hit(checkTime, dist, highPt);
        }

        waterfallSegs << new WfSeg(pt, highPt);
        highPt => pt;
        new WfSeg(pt, downSlope(highSeg, checkSeg.b - checkSeg.a)) @=> checkSeg;
    }

    for (Platform @ p : platforms) {
        p.checkUnhit(checkTime);
    }
    activePlatform.checkUnhit(checkTime);
}

GLines waterfallLines --> scene;
@(0, 0, 1) => waterfallLines.color;
0.2 => waterfallLines.posZ;
fun void drawWaterfall() {
    if (waterfallSegs.size() == 0) {
        new vec2[0] => waterfallLines.positions;
        // nothing to draw
        return;
    }

    vec2 linesPos[0];
    linesPos << @(waterfallSegs[0].a.x, waterfallSegs[0].a.y);
    for (WfSeg seg : waterfallSegs) {
        linesPos << @(seg.b.x, seg.b.y);
    }

    linesPos => waterfallLines.positions;
}

fun void updateWaterfall() {
    GG.nextFrame() => now;
    // need to have a frame elapsed for screen size to exist
    getScreenSize().x / -2.0 * FALL_AREA => float waterfallStartX;
    -waterfallStartX => float waterfallEndX;

    waterfallStartX => float waterfallX;

    while (true) {
        GG.nextFrame() => now;

        // compute new position
        GG.dt() => float frameTime;
        frameTime * (waterfallEndX - waterfallStartX) * waterfallSpeed +=> waterfallX;
        if (waterfallX > waterfallEndX) {
            waterfallX - waterfallStartX => float offset;
            waterfallEndX - waterfallStartX %=> offset;
            waterfallStartX + offset => waterfallX;
        }

        computeSegs(waterfallX);
        drawWaterfall();
    }
}
spork ~ updateWaterfall();





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

fun void handleClicks() {
    while (true) {
        GG.nextFrame() => now;
        if (GWindow.mouseLeft() && !clicking) {
            // mouse click start
            true => clicking;
            if (tool == TOOL_PLATFORM) activePlatformUpdate(mouse.worldPos, 3);
        } else if (!GWindow.mouseLeft() && clicking) {
            // mouse click end
            false => clicking;
            if (tool == TOOL_PLATFORM) activePlatformUpdate(mouse.worldPos, 1);
            if (tool == TOOL_DELETE) deleteSelected();
        } else if (GWindow.mouseLeft() && clicking) {
            // mouse dragged
            if (tool == TOOL_PLATFORM) activePlatformUpdate(mouse.worldPos, 2);

        } else if (!GWindow.mouseLeft() && !clicking) {
            // mouse hovered
            if (tool == TOOL_PLATFORM) activePlatformUpdate(mouse.worldPos, 0);
        }

        if (tool == TOOL_DELETE) {
            mouse.worldPos => deleteIcon.pos;
            checkDeletePlatform(mouse.worldPos);
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
                switchTool(TOOL_DELETE);
            } else {
                switchTool(TOOL_PLATFORM);
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

activePlatform.show();

while (true) {
    GG.nextFrame() => now;

    createGuidelines();
    activePlatform.color(curHue);

    // if (UI.begin("")) { UI.scenegraph(scene); } UI.end();
}
