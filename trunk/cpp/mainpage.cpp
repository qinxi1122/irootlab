/**
@mainpage Main Page

@section main_intro Introduction

IRootLab is an open-source project dedicated to providing a MATLAB framework for  biospectroscopy. The goal of the IRootLab project is to provide a
comprehensive and user-friendly environment for analysis, and at the same time facilitate the development and validation of algorithms
for biospectroscopy.

Project website: http://irootlab.googlecode.com

@section gettingstarted_install Installation

Download the most recent ZIP file from http://irootlab.googlecode.com and extract the file into a directory of your choice.

@section gettingstarted Getting started

The recommended way is to add the required directories to path after starting MATLAB:
<ol>
  <li> Start MATLAB </li>
  <li> Change MATLAB's "Current directory" to the directory created when unzipping IRootLab (should contain a file called "startup.m")</li>
  <li> In MATLAB's command line, enter
@code
startup
@endcode
This will set the MATLAB path.</li>
  <li> You are ready to use IRootLab!</li>
</ol>

This methods is the safest, as you will keep your MATLAB path "clean", being less likely to have name conflicts with other toolboxes and between different IRootLab versions.

Alternatively, you can use MATLAB "Set path..." (add with subdirectories), and point to the directory above. This will keep you from having to run "startup" every time you
start MATLAB. Make sure you remove the old directories from the path when you download a new version of IRootLab.

@subsection gettingstarted_requirements System requirements

IRootLab will run wherever MATLAB can be installed. The oldest MATLAB version tested was r2007b.

Recently, we have been using MATLAB Parallel Computing Toolbox (PCT) to paralellize certain algorithms, but there is always a choice to run the non-parallel version.

We use the MATLAB Wavelet Toolbox for Wavelet de-noising.

<h3>gettingstarted_requirements2 Platform-specific binaries</h3>

@arg SVM classifier (LibSVM): LibSVM was successfully compiled for Windows 32-bit/Windows 64-bit; Linux 32-bit/64-bit.
@arg MySQL connector (mYm): mYm was currently compiled Windows 32-bit; Linux 32-bit/64-bit. Linux 64-bit: libmysqlclient.so.16 and  libmysqlclient.so.18.

@subsection gettingstarted_more More

@arg Manual, tutorials and sample data at http://code.google.com/p/irootlab/downloads/list

*/
