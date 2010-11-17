<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Fix missing brackets with Anchor</title>
<meta name="Generator" content="SciTE - www.Scintilla.org" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="c programming fix missing brackets refactoring refactor anchor pseudocode api compiler anch run other make windows tinycc terms linux line like input editor ide" />
<link rel="StyleSheet" HREF="anchor.css" TYPE="text/css" />
</head>
<body bgcolor="#FFFFFF"><div id="main"><h2>

<a href="http://anch.org">anch.org</a>: Anchor</h2><p>

<a>A</a>dvanced <a>N</a>egative <a>C</a>ompilation <a>H</a>euristic <a>O</a>ntological <a>R</a>efactorer</p><p>

Version: 1.6</p>

<img src="images/anchorcode.gif" alt="Anchor: for  i=5;i--;  C: for (i=5;i--;){"/><h3>

Why Anchor?</h3><p>

<a>If</a> (code == indented) {brackets = redundant}. Refactoring with Anchor saves typing and makes programs easier to read. Best of all, it's free!</p><p>

Techies might refer to it as a language-independent pseudocode compiler or code decorator but all it does is fix missing brackets and punctuation.</p><h3>

Where to get it</h3><p>

Anchor now is hosted on <a href="http://code.google.com/p/anch/">Google Code</a>. Subversion, user wiki and issue trackers available.</p><h3>

Installation</h3><p>

A windows .exe is provided already. Just copy it somewhere in the computer&apos;s path. Compilation on Linux and other systems requires <a href="http://flex.sourceforge.net/">flex</a> and a C compiler. <a href="http://code.google.com/p/anch/">Download</a> and extract the archive.</p>
<pre>
unzip anchor.zip
cd anchor
</pre><p>
Run &quot;make&quot; from within the newly extracted directory.</p>
<pre>
make
su -c &apos;make install&apos;</pre><h3>

Programming with Anchor</h3><p>

The rules are very simple. A double-space, &quot;&nbsp; &quot; (tells anchor to enclose the rest of the line in parenthesis). Indentation of 4 spaces {controls the placement of curly brackets}. The remaining lines are automatically terminated with semicolons; any of these rules may be overridden by placing whitespace or a <span class="S1">/* comment */</span> or <span class="S1">//</span> at the end of the line, causing the precompiler to skip the line in question.</p><h3>
Compilation</h3><p>

Example usage: converting example.a.c to C:</p>
<pre>
anchor example.a.c > example.c</pre><p>

Compiling the result with gcc (or any C compiler).</p>
<pre>
gcc example.c -o example.exe</pre><p>

If the indent style Anchor produces is undesirable for some reason, simply run <a href="http://www.gnu.org/software/indent/">GNU indent</a> on it. The default <a href="http://www.gnu.org/software/indent/">GNU indent</a> style should work for most people. See <a href="http://www.linuxmanpages.com/man1/indent.1.php">man indent</a> for more <a href="http://www.gnu.org/software/indent/">GNU indent</a> styles.</p>
<pre>
indent example.c</pre><p>

Anchor knows nothing about the underlying language, so it should process a variety of curly bracket languages. The author uses it on C code, but it should work with little or no change on C++, Java, .NET, PHP, Perl, awk and other types of bracketed configuration files or scripts. Programs may be compiled on Linux or unix by putting &quot;anch&quot; in front of the existing compiler or interpreter. Windows users would need to install something like <a href="http://sourceforge.net/projects/mingw/files/">MingW</a>, <a href="http://www.cygwin.com/">cygwin</a>, or some other unix-like <a href="http://en.wikipedia.org/wiki/Bourne_shell">bourne shell</a> to interpret the included &quot;anch&quot; script.</p>
<pre>
make example
anch gcc example.a.c -o example</pre><p>

Lossy &quot;un-anchoring&quot; of code is provided by a really crappy bash script (requires <a href="http://www.gnu.org/software/indent/">GNU indent</a>). It needs to be re-written in flex.</p>
<pre>
unanchor example.c #see how it might look
unanchor example.c > editme.a.c # create a file</pre><p>

<a href="windows.a.html">see an unanchored C windows program</a></p><h3><a href="http://bellard.org/tcc/">

Optional TinyCC integration</a></h3><p>

The latest version of TinyCC may be gotten from the <a href="http://repo.or.cz/w/tinycc.git">git repo</a> or mob branch and compiled separately. A mob-release Linux (RPM) version of TCC may be found <a href="http://thenerdshow.com/rpm/tinycc-0.9.26-0.1.20101029git.fc14.src.rpm">here</a>.</p><p>

With TinyCC (<a href="http://bellard.org/tcc/">TCC</a>) installed, Anchor can execute pseudocode directly from the command line.</p>
<pre>
anch -run example.a.c
</pre><p>
Or put the following line</p>

<pre><span class="S9">#!/usr/local/bin/anch -run [args]</span></pre><p>

at the top of files to make executable C scripts:</p>
<pre><span class="S9">#!/usr/local/bin/anch -run</span>
<span class="S9">#include &lt;stdio.h&gt;</span>
<span class="S5">int</span><span class="S0"> </span>main<span class="S0">  </span><span class="S5">int</span><span class="S0"> </span>c<span class="S10">,</span><span class="S0"> </span><span class="S5">char</span><span class="S0"> </span><span class="S10">**</span>v
<span class="S0">    </span><span class="S5">while</span><span class="S0">  </span>c<span class="S10">--</span>
<span class="S0">        </span><span class="S16">printf</span><span class="S0">  </span><span class="S6">"Argument %i is \"%s\"\n"</span><span class="S10">,</span>c<span class="S10">,</span>v<span class="S10">[</span>c<span class="S10">]</span>
<span class="S0">    </span><span class="S5">return</span><span class="S0"> </span><span class="S4">0</span>
</pre><h3>
Direct execution</h3><p>

The anch script can use <a href="http://bellard.org/tcc/">TCC</a> to execute through a pipe. For example, if both <a href="http://www.vergenet.net/~conrad/software/xsel/">xsel</a> and <a href="http://bellard.org/tcc/">TCC</a> are installed, the above code may be highlighted with the mouse and executed directly from the selection buffer, with arguments (and without even saving to disk).</p>
<pre>
xsel | anch -run - [args]</pre><p>

Other compilers or interpreters may be invoked through pipes as well:</p>
<pre>
xsel|anchor|gcc -Wall -g -xc -</pre><h3>

Bugs, wiki, changelog</h3><p>

The bugs, wiki, and changelog have moved to <a href="https://code.google.com/p/anch/">Google Code</a>. Bugs may be reported using the issue tracker. The latest version may be checked out from svn, and the wiki may contain updates, tips, and suggestions from users.</p><h3><a name="legal">

Limitations and Copyright</a></h3><p>

No warrantee! Anchor was created as a learning toy for hobbies and fun; it might lack the swagger of commercial projects. The algorithm is potentially lossy and subject to change, so don't distribute important software that depends on it (convert it to the target language first). Programming is a difficult task and Anchor is not guaranteed to make it easier. Our &quot;precompiler&quot;, anch is just a simple bash script that creates a temp file and invokes whatever compiler is normally used. These tools may be freely adapted under the terms of the <a href="http://www.gnu.org/licenses/gpl.html">Gnu Public License</a>.</p>

<p class="small">

Anchor and accompanying documentation are Copyright &copy; 2010 Henry Kroll III. This page may be freely modified and shared under the terms of the Creative Commons SA license inasmuch as it agrees with the terms of the GPL. Any of the above conditions can be waived by getting permission from the copyright holder.</p>



</div>


<!-- begin LEFT BAR -->

<div id="list1" ><a href="http://anch.org">
    <img id="anchor" style="padding-left:20px;border:0px;" src="images/anchor.jpg" alt=

    " Anchor " onmouseover="moveObjRight();" onmouseout="moveObjLeft();" /></a>
    <div class="b" style="top:9em;"> <a href="mailto:nospam&#64;thenerdshow.com?subject=Anchor" title="Feedback">
CONTACT</a></div>
     
     <div class="b" style="top:11em;"> <a href="http://anch.org/" title="Main Page">
AUTHOR</a></div>

    <div class="b" style="top:13em;"> <a href="http://code.google.com/p/anch/" title="Get Anchor">
DOWNLOAD</a></div>

    <div class="b" style="top:13em;"> <a href="#legal" title="License">
LISCENSE</a></div>

    <div class="b" style="top:15em;"><a href="#" onclick="javascript:bookmarksite('Anchor', 'http://thenerdshow.com/anchor.html')">
FAVORITE</a></div>

    <div style="text-align:center; width:150px;">
    <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
    <input type="hidden" name="cmd" value="_s-xclick" />
    <input type="hidden" name="hosted_button_id" value="9TX9RXWDZKVQY" />
    <input style="border: 0" type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" name="submit" alt="PayPal - The safer, easier way to pay online!" />
    <img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1" />
    </form></div><div>

    <div style="width:150px;">
    Follow me on <a href="http://twitter.com/TheManyOne">Twitter</a>, <a href="http://YouTube.com/TheManyOne">YouTube</a>
    <a href="http://themanyone.blogspot.com/">Blogspot</a></div><p>

    Announce to:</p>
        <div>
            <a href="http://www.blinklist.com/index.php?Action=Blink/addblink.php">BlinkList</a>
            <br />  <a href="http://del.icio.us/post">del.icio.us</a>
            <br />  <a href="http://digg.com/submit?phase=2">Digg it</a>
            <br />  <a href="http://www.furl.net/storeIt.jsp">Furl</a>
            <br />  <a href="http://www.netvouz.com/action/submitBookmark?popup=no">Netvouz</a>
            <br />  <a href="http://www.shadows.com/features/tcr.htm">Shadows</a>
            <br />  <a href="http://www.spurl.net/spurl.php">Spurl</a>
            <br />  <a href="http://myweb2.search.yahoo.com/myresults/bookmarklet">Yahoo MyWeb</a>
            <br />  <a href="http://www.google.com/bookmarks/mark?op=edit">Google</a>
            <br />  <a href="http://www.dzone.com/links/add.html">DZone</a>
            <br />  <a href="http://www.stumbleupon.com/submit">StumbleUpon</a>
            <br />  <div><a href="http://www.ifeedreaders.com/social-creator/" style="font:9px Verdana, Arial, Helvetica, sans-serif; width:100px;">Create Social Bookmark Links</a></div>
        </div>
    </div>
</div>
</body>
</html>
