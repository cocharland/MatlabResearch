function buildGif(lines,obj,n)
h = figure(99);
filename = 'drawingLines.gif';
axis tight manual
image(obj.physicalMap,'Cdatamapping','scaled')
a = gca;
a.YDir = 'normal';
hold on

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
end
drawnow

frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
if n == 1
    imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
else
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end
end

