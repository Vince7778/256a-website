<script>
	import Section from "$lib/components/Section.svelte";
    import { pageTitle } from "$lib";
	import Image from "$lib/components/Image.svelte";
	import Todo from "$lib/components/Todo.svelte";
	import Video from "$lib/components/Video.svelte";

    $pageTitle = "HW1";
</script>

<Section title="Part 1: Reading Response">
    <p>
        I wanted to respond to the idea of the <i>sublime</i>, found in <i>Artful Design</i>, chapter 1, page 50.
        When I initially read this section, the description of a sublime experience really resonated with me. 
        I felt like I had had this experience several times in the past. At one point I had even described it to my friends on Discord (at an appropriate time of day):
    </p>
    <Image src="/hw1/ss1.png" alt="me trying to describe a sublime experience to my friends" />
    <p>
        The mood seemed to match incredibly closely to Ge's idea of the sublime:
        wonder and yet also terror.
    </p>
    <Image src="/hw1/ss2.png" alt="describing my emotions" />
    <p>
        At the time I had no idea of any sort of name for this phenomenon, or even any idea whether anyone else had experienced this, so I was extremely thankful to see it laid out in <i>Artful Design</i>.
        Maybe it's not so indescribable after all.
    </p>
    <p>
        But I also had my doubts. These things that triggered a sublime experience tended to fall significantly more into the "end-in-itself" category.
        This particular sublime experience above was from seeing a <a href="https://www.youtube.com/watch?v=L-c_g9Mx3T4">awesome song with a very artistic storyboard.</a>
        Yet in <i>Artful Design</i>, the main point of the discussion was about things that were not only ends-in-themselves, but also means-to-ends.
        This made me wonder, are my experiences not true sublime experiences in the way that Ge had described them?
    </p>
    <p>
        After some reconsideration (and rereading a few days later), I think that yes, I had in fact experienced a true sublime experience.
        I believe I had misinterpreted the text as saying that sublime experiences always must come from artful design, when in fact it is possible to feel the sublime from things that are not.
        The point I believe Ge was trying to make is that in attempting to design, you should strive to trigger these experiences, as they are a natural result of seeing artful design.
        Ge notes that the sublime can be "induced by poetics, art, moral action, spirituality, [and] objects of nature", and these often don't have a designed function associated with them.
    </p>
    <p>
        In the end, I'm very thankful to have experienced the sublime, and thankful for my past self for caring and writing down my thoughts about them.
        I believe that with this perspective, I'll be able to have a much better idea what to strive for when attempting artful design.
    </p>
</Section>

<Section title="Part 2: Design Etude">
    <Section sub title="Part 2.1: Taking Notice">
        <Todo>write this section</Todo>
    </Section>
    <Section sub title="Part 2.2: Means and Ends">
        <Todo>write this section too</Todo>
    </Section>
    <Section sub title="Part 2.3: Guerrilla Design">
        <p>
            I play <a href="https://osu.ppy.sh">the rhythm game osu!</a>. 
            I have this cute little keypad called the <a href="https://wooting.io/uwu">Wooting UwU</a>:
        </p>
        <Image limit={300} src="/hw1/wooting.jpg" alt="my Wooting UwU" />
        <p>
            Its primary feature is that the three main keys are <i>analog switches</i>, meaning they aren't just off or on, they output the percentage they are pressed.
            This gives an advantage in rhythm games because it means you don't always have to fully depress the key to get an input, as you can configure it to type when it's partially pressed.
            This allows you to press it more rapidly, increasing your speed for fast sections of a song.
        </p>
        <p>
            There are multiple versions of this particular keypad, but I was feeling fancy so I spent a little more to get the edition in a black color scheme with full RGB colors.
            But as I mostly cared for the rapid trigger functionality, I never ended up really customizing the RGB. I just left it on its default color profile, which you can see above.
            However, in the back of my mind I was always thinking about how to make the lighting a little bit cooler.
            And this design etude finally gave me the motivation to do it!
        </p>
        <p>
            <b>The Plan:</b> integrate the keypad's RGB lighting with my osu! gameplay,
            flashing blue if I get a 300, green for a 100, yellow for a 50, and red for a miss.
        </p>
        <Section sub title="Attempt 1: Using Wooting Software">
            <p>
                Wooting provides their own software for customizing the RGB, called Wootility. 
                It's still in beta, and fairly basic, so all I could create in terms of lighting based off key presses is this:
            </p>
            <Video w={480} h={270} src="/hw1/wootility-lights.mp4" />
            <p>
                The colors are static, and it's not synced to anything in osu!, so this isn't very exciting for me.
                Looks like I'll have to take matters into my own hands.
            </p>
        </Section>
        <Section sub title="Attempt 2: Wooting SDK">
            <p>
                Fortunately for me, Wooting provides <a href="https://github.com/WootingKb/wooting-analog-sdk">their own SDK</a> for interfacing with and customizing their analog keyboards.
                People have also <a href="https://github.com/ShayBox/Wooting-RGB">written libraries for controlling RGB</a> in my favorite language, Rust.
                So I got to work and started writing my own application.
            </p>
            <p>
                First I wanted to just work with the keyboard, as integration with osu! is a little bit complicated.
                I used the RGB library that someone else had written, but I also needed to detect the keystrokes from the keypad,
                so I had to use the Wooting SDK itself as well. (Luckily, they also use Rust.) At first I made a light appear on the most recently pressed key:
            </p>
            <Video w={270} h={480} src="/hw1/sdk-simple.mp4" />
            <p>
                Then I added colors and a fading effect:
            </p>
            <Video w={270} h={480} src="/hw1/sdk-fading.mp4" />
            <p>
                Then it was time to connect it to osu!.
            </p>
        </Section>
        <Section sub title="osu! Integration">
            <p>
                Connecting the keypad to osu! is not easy. The osu! client doesn't have any kind of API, so there's no direct way to access
                the information of how accurate a hit was. But fortunately, someone in the community made a program called <b><a href="https://github.com/l3lackShark/gosumemory">gosumemory</a></b>.
            </p>
            <Todo>Finish writing this section</Todo>
        </Section>
    </Section>
</Section>
