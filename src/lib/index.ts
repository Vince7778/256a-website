import { base } from "$app/paths";
import { writable, get, derived } from "svelte/store";

export const pageTitle = writable("");
export const devMode = writable(false);
export const course = writable("");

export const canonLink = derived(course, ($course) => {
    return (l: string) => {
        if ($course === "") return base + l;
        return base + "/" + $course + l;
    };
});
