function Mins = LocalMinima(x, NotCloserThan, LessThan)
% LOCALMINIMA   Finds positions of all local minima in input array
%   mins = LocalMinima(x) finds local minima in x
%   mins = LocalMininma(x, NotCloserThan, LessThan) finds local minima
%   using an additional two arguments: 
%
%   NotCloserThan   Second optional argument that provides minimum distance
%   between two minima. 
%
%   LessThan        Third optional argument that sets a threshold value for
%   local minima. This option is recommended when computing minima of a
%   long array for efficient use of time and memory. 

% --- Checks if input array is a vector. 
if min(size(x))>1
    error('x should be a vector');
end
x = x(:);
nPoints = length(x);


% --- Identifies points in input array below LessThan.
% Uses third optional argument 
if nargin<3
    BelowThresh = (1:nPoints)';
else
    BelowThresh = find(x<LessThan);
end
xBelow = x(BelowThresh);
GapToLeft = find(diff([0; BelowThresh])>1);
GapToRight = find(diff([BelowThresh; nPoints+1])>1);

% --- Compute left and right signs.
% A local minumum occurs where the derivative of the input array changes
% from negative to positive as we scan from left to right. To find local
% minima, we identify the position of this sign change. 
sDiff = sign(diff(xBelow));
LeftSign = [1; sDiff];
LeftSign(GapToLeft) = -1;
RightSign = [sDiff; -1];
RightSign(GapToRight) = 1;

% --- Replace zero right signs with the next next non-zero value.
Zeros = find(RightSign==0);
for i=fliplr(Zeros(:)')
    RightSign(i) = RightSign(i+1);
end
    
% --- Compute local minima.
Mins = BelowThresh(find(LeftSign<0 & RightSign>0));

% --- Remove local minima that are too close.
% Uses second optional argument 
if nargin>=2
    while 1
        TooClose = find(diff(Mins)<NotCloserThan);
        if isempty(TooClose)
            break;
        end
%        Vals = x(Mins(TooClose:TooClose+1));
        Vals = [x(Mins(TooClose)) , x(Mins(TooClose+1))];
        [dummy Offset] = max(Vals,[],2);
        Delete = TooClose + Offset -1;
        Mins(unique(Delete)) = [];
    end
end

return

if nargin<3
    LessThan = inf;
end

nPoints = length(x);
nMins = 0;
ArraySize = floor(nPoints/10);
Mins = zeros(ArraySize,1);
PrevSign = 1;
for i=1:length(x)-1
    NextSign = sign(x(i+1)-x(i));
    
    % Is there a local minimum?
    if (PrevSign<0 & NextSign>0 & x(i)<LessThan)
        nMins = nMins+1;
        Mins(nMins) = i;
    end

    % Reset PrevSign, if we are not in equality situation
    if NextSign
        PrevSign=NextSign;
    end
end

% --- Use only those we have.
if nMins<ArraySize
    Mins(nMins+1:ArraySize) = [];
end
    
% --- Check for duplicates.

if nargin>=2
    while 1
        TooClose = find(diff(Mins)<NotCloserThan);
        if isempty(TooClose)
            break;
        end
        Vals = x(Mins(TooClose:TooClose+1));
        [dummy Offset] = max(Vals,[],2);
        Delete = TooClose + Offset -1;
        Mins(unique(Delete)) = [];
    end
end

return


nPoints = length(x);

s = int8([1 sign(diff(x))]);

Zeros = find(s==0);
NonZeros = uint32(find(s~=0));

% --- Remove zeros.
s(Zeros) = [];

% mins = find(s(1:nPoints-1)==-1 & s(2:end)==1);
mins = double(NonZeros(findstr(s, [-1 1])));

if nargin>=3
    mins = mins(find(x(mins)<LessThan));
end

if nargin>=2
    while 1
        TooClose = find(diff(mins)<NotCloserThan);
        if isempty(TooClose)
            break;
        end
        Vals = x(mins(TooClose:TooClose+1));
        [dummy Offset] = max(Vals,[],2);
        Delete = TooClose + Offset -1;
        mins(unique(Delete)) = [];
    end
end