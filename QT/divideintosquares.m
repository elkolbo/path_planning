function [divided] = divideintosquares(states)
%divide rectangular array into 4 rectangular smaller arrays of same size (if possible).


size_bigsquare_x=size(states,1);
size_bigsquare_y=size(states,2);


divided.bottomleft=states(1:floor(size_bigsquare_x/2),1:floor(size_bigsquare_y/2),:);
divided.bottomright=states(1:floor(size_bigsquare_x/2),floor(size_bigsquare_y/2)+1:end,:);

divided.topleft=states(floor(size_bigsquare_x/2)+1:end,1:floor(size_bigsquare_y/2),:);
divided.topright=states(floor(size_bigsquare_x/2)+1:end,floor(size_bigsquare_y/2)+1:end,:);
end

