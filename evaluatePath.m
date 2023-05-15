function [length,avgAngle] = evaluatePath(path)



length=calculatePathLength(path);
avgAngle=pathSmoothness(path);

end

