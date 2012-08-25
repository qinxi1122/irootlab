%> @ingroup as
%> @brief Analysis Session (AS) base class.
%>
%> General processing routine.
%>
%> Definition of AS:
%>   @arg has a <code>log = go()</endcode> method that outputs an @ref irlog object
%>
%> Some classes may have an "input" property which is considered to be the most important parameter.
%>
%> Differences between @c as and @c block
%> <ul>
%>   <li>@c as has free functionality (no @c boot, @c train and @c use methods necessarily exist. On the other hand, different functionalities may exist). </li>
%>   <li>@c as may have no clear "input". Technically it has not input at all. Rather, all properties must be set, then
%> a parameterless method (e.g., "go()") is called.</li>
%> </ul>
%>
classdef as < irobj
    methods
        function o = as()
            o.classtitle = 'Analysis Session';
            o.color = [211, 129, 229]/255;
            o.moreactions = [o.moreactions, {'go'}];
        end;
    end;
end
