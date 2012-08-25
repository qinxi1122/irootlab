%> @file
%> @ingroup parallel misc
%> @brief Executes line of code passed as string, e-mails result, and quits MATLAB
%>
%> This function was created to be called in Lancaster University HEC system, but will work anywhere. It is intended to execute one line of
%> code (passed as string and eval()'ed). When the code finishes, it will try to e-mail the generated <code>output_iroot_*.txt</code> file
%> to someone if an e-mail address is provided. It contains a try-catch structure to make sure that MATLAB will exit.
%> <code>VERBOSE.flag_file</VERBOSE> is activated and the \c verbose sub-system is reset.
function fire_job(scode, email)


flag_success = 0;
try
    verbose_assert();
    verbose_reset();
    global VERBOSE;
    VERBOSE.flag_file = 1;
    VERBOSE.minlevel = 1;
    VERBOSE.flag_file = 1;

    eval(scode);
    
    flag_success = 1;
catch ME
    irverbose(['Caught execution error, check dbstack() in stdout. Message is: ', ME.message], 3);
end;


try
    if nargin > 1 && ~isempty(email)
        if ~isunix
            irverbose('Sorry, cannot send e-mail because only Unix systems are currently supported');
        else
            subj = 'From IRtools: ';
            if flag_success
                subj = cat(2, subj, 'Job finished successfully');
            else
                subj = cat(2, subj, 'Krash');
            end;

            global VERBOSE;

            system(sprintf('mail -s "%s" "%s" < "%s"', subj, email, VERBOSE.filename));
            irverbose(['E-mailed result to ', email], 3);
        end;
    end;
catch ME
    irverbose(['Error inside fire_job(): ', ME.message], 3);
end;

exit;