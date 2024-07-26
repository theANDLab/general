% John Maule - University of Sussex - Sept 2018
try
    clear
Screen('Preference','SkipSyncTests',2);
% ListenChar(2);
% HideCursor;

scrNum = max(Screen('Screens')); 
% make a whole screen image matrix which has four regions of colour which
% could only be rendered differently under 10-bit colour
scrRect = Screen('Rect', scrNum);
scrIndex = zeros(scrRect(4), scrRect(3));
% make the matrix contain numbers 1,2,3,4
scrIndex(1:scrRect(4)/2 , 1:scrRect(3)/2) = 1;
scrIndex((scrRect(4)/2)+1:end  , 1:scrRect(3)/2) = 2;
scrIndex(1:scrRect(4)/2 , (scrRect(3)/2)+1:end) = 3;
scrIndex((scrRect(4)/2)+1:end , (scrRect(3)/2)+1:end) = 4;

bits = 10;
maxColour = 1;

%pick four RGB values
levels10bit = linspace(0,maxColour,2^bits);
startLevel = (2^bits)/2;
rgbList = levels10bit(startLevel:startLevel+3);
rgbList = repmat(rgbList,1,3);

% turn into RGB matrix
r = rgbList(scrIndex);
g = rgbList(scrIndex);
b = rgbList(scrIndex);

scrTex(:,:,1) = reshape(r,size(scrIndex));
scrTex(:,:,2) = reshape(g,size(scrIndex));
scrTex(:,:,3) = reshape(b,size(scrIndex));

% open screen and present
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
if bits == 10
    PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'EnableNative10BitFramebuffer');
end
PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange',1);
[wPtr, scrRect] = PsychImaging('OpenWindow', scrNum,[0 0 0]);
[oldRange, ~ , ~] = Screen('ColorRange',wPtr,maxColour,0,1);
% make the texture
texHandle = Screen('MakeTexture',wPtr,scrTex,[],[],2);
%                                                  ^ this argument is floatprecision, 1 is 16-bit, 2 is 32-bit
% draw the texture
Screen('DrawTexture',wPtr,texHandle);  
% Write some text on the screen
DrawFormattedText(wPtr,num2str(rgbList(1:4)*255),[],[],[0 0 0]); 
% DrawFormattedText(wPtr,'Press a key to exit','center',20,[maxColour maxColour maxColour]); 
% Flip the screen
Screen('Flip',wPtr);
% Wait for a key press
KbWait;

%%%%%%%%%%%%%%% EXPERIMENT CODE ENDS
%% closing, restoring stuff
% screen close all    
sca
% restore sync tests
Screen('Preference','SkipSyncTests',0);
% restore keyboard function
ListenChar(0);
% restore cursor
ShowCursor;
% hooray - if we're at this point then the script ran without issues -
% print a message to the command line to let the user know - not essential
disp('Finished without error')

catch whatsTheProblem % if something goes wrong keep the details
% screen close all    
sca
% restore sync tests
Screen('Preference','SkipSyncTests',0);
% restore keyboard function
ListenChar(0);
% restore cursor
ShowCursor;
% write a message to the command line - not essential
disp('Error encountered, screen closed')
% give us the error text in the command line (without this the error is
% passed over and we won't get the information
rethrow( whatsTheProblem )
% give us any PTB-related error details
psychlasterror
end