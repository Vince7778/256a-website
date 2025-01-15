<script>
    import Section from "$lib/components/Section.svelte";
    import { pageTitle, course } from "$lib";
    $course = "256a";
    import ArtDes from "$lib/components/ArtDes.svelte";
    import Quote from "$lib/components/Quote.svelte";

    // remember to add to Header.svelte
    $pageTitle = "RR2";
</script>

<Section title="Chapter 2 Reading Response">
    <p>
        I wanted to discuss the reaction during the interview to the Ocarina app found in <ArtDes />,
        chapter 2, page 89. At the time, with this new technology of mobile phones becoming more
        accessible, it seems like there was concern that these virtual instruments would begin to
        replace traditional instruments. Maybe people would stop learning how to play physical
        instruments in favor of using a computer instead, and a part of our past would be lost.
    </p>
    <p>
        This strongly reminds me of when large language models started becoming popular. The
        immediate reaction from many people was concern about how the new technology would displace
        writers and artists. We've never before had the ability to automatically generate text or
        images at a quality similar to how humans can do it. Maybe people would stop learning how to
        paint or draw in favor of using AI instead, and a part of our past would be lost.
    </p>
    <p>
        But of course, with the Ocarina and other virtual instruments, people didn't stop learning
        physical instruments. It still seems like they are as popular as ever. And I think that in a
        similar vein, the advent of AI writing and art also won't bring about the end of humans
        doing these things. I believe it will most likely just become another genre, or another
        medium for human creativity. People will still be learning to draw and write by themselves
        as much as ever, and there will still be demand for people who know how to do those things.
    </p>
    <p>
        A couple weeks ago, I read an essay by Brian Eno, one of the pioneers of electronic music.
        He was discussing the advent of the studio for music composition, and he notes:
    </p>
    <Quote citation={'Brian Eno, "The Studio as a Compositional Tool" (1983)'}>
        <p>
            It doesn't mean that suddenly the world is open, and we're going to do much better
            music, because we're not constrained in certain ways. We're going to do different music
            because we're not constrained in certain ways we operate under a different set of
            constraints.
        </p>
    </Quote>
    <p>
        I think this also applies perfectly to both the Ocarina and AIs. These new tools can't
        replace previous kinds of music because they are actually entirely separate things. They'll
        mainly allow us to get around previous constraints, like not being able to buy an
        instrument. As Ge put it in
        <ArtDes />, by creating electronic instruments or furthering the field of AI, we are being
        explorers, not destroyers.
    </p>
</Section>
