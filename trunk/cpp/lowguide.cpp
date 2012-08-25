/**
@page lowguide Low-level Guide

This guide was generated from the file lowguide.cpp.

@section lowguide_who Who should read this guide

This guide is directed to users who want contribute to expand the IRoot project, fix bugs, improve documentation, or simply understand the internals.

@section lowguide_scope Scope

This guide contains important details about how to inherit from different object classes, and how to write documentation.

@section lowguide_irobj Inheriting the "irobj" class

There are two steps to bringing a new @ref irobj to life
@arg Inherit one of the base classes (@ref block, @ref as etc (for the "etc", check direct descendants from @ref irobj))
@arg (optional) Create a properties GUI, if the new class has any options (properties that need to be set)

The second step is optional and intended to allow the block to be created from @c datatool or @c objtool. If not done, instances of the new class will either be created from the GUI with
a default setup, or will not be available in the GUI at all (this is set by irobj::flag_ui)

@warning From my own experience, it is common to use an existing class as a model for a new class, but forget to rename the constructor (MATLAB does not warn about this mistake as it
thinks your wanna-be constructor is just an ordinary method). The constructor must have the same name
as the class itself. Please make sure that your constructor has the right name and it is being called when the object is created (either by setting a breakpoint or checking if
the newly created object's @ref irobj::classtitle property has the expected value).

@subsection lowguide_high Properties to set in the constructor of new object class

The following properties within @ref irobj define how the GUI will handle the class
@arg irobj::classtitle
@arg irobj::flag_params: whether the GUI will attempt to call a GUI named <code>uip_<classname>.fig</code>, where <code><classname></code> is the name of the new class
@arg irobj::flag_ui: whether the object class will be available to be created from the GUI at all
@arg irobj::moreactions: informs @c objtool about methods that can be called (highly used when @ref as is inherited)
@arg irobj::color

@subsection lowguide_uip Creating a properties Dialog Box

This is when you chose your class to have <code>flag_ui=1</code>.

The easiest way is probably to open an existing properties Dialog Box and save it with the appropriate name (see below).

@note Properties Dialog file names follow the following pattern: <code>uip_<corresponding class name>.m</code>. If the Dialog Box was created in MATLAB's GUIDE (@c guide MATLAB command),
there will be a corresponding <code>uip_<corresponding class name>.fig</code> file as well.

@section lowguide_block Inheriting the "block" class

The previous section (@ref lowguide_irobj) also applies to creating a new @ref block, since blocks descend from @ref irobj.

The following properties constitute a @ref block setup. You should set the appropriate values to the relevant ones at the constructor of your block.
@arg block::inputclass
@arg block::flag_bootable
@arg block::flag_trainable
@arg block::flag_fixednf
@arg block::flag_fixedno
@arg block::flag_multiin
@arg block::flag_out

Typical methods to inherit in a block class are do_boot(), do_train(), and do_use().

@section lowguide_block_cascade Inheriting a "block_cascade_base"

The @ref block_cascade_base class can be inherited to create a block that encapsulates other blocks. The @ref cascade_pcalda class can serve as an example. You may not have
to create a new properties GUI, but re-use existing GUIs instead (see @ref uip_cascade_pcalda.m)

Creating such blocks as @ref cascade_pcalda justifies itself as to facilitate the life of high-level users who perform a sequence of steps very often.

Also note that @ref block_cascade_base multiplies the loadings (@ref block_cascade_base::L) of its component linear blocks to give an overall loadings matrix.

@section lowguide_as Inheriting the "as" class

The @ref as class (Analysis Session) has less formality then a @ref block, but there is an emerging pattern for creating your own Analysis Sessions:
@arg Set the heavy work to be executed within a "go()" method
@arg Write a set of "extract_*()" methods to extract results
@arg Add the methods mentioned above to the @ref irobj::moreactions property in the constructor
@arg Think about what to clear in the "clean()" method (at least the "data" property), to spare memory.

@section lowguide_doc Writing documentation

Doxygen (http://www.stack.nl/~dimitri/doxygen) was the choice of documentation tool for IRoot, mainly because of the high quality of its generated HTML website, with a
built-in Javascript Search Engine, generation of graphical class inheritance diagrams, and a high degree of linking across pages. Besides, Doxygen is Free Software.

Finished the advertisement, the problems start.
@arg MATLAB has its own standard for putting a bunch of comments after function declaration, which we completely broke. So, typing <code>help &lt;something&gt;</code> won't
give the most clean, readable information. For this reason, the alternative <code>iroothelp</code> exists
@arg Doxygen was not designed to document MATLAB code. We had to use a MATLAB-to-C++ filter/converter (@c m2cpp.pl) to make Doxygen indirectly "understand" MATLAB code.
@arg Perfect m-to-C++ conversion is impossible. MATLAB supports "varargout" and "varargin" information passing from and to functions that find no parallel in C++. When we happen to
use varargin/varargout, we need alternative ways of documenting (see example: @ref blockmenu.m)
@arg MATLAB public functions exist in a 1-to-1 relation with files (1 function per file). We choose to document the @b file, not the function, because its brief description appears in the file list.
The only documentation attached to the function itself are the function parameters.

With this solutions provided, the resulting documentation is far better (to our knowledge and so far) than any achieved using MATLAB documentation standards.

@subsection lowguide_conventions Some weird conventions

@arg Class .m files have no file-level description
@arg Function .m files have no function-level description, just file-level descriptions

The above rules were adopted because when you click on the "file list" at the HTML documentation: all files appear with descriptions of the functions that
they represent, and all classes appear with no description. However, you can view the classes brief descriptions when you click on the "class list".

@subsection lowguide_doxy Documentation sources, images, configuration etc

These are located in the <code>~/trunk/doxy</code> directory.

@subsection lowguide_doc_modules Modules

Doxygen's "ingroup" tag is used to group specially the @b misc functions, but some classes are included, too, in the groupings.

@note There is intersection between groups, i.e., a file may belong simultaneously to 2 or more groups.

@note the following sections need developing


@section lowguide_svn Version control using Subversion

Technical details...

@subsection lowguide_svn_shells Graphical shell Suggestions
@arg Linux: @c kdesvn shell
@arg Windows: heard of TurtoiseSVN shell, but never used

@subsection lowguide_svn_other

@arg Disable your editors making backup copies. This can be quite annoying polluting the directories with unversioned files.

@section lowguide_globals Global Variables

Here is a list of global variables used in/by IRoot:

@arg @c IRCODE
@arg @c PARALLEL
@arg @c VERBOSE
@arg various variables for graphics setup (see @ref fig_assert.m)
@arg CLASSMAP

A Sub-system is a set of functions that share some global variable or variables. The following sub-systems exist:

@section stylevariables Colors and Styles globals

<b>Example of use of @c SCALE</b>: suppose that you want to generate two figures for your paper, and they are
full-page-width and half-page-width respectively. Then generate your figures with @c SCALE @c = @c 1 and @c 2
respectively, because when you shrink the second figure to half size, its lines, text and markers will look the same
size as in the first figure.

@section verboselevels Verbose levels

See irverbose.m

@section lowguide_develop Topics to be developed...

@section lowguide_folders Folder organization

Each misc file is placed within a folder with the name of its "primary" group (this is somewhat subjective, but does provide some organization).

---END---

*/
