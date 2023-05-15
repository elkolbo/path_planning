function [nodeState] = getNodeFromValidSquare(squareStates)
%A node in the middle of a valid square is calculated
%   If a square is tested as valid by the function checkstatus a node
%   should be added in the middle of it. This function calculates the state
%   of this node. The state is calculated by adding the values of the
%   states at the rim and then dividing by 2.
nodeState=0.5*[squareStates(1,1,1)+squareStates(1,end,1), squareStates(1,1,2)+squareStates(end,1,2), 0];

end

