<script>
    import { pageTitle } from "$lib";
    import Image from "$lib/components/Image.svelte";
    import Link from "$lib/components/Link.svelte";
    import Section from "$lib/components/Section.svelte";
    import Video from "$lib/components/Video.svelte";

    // remember to add to Header.svelte
    $pageTitle = "Final";
</script>

<Section title="Final Project">
    <p style="font-size: 2em"><b><u>Nothing to See</u></b></p>
    <p>An audiovisual puzzle platformer... without visuals?</p>
    <Video src="/final/final_final.mp4" w={1280} h={720} />
    <Section sub title="Screenshots">
        <div id="captures">
            <Image src="/final/final_ss1.png" alt="final project screenshot 1" limit={250} />
            <Image src="/final/final_ss2.png" alt="final project screenshot 2" limit={250} />
            <Image src="/final/final_ss3.png" alt="final project screenshot 3" limit={250} />
            <Image src="/final/final_ss4.png" alt="final project screenshot 4" limit={250} />
        </div>
    </Section>
    <Section sub title="How to run">
        <p>
            I have hosted the code on GitHub at <a
                target="_blank"
                href="https://github.com/Vince7778/256a-final">this link</a
            >. I highly recommend just cloning this repository, but in case that doesn't work
            <Link href="/final/final_code.zip" download="conork_final_code.zip"
                >here's the zipped code</Link
            >. Run the code with <code>chuck main.ck</code>.
        </p>
        <p>Features:</p>
        <ul>
            <li>
                Full collision detection with walls (adapted from <a
                    target="_blank"
                    href="https://github.com/kikito/bump.lua">bump.lua</a
                >)
            </li>
            <li>
                Audio spatialization engine (adapted from <a
                    target="_blank"
                    href="https://miniaud.io/">miniaudio</a
                >)
            </li>
            <li>Text-based level editor</li>
            <li>In-game replay system to see what you did wrong</li>
            <li>2,332 lines of ChucK code across 25 files</li>
        </ul>
    </Section>
</Section>

<Section title="Final Project Milestone 2">
    <Video src="/final/final_milestone_2.mp4" w={1280} h={720} />
</Section>

<Section title="Final Project Milestone 1">
    <Video src="/final/final_milestone_1.mp4" w={1280} h={720} />
    <Section sub title="Design 1">
        <Image limit={480} src="/final/final_design1.jpg" alt="sketch of design 1" />
        <p>
            This design (which is the one I ended up implementing) is based off being unable to see.
            As the project is very audio focused, I thought it would be fun to take away vision
            completely for some time and have players try and navigate just by sound. The player is
            able to place "sound orbs" around the area, and then using spatial audio they play
            through the whole level again while totally blind. There will be elements like moving
            platforms and randomness in order to make it not totally memorizable.
        </p>
    </Section>
    <Section sub title="Design 2">
        <Image limit={480} src="/final/final_design2.jpg" alt="sketch of design 2" />
        <p>
            The idea of this design is that you're stuck in a maze or some sort of area with lots of
            obstacles. There are a few key points (represented by stars) and your goal is to find a
            position where you can see all the key points at once. The audio aspect of this is that
            each point plays a different part of a song when it's visible, so when you can see all
            the points, the song is complete.
        </p>
    </Section>
    <Section sub title="Design 3">
        <Image limit={480} src="/final/final_design3.jpg" alt="sketch of design 3" />
        <p>
            This design is inspired by the term "anti-rhythm game". Instead of trying to hit notes
            to the beat, your goal is to try and dodge the notes as they come down. I feel like this
            could lead to a lot of interesting, high-skill gameplay, and twists could be added like
            multiple notes at once or bonus items that are tough to reach.
        </p>
    </Section>
</Section>

<style>
    #captures {
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        gap: 0 5px;
    }
</style>
