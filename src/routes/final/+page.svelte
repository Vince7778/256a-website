<script>
    import { pageTitle } from "$lib";
    import Image from "$lib/components/Image.svelte";
    import Link from "$lib/components/Link.svelte";
    import Section from "$lib/components/Section.svelte";
    import Video from "$lib/components/Video.svelte";

    // remember to add to Header.svelte
    $pageTitle = "Final";
</script>

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
