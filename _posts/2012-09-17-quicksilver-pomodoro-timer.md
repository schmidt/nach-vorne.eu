---
title: "Using Quicksilver as simple Pomodoro timer"
layout: post
tags : [productivity, mac, quicksilver]
---
{% include JB/setup %}

Inspired by [a
talk](https://speakerdeck.com/u/wikimatze/p/time-management-with-the-pomodoro-technique)
at the [local ruby user group](http://www.rug-b.de), I started to use
[the Pomodoro technique](http://www.pomodorotechnique.com/) to structure my work
and breaks.

In order to get quickly started, I was looking for an easy way to start a timer
on my Mac. After a quick look on _the interwebs_ for a little helper I simply
gave up, due to the vast amount of different options and interfaces. I the
settled for a low-tech version using [Quicksilver](http://qsapp.com/).

## Using Quicksilver for simple timers

All I wanted to do, is get a simple pop-up after 25 minutes. Here is what you
need to do:

1. Fire up Quicksilver: <kbd title="Option">⌥</kbd> + <kbd>Space</kbd>
2. Switch to text mode: <kbd>.</kbd>
3. Type <kbd>Pomodoro</kbd> or anything else that helps
4. Confirm with <kbd title="Tab">⇥</kbd>
5. Hit <kbd title="Control">^</kbd> + <kbd title="Return">↩</kbd>
6. Type: <kbd>Run after Delay...</kbd> or a significant portion of it
7. Confirm with <kbd title="Tab">⇥</kbd>
8. Enter <kbd>25m</kbd> - which is short for 25 minutes
9. Hit <kbd title="Return">↩</kbd>
10. Enjoy

After 25 minutes you will see a large "Pomodoro" on your screen. Be careful
though, any key will dismiss the message. So it might happen, that it is gone
before you notice.

Also there is no way, that I know of, to get a notion how much time already
passed. I am also using a time tracking tool, which gives me an idea how much I
am into the current pomodoro, if I need a little motivation.

For now, this solution gives me what I want without the need to install
additional software. So it is a perfect fit.

**Note**: You can use the Quicksilver timer feature with any other command. You
could open [a website](http://nyan.cat/) at 12 o'clock to get a lunch reminder
or hit play in iTunes after 20 minutes to wake up from your office nap. It's all
at your fingertips.
