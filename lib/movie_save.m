function movie_save(frames,movie_name)
%% movie_save - save the movie of the animation
% 
% REFERENCE:
%       None
% 
% 
% INPUT:
%       frames      - figure object
%       movie_name  - the name of the movie
% 
% 
% OUTPUT:
%       None to return, but a gif is saved to the disk.
% 
% 
% AUTHOR:
%       Lijun SUN

%% loop
for idx = 1:length(frames)
    frame = frames(idx); 
    img = frame2im(frame); 
    [img_indexed,cmap] = rgb2ind(img,256); 
    % Write to the GIF File 
    if idx == 1 
      imwrite(img_indexed,cmap,movie_name,'gif','Loopcount',Inf,...
          'DelayTime',0); 
    else 
      imwrite(img_indexed,cmap,movie_name,'gif','WriteMode','append',...
          'DelayTime',0); 
    end 
end
% END for idx = 1:length(frames)

end