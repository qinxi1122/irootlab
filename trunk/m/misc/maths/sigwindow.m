%>@ingroup maths
%>@file
%>@brief Point-by-point multiplication by sigmoid function
%>
%> Kills smoothly values above and below xrange. The transition zone will
%> have xwindowinterval length
%>
%> the x* values are relative to data vars x. They are converted to indexes.
%>
%> Applies a window for the coefficients to have smooth transition
%> between their current values and zero.
%> I chose the sigmoid function 1/(1+e^(k*x)) because it is easy to use
%> This function stabilizes at around k*x = +-6
%> I want this interval to be stretched to wninterval = 30 wavenumbers
%> (my first attempt, may be different below), because my region of
%> interest is 1770-940 and I know that 1800-900 is still ok.
%
%> @param X
%> @param idxs_range First and last indexes of window, i.e., indexes where window will be 0.5
%> @param scale length for sigmoid to go from 0.5 to .995 or .005
%> @return X
function X = sigwindow(X, idxs_range, scale)
    
feax = data.fea_x;

nf = length(feax);
x_per_f = abs((feax(end)-feax(1))/(nf-1)); % features may not be equally spaced along the x axis, this is a good average though
feainterval = xwindowinterval/x_per_f;
kscale = 12/feainterval;
fearange = v_x2ind(xrange, feax); % features not to be zeroed

X = data.X;
X = sigwindowuni(X, fearange(1)-feainterval/2, kscale);
X = sigwindowuni(X, fearange(2)+feainterval/2, -kscale);
data = data_set_X(data, X);




