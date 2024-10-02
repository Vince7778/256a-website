<script>
    import Section from "$lib/components/Section.svelte";
    import { pageTitle } from "$lib";
    import Image from "$lib/components/Image.svelte";
    import Todo from "$lib/components/Todo.svelte";
    import Video from "$lib/components/Video.svelte";
    import CoolBox from "$lib/components/CoolBox.svelte";
    import Audio from "$lib/components/Audio.svelte";
    import Link from "$lib/components/Link.svelte";

    $pageTitle = "HW1";
</script>

<Section title="Part 1: Reading Response">
    <p>
        I wanted to respond to the idea of the <i>sublime</i>, found in <i>Artful Design</i>,
        chapter 1, page 50. When I initially read this section, the description of a sublime
        experience really resonated with me. I felt like I had had this experience several times in
        the past. At one point I had even described it to my friends on Discord (at an appropriate
        time of day):
    </p>
    <Image src="/hw1/ss1.png" alt="me trying to describe a sublime experience to my friends" />
    <p>
        The mood seemed to match incredibly closely to Ge's idea of the sublime: wonder and yet also
        terror.
    </p>
    <Image src="/hw1/ss2.png" alt="describing my emotions" />
    <p>
        At the time I had no idea of any sort of name for this phenomenon, or even any idea whether
        anyone else had experienced this, so I was extremely thankful to see it laid out in <i
            >Artful Design</i
        >. Maybe it's not so indescribable after all.
    </p>
    <p>
        But I also had my doubts. These things that triggered a sublime experience tended to fall
        significantly more into the "end-in-itself" category. This particular sublime experience
        above was from seeing a <a href="https://www.youtube.com/watch?v=L-c_g9Mx3T4"
            >awesome song with a very artistic storyboard.</a>
        Yet in <i>Artful Design</i>, the main point of the discussion was about things that were not
        only ends-in-themselves, but also means-to-ends. This made me wonder, are my experiences not
        true sublime experiences in the way that Ge had described them?
    </p>
    <p>
        After some reconsideration (and rereading a few days later), I think that yes, I had in fact
        experienced a true sublime experience. I believe I had misinterpreted the text as saying
        that sublime experiences always must come from artful design, when in fact it is possible to
        feel the sublime from things that are not. The point I believe Ge was trying to make is that
        in attempting to design, you should strive to trigger these experiences, as they are a
        natural result of seeing artful design. Ge notes that the sublime can be "induced by
        poetics, art, moral action, spirituality, [and] objects of nature", and these often don't
        have a designed function associated with them.
    </p>
    <p>
        In the end, I'm very thankful to have experienced the sublime, and thankful for my past self
        for caring and writing down my thoughts about them. I believe that with this perspective,
        I'll be able to have a much better idea what to strive for when attempting artful design.
    </p>
</Section>

<Section title="Part 2a: Taking Notice">
    <CoolBox>
        <p><b>Item 1: <i>Mosa Lina</i></b></p>
        <p>
            No, I didn't misspell the painting. <a
                href="https://store.steampowered.com/app/2477090/Mosa_Lina/"><i>Mosa Lina</i></a> is
            an indie game described as "a hostile interpretation of the immersive sim". Gameplay is as
            follows: you are a little guy with slow movement, a tiny jump, and a gun. Your gun can shoot
            two different things, randomly chosen out of options including boxes, rocketships, anti-gravity
            fields, the gun itself, frogs, and more. Your goal is, for each level, to collect the fruit
            and then get to the portal.
        </p>
        <p>
            The reason this game is called <i>hostile</i> is because there's no intended solution to
            any level, and sometimes beating the level may even be impossible with your given set of
            tools. The reason this game is <i>awesome</i> is because within these limitations, you can
            come up with absurd and creative solutions that leave you going "that really shouldn't have
            worked".
        </p>
        <p>
            Here's a clip of me playing co-op mode with my friend. I'm on the left, he's on the
            right. At this point, we're <i>almost</i> to the portal, but a gap is in my way; too far
            to jump even with that floating block in the middle. We're almost completely out of options,
            as my gun ran out of charge and my friend only has one bomb left. But we formulate a plan:
            I will jump on the platform while he shoots the bomb, then I will proceed to jump on the
            bomb itself and get boosted to the platform.
        </p>
        <p>(profanity warning)</p>
        <Video w={480} h={270} src="/hw1/mosa-lina.mp4" />
        <p>And miraculously, the plan worked!</p>
        <p>
            I consider this game to be design because of how simple it is, and despite its
            simplicity, so much creativity can emerge from it. I can't imagine that the developers
            explicity thought of even a fraction of the potential solutions to their levels, but
            they designed the game to have cool interactions, and successfully created a sandbox
            that allows the players to innovate. There's very few other games I'm aware of that
            manage to create this much depth using so little material.
        </p>
        <p>
            I only got this game recently, but I already couldn't recommend it enough. Especially if
            you have a friend to play it with in coop mode, this game is incredibly fun.
        </p>
    </CoolBox>
    <CoolBox>
        <b>Item 2: this sprinkler</b>
        <Image limit={300} src="/hw1/impact_sprinkler.jpg" alt="an image of an impact sprinkler" />
        <p>
            This is an <a href="https://en.wikipedia.org/wiki/Impact_sprinkler">impact sprinkler</a
            >. We have one of these at my house. It works by shooting out a single stream of water,
            then having a hammer pivot in front of the stream, causing the water's energy to push
            the hammer to the side, making the entire sprinkler head rotate. These kinds of
            sprinklers have a distinctive noise, which I used to fall asleep to at home:
        </p>
        <Audio loop src="/hw1/sprinkler.mp3" />
        <p>
            You might notice that it's not clicking at a constant rate. That's because at a certain
            point, the sprinkler head hits a limiter, which then causes a mechanical switch to flip
            and the sprinkler head starts rotating the other way, until it hits another limiter.
            These limiters are adjustable, so you can easily make the sprinkler only water a certain
            patch of grass, instead of getting water everywhere in a full circle.
        </p>
        <p>
            I find these sprinklers to be design because of their simplicity and mechanical nature.
            All they need to be powered is the force of the water hitting the hammer, and the
            mechanism which reverses its direction is also very simple, which I think is neat. These
            are starting to be phased out in favor of silent, gear-based sprinklers, which I find
            kind of a shame because I sort of enjoy the rhythmic noises these ones make, even if it
            may be annoying to others.
        </p>
        <p>
            I was made aware of this piece of design by <a
                href="https://www.youtube.com/watch?v=jKi7xGE4BEw"
                >this Technology Connections video</a
            >. He explains in more detail than I can about how exactly these sprinklers work. His
            channel is great in general; I highly recommend checking it out if you enjoy learning
            about bits of design in household appliances.
        </p>
    </CoolBox>
    <CoolBox>
        <b>Item 3: Emoji</b>
        <p>
            I ❤️ emoji. I use them all the time when chatting with friends. I would use them here
            too if there was an easier way to type them.
        </p>
        <p>
            I think emojis are design because I think they're a great way of conveying human
            emotion. They say a picture is worth a thousand words, and while I think that may be an
            overestimate for emoji, I sure think typing 🤨 is a lot more convenient than typing out
            "are you sure about that?" They're also aesthetically nice, as it's pleasing to see
            little pictures decorating boring walls of text.
        </p>
        <p>
            I also think emoji are cool from a linguistic perspective. It's kind of a callback to
            back when we used to use pictograms for everything, and combined with regular text it
            makes our communication a lot more powerful.
        </p>
    </CoolBox>
</Section>

<Section title="Part 2b: Guerrilla Design">
    <p>
        I play <a href="https://osu.ppy.sh">the rhythm game osu!</a>. I have this cute little keypad
        called the <a href="https://wooting.io/uwu">Wooting UwU</a>:
    </p>
    <Image limit={300} src="/hw1/wooting.jpg" alt="my Wooting UwU" />
    <p>
        Its primary feature is that the three main keys are <i>analog switches</i>, meaning they
        aren't just off or on, they output the percentage they are pressed. This gives an advantage
        in rhythm games because it means you don't always have to fully depress the key to get an
        input, as you can configure it to type when it's partially pressed. This allows you to press
        it more rapidly, increasing your speed for fast sections of a song.
    </p>
    <p>
        There are multiple versions of this particular keypad, but I was feeling fancy so I spent a
        little more to get the edition in a black color scheme with full RGB colors. But as I mostly
        cared for the rapid trigger functionality, I never ended up really customizing the RGB. I
        just left it on its default color profile, which you can see above. However, in the back of
        my mind I was always thinking about how to make the lighting a little bit cooler. And this
        design etude finally gave me the motivation to do it!
    </p>
    <p>
        <b>The Plan:</b> integrate the keypad's RGB lighting with my osu! gameplay, flashing blue if
        I get a 300, green for a 100, yellow for a 50, and red for a miss.
    </p>
    <Section sub title="Attempt 1: Using Wooting Software">
        <p>
            Wooting provides their own software for customizing the RGB, called Wootility. It's
            still in beta, and fairly basic, so all I could create in terms of lighting based off
            key presses is this:
        </p>
        <Video w={480} h={270} src="/hw1/wootility-lights.mp4" />
        <p>
            The colors are static, and it's not synced to anything in osu!, so this isn't very
            exciting for me. Looks like I'll have to take matters into my own hands.
        </p>
    </Section>
    <Section sub title="Attempt 2: Wooting SDK">
        <p>
            Fortunately for me, Wooting provides <a
                href="https://github.com/WootingKb/wooting-analog-sdk">their own SDK</a>
            for interfacing with and customizing their analog keyboards. People have also
            <a href="https://github.com/ShayBox/Wooting-RGB"
                >written libraries for controlling RGB</a> in my favorite language, Rust. So I got to
            work and started writing my own application.
        </p>
        <p>
            First I wanted to just work with the keyboard, as integration with osu! is a little bit
            complicated. I used the RGB library that someone else had written, but I also needed to
            detect the keystrokes from the keypad, so I had to use the Wooting SDK itself as well.
            (Luckily, they also use Rust.) At first I made a light appear on the most recently
            pressed key:
        </p>
        <Video w={270} h={480} src="/hw1/sdk-simple.mp4" />
        <p>Then I added colors and a fading effect:</p>
        <Video w={270} h={480} src="/hw1/sdk-fading.mp4" />
        <p>Then it was time to connect it to osu!.</p>
    </Section>
    <Section sub title="osu! Integration">
        <p>
            Connecting the keypad to osu! is not easy. The osu! client doesn't have any kind of API,
            so there's no direct way to access the information of how accurate a hit was. But
            fortunately, someone in the community made a program called <b
                ><a href="https://github.com/l3lackShark/gosumemory">gosumemory</a></b
            >. This program directly reads the memory of osu!, and outputs to a webhook the current
            state every so often. I can read from this webhook using my program to figure out what
            color to display.
        </p>
        <p>
            Implementing this was difficult because of race conditions. The webhook and the keypad
            input run on different intervals, so syncing them up properly was difficult. In the end,
            I decided to only read keypad input whenever a webhook event is received, which is
            slightly inaccurate because it can miss inputs. There were also multiple different
            libraries for using webhooks, and the one I used initially turned out to not work for my
            purposes, as it was old and didn't have a proper async implementation.
        </p>
    </Section>
    <p>
        So here's the result! This is a video of me playing a map in osu!, and you can see that a
        key flashes blue when I hit a note on time, green if I get a 100 (which you can see in the
        gameplay) and red if I miss.
    </p>
    <Video w={480} h={270} src="/hw1/final-result.mp4" />
    <p>
        Overall I'm really happy with how this project turned out. It definitely makes my gameplay
        look fancier! Unfortunately I'm not able to use it all the time, as the version of osu! I
        play normally is not supported by gosumemory. I've made the project <a
            href="https://github.com/Vince7778/osu-glow">open source on GitHub</a
        >, if you want to try it out yourself or look at the code.
    </p>
</Section>

<Section title="Part 3: ChucK">
    <p>I made an automatic jazz solo generator (including drums!)</p>
    <p><Link href="/hw1/jazz_solo.ck" download="jazz_solo.ck">Download here</Link></p>
</Section>
