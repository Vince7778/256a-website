<script>
    import Section from "$lib/components/Section.svelte";
    import { pageTitle } from "$lib";
    import ArtDes from "$lib/components/ArtDes.svelte";
    import Image from "$lib/components/Image.svelte";

    // remember to add to Header.svelte
    $pageTitle = "RR7";
</script>

<Section title="Chapter 7 Reading Response">
    <p>
        Just this morning, I came across this blog post:
        <a href="https://interconnected.org/home/2024/09/05/cursor-party"
            >Every webpage deserves to be a place.</a>
        The author, Matt Webb, created a system that showed other readers' cursors on the same webpage,
        and even included a chatting function. Apart from being an interesting read, I'm so glad I found
        this post because I think it perfectly exemplifies the concepts taught in <ArtDes /> chapter
        7. So much so that it makes me wonder whether he's read this book.
    </p>
    <Image src="/rr7/cursor-party.png" alt="blog post with someone else's cursor" limit={300} />
    <p>
        There's so many parts of it that work right. It uses technology to make something normally
        private (reading an article) into a social activity, letting you see and interact with other
        people doing the same thing. It shows the flags of the country each cursor is from, giving
        you a sense of globality.
    </p>
    <p>
        The most interesting aspect to me is how personal it feels, despite being totally anonymous.
        Matt likened it to being in a small art gallery when one other person walks in, to look at
        the same paintings you are. It can be a little jarring to know that when you're just trying
        to relax and read something online, there's someone else there with you watching as you do.
        But it also really makes you think about who they are and what brought them to this place at
        this time. That alone gives you some sort of connection with them, and maybe a starting
        point for a conversation.
    </p>
    <p>
        In general I love all the physical metaphors Matt gives to his feature. He points out that
        when there are many people on a blog post, and their cursors are everywhere making the
        article hard to read, it's like seeing a crowd in real life and wondering what they're all
        looking at. These ideas of making an online space more similar to a physical space could
        really do a lot to make the internet feel more connected and social, rather than stuck
        behind a screen.
    </p>
</Section>
