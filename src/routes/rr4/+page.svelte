<script>
    import Section from "$lib/components/Section.svelte";
    import { pageTitle } from "$lib";
    import ArtDes from "$lib/components/ArtDes.svelte";

    // remember to add to Header.svelte
    $pageTitle = "RR4";
</script>

<Section title="Chapter 4 Reading Response">
    <p>
        I wanted to respond to the design of the language ChucK, in <ArtDes />, chapter 4, pages
        170-175. First I want to talk about the strong timing. I have a lot of experience
        programming in a variety of different languages, but a common theme among them is that time
        is a mostly uncontrollable consequence of your code. You almost always are trying to make
        your code run as fast as possible, meaning that the amount of time that elapses is
        unpredicable and varies based on whatever is inputted. Or you could be waiting for something
        to occur, whether that be a user input, or an API request.
    </p>
    <p>
        The closest thing to timing I've seen is when you have a set interval that you run code on
        every so often, like if you're drawing to the screen every frame. But even this isn't very
        constant, as frame rates tend to vary, and few programming languages have super precise
        timing.
    </p>
    <p>
        This makes me think that strongly-timed code like ChucK has is a very unique requirement.
        Unlike with visuals, we need to have the timing of audio exactly correct or else we will
        hear a noticeable difference. And in music, there tends to be lots of regularity in timing,
        with a set interval between beats, a set number of beats per bar, a set number of bars per
        phrase, and so on. Thus, this aspect of being able to precisely control the timing of your
        code running is essential to being able to easily program audio.
    </p>
    <p>
        ChucK also has probably the simplest parallelism I've ever seen, with just being able to
        call spork. All other languages I've used are all concerned about runtimes, mutexes and
        locks, race conditions, and so on, but ChucK just seems to not care and let you do whatever.
        I think a lot of this simplicity comes from the strongly-timed aspect, since you can control
        exactly when code runs if you know when a sample starts. I also think this simplicity is
        essential to audio programming, since as mentioned in <ArtDes />, it allows you to easily
        simulate multiple instruments at once, which is important for additive synthesis.
    </p>
    <p>
        From all this, I'd argue that Ge's "procrastination" in creating ChucK wasn't a waste at
        all. ChucK is a specialized tool, meant to solve a problem that no other programming
        language is particularly concerned with. And its design is very reflective of that, as it
        uses its strengths of strong timing and parallelism to the fullest extent and in a very
        clean way. I guess that means I consider ChucK itself to be artful design!
    </p>
    <p>
        As a side note, I found it funny that ChucK has built-in durations up to 1::week. Has anyone
        made any programs that run on this time scale?
    </p>
</Section>
