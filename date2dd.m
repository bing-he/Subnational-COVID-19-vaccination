function [dd]=date2dd(ymdhms,refyr)
%[dd]=date2dd(ymdhms,refyr);
% Converts a year, month, day, hour, minute,
% second into digital day. Refyr is optional; 
% if not supplied the default reference year 
% is taken from the first argument.
%
% dd=date2dd([y, m, d, h, m, s],refyr) 
%
% Note Jan 1 at 0000 UT of the reference year 
% equals digitial day zero.

y=ymdhms(:,1);
m=ymdhms(:,2);
d=ymdhms(:,3);
h=ymdhms(:,4);
mn=ymdhms(:,5);
s=ymdhms(:,6);

% If no reference year specified, use the first year in record
if(nargin==1) 
  refyr=y(1,1);
end

dday=datenum(y,m,d,h,mn,s);
Ny=datenum(y,1,1,0,0,0); 
Nrefyr=datenum(refyr,1,1,0,0,0); 
Noffset=Ny-Nrefyr;
dd=dday-Ny+Noffset;

