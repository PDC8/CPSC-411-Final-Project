## Final Project - Part 3

This part is about showing off your work by **building a website** for your portfolio. Read the instructions below for what is needed.

Here are some examples of what I expect:
- https://bruggles718.github.io/ (Has everything, could perhaps be polished a bit, but this was overall an A+ project).
- https://hellowurld.notion.site/Bobotron-Game-Engine-f71ba78eac894dbfa16999e796347a65 (Has all of the requirements).
- https://lucasandoval.github.io/TinyShooterEngineWebsite/ (**This is the nicest designed of the 3 websites** -- this will show better on your portfolio)

## Step 0 - Engine Architecture Diagram

Your project should have an 'engine architecture' diagram on your website which describes the major components of the engine. Think of this as a high-level diagram you would give an engineer the first day of work so they would know the components and how they interact if they want to modify the engine. 

- Note: Some IDEs can automatically generate these diagrams, though you can draw it yourself and highlight the most important components. See [./media/C4Engine.pdf](./media/C4Engine.pdf) as an example. 
- Note: An 'inhertiance hierarchy' is not the same as a high level 'engine architecture diagram' -- I want to see the 'abstraction layers' and 'systems' implemented. For this course it may not be as detailed as the C4 Engine -- but I should still see some major system components (e.g. run-time game loop. resource manager, scene system, etc.)

## Step 1 - Documentation

Now that you are going to be maintaining the code for 'your game company' for many years, it is important to properly document your code. You will use 'DDoc' <a href="https://dlang.org/spec/ddoc.html">(DDoc)</a> to document the source code and automatically generate .html pages. Your documentation should cover your classes and functions.

An example of a well documented probjects can be found here: 

- https://www.ogre3d.org/docs/api/1.9/
- http://www.horde3d.org/docs/html/_api.html

### DDoc style comments

Some examples of documentation are listed here: https://dlang.org/spec/ddoc.html

Comments within code are in the style of:

```d
/// This is a one line documentation comment.

/** So is this. */

/++ And this. +/

/**
   This is a brief documentation comment.
 */

/**
 * The leading * on this line is not part of the documentation comment.
 */

/*********************************
   The extra *'s immediately following the /** are not
   part of the documentation comment.
 */

/++
   This is a brief documentation comment.
 +/

/++
 + The leading + on this line is not part of the documentation comment.
 +/

/+++++++++++++++++++++++++++++++++
   The extra +'s immediately following the / ++ are not
   part of the documentation comment.
 +/

/**************** Closing *'s are not part *****************/

/*! \brief Brief description.
 *         Brief description continued.
 *
 *  Detailed description starts here.
 */

int a;  /// documentation for a; b has no documentation
int b;

/** documentation for c and d */
/** more documentation for c and d */
int c;
/** ditto */
int d;

/** documentation for e and f */ int e;
int f;  /// ditto

/** documentation for g */
int g; /// more documentation for g

/// documentation for C and D
class C
{
    int x; /// documentation for C.x

    /** documentation for C.y and C.z */
    int y;
    int z; /// ditto
}

/// ditto
class D { }
```
**Note**: A helpful tool to use may be: [Doxywizard](http://www.doxygen.nl/manual/doxywizard_usage.html)

## Step 2 - Build (binary file)
You need to have a compiled binary of your game for your operating system (Either Windows, Mac, or Linux). You can assume a target audience of either a 64-bit Mac, Ubuntu Linux, or a Windows 10/11 machine. There should additionally be instructions about how to compile your code from source. The compilation should be trivial (running `dub` for example, or listing a series of 'apt-get install' in a single bash script you have built. **Make it trivial** so customers/course staff do not get frustrated :) ).

## Step 3 - Post mortem
A post mortem in games is a look back at what could be improved. Write a brief (2-3 paragraphs) on what could be improved if you had an additional 8 weeks to work on this project. Where would you allocate time, what tools would you build, would you use any different tools, etc.

*Edit here a draft of your post mortem here if you like--the final copy goes in your 1-page .html website. Think of this section as a good 'reflection' for what you can improve on your next project you complete.*

## Step 4 - Website

I think it is incredibly important to build a portfolio of your game development works! You will be building a 1 page website (it can be all html) to market your final project (Note: You could re-use this template for your next project, and potentially other personal projects).

The following are the requirements for a 1-page .html website.

1. Provide a 2-3 minute video trailer (preferably a link or embedded YouTube Video) followed by at least 3 screenshots of your game (order matters, video first, then screenshots below)
   - Your video should highlight the data-driven nature of your final project (show your engine and tools in use alongside the game)
3. Your documentation (i.e. a link to your doxygen generated files)
4. **An image** of your engine architecture.
5. A link to your binary
6. A short post mortem (i.e. A few paragraphs describing how you would take the project further, what went well, and what you would change if given another month on the project) should be put together on a 1-page .html page.
7. **DO not** make the course staff install 'npm' and run your website locally -- just provide a simple link to an html page (or a local html page here).
8. If you are hosting your website online (which I encourage), make sure to visit your link (e.g. Incognito/private mode) to make sure that I will also be able to visit the website and have access to all links provided.

This website will be the first place I look to grab your project files and binaries. 
