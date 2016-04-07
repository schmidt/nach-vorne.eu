---
layout: post
title: List of callback methods
permalink: /2007/3/18/list-of-callback-methods
---
<p>If you ever wondered about the power of <code>method_missing</code> you were still missing a lot. Ruby has a whole bunch of meta callback methods. Since I always forget some of them, I will try to collect all of them in the following list, so everybody may benefit. If I missed something, please give me a hint.</p>

<table>
<thead><tr><th>Class</th><th>Name</th><th>corresponds to</th></tr></thead>
<tbody>
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001683">included</a></td></tr>
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001684">extended</a></td></tr>
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001659">append_feature</a></td><td>include?</td></tr>
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001716">const_missing</a></td><td>const_defined?</td></tr>
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001685">method_added</a></td></tr>
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001686">method_removed</a></td></tr>
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001687">method_undefined</a></td></tr>
<tr><td>Class</td><td><a href="http://ruby-doc.org/core/classes/Class.html#M002812">inherited</a></td></tr>
<tr><td>Object</td><td><a href="http://ruby-doc.org/core/classes/Object.html#M000372">singleton_method_added</a></td></tr>
<tr><td>Object</td><td><a href="http://ruby-doc.org/core/classes/Object.html#M000373">singleton_method_removed</a></td></tr>
<tr><td>Object</td><td><a href="http://ruby-doc.org/core/classes/Object.html#M000374">singleton_method_undefined</a></td></tr>
<tr><td>Kernel</td><td><a href="http://ruby-doc.org/core/classes/Kernel.html#M005936">at_exit</a></td></tr>
<tr><td>Kernel</td><td><a href="http://ruby-doc.org/core/classes/Kernel.html#M005929">method_missing</a></td><td>respond_to?</td></tr>
<tr><td>Kernel</td><td><a href="http://ruby-doc.org/core/classes/Kernel.html#M005943">set_trace_func</a></td></tr>
<tr><td>Kernel</td><td><a href="http://ruby-doc.org/core/classes/Kernel.html#M005941">trace_var</a></td></tr>
<tr><td>Kernel</td><td><a href="http://ruby-doc.org/core/classes/Kernel.html#M005942">untrace_var</a></td></tr>
<tr><td>ObjectSpace</td><td><a href="http://ruby-doc.org/core/classes/ObjectSpace.html#M006763">each_object</a></td></tr>
</tbody>
</table>

<p>Most of this list is taken from <a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/120436">this discussion on ruby-talk</a>.</p>

<p>And of course there are all these nice collections, you may request.</p>

<table>
<thead><tr><th>Class</th><th>Name</th><th>include super</th></tr></thead>
<tbody>
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001700">ancestors</a></td></tr> 
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001679">constants</a></td></tr> 
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001697">included_modules</a></td></tr> 
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001706">instance_methods</a></td><td><code>true</code></td></tr> 
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001709">private_instance_methods</a></td><td><code>true</code></td></tr> 
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001708">protected_instance_methods</a></td><td><code>true</code></td></tr> 
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001707">public_instance_methods</a></td><td><code>true</code></td></tr>
<tr><td>Module</td><td><a href="http://ruby-doc.org/core/classes/Module.html#M001717">class_variables</a></td></tr> 
<tr><td>Class</td><td><a href="http://ruby-doc.org/core/classes/Class.html#M002816">superclass</a></td></tr> 
<tr><td>Object</td><td><a href="http://ruby-doc.org/core/classes/Object.html#M000359">methods</a></td></tr> 
<tr><td>Object</td><td><a href="http://ruby-doc.org/core/classes/Object.html#M000362">private_methods</a></td><td><code>true</code></td></tr> 
<tr><td>Object</td><td><a href="http://ruby-doc.org/core/classes/Object.html#M000361">protected_methods</a></td><td><code>true</code></td></tr> 
<tr><td>Object</td><td><a href="http://ruby-doc.org/core/classes/Object.html#M000363">public_methods</a></td><td><code>true</code></td></tr> 
<tr><td>Object</td><td><a href="http://ruby-doc.org/core/classes/Object.html#M000360">singleton_methods</a></td><td><code>true</code></td></tr>
<tr><td>Object</td><td><a href="http://ruby-doc.org/core/classes/Object.html#M000364">instance_variables</a></td></tr> 
</tbody>
</table>

<p>Please note, that most of the <code>*methods</code> have a parameter, which allows you to exclude inherited properties from the answer (as listed in the table).</p>

<p>Every ambitous Ruby programmer should have a look at these and come back each one or two 
months. These methods will allow you some shortcuts and more elegant solutions. As well, make sure, that these still work, after you introduced changes on the meta-level.</p>
