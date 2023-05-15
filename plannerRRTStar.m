classdef plannerRRTStar < plannerRRT
    %PLANNERRRTSTAR  Geometric optimal RRT (RRT*) path planner
    %   plannerRRTStar creates an asymptotically-optimal RRT planner. RRT* 
    %   algorithm is derived from the RRT algorithm and it is guaranteed
    %   to converge to an optimal solution, meanwhile, its runtime is 
    %   guaranteed to be a constant factor of the runtime of RRT algorithm. 
    %   The optimality here is defined with respect to the distance function
    %   of the state space. It should be noted that RRT* algorithm can only
    %   be used to solve geometric planning problems, in other words, it
    %   requires that any two random states drawn from the state space
    %   can be connected.
    %
    %   plannerRRTStar(STATESPACE, STATEVAL) creates an RRT* planner from a 
    %   state space object, STATESPACE, and a state validator object,
    %   STATEVAL. STATEVAL's state space must be the same as STATESPACE.
    %
    %   plannerRRTStar properties:
    %      BallRadiusConstant       - Constant used to compute ball radius for finding near neighbors 
    %      ContinueAfterGoalReached - Whether to continue optimizing path after goal is reached
    %      StateSpace               - State space for the planner
    %      StateValidator           - State validator for the planner
    %      MaxNumTreeNodes          - Max number of tree nodes
    %      MaxIterations            - Max number of iterations  
    %      MaxConnectionDistance    - Max connection distance between two states
    %      GoalReachedFcn           - Callback for determing if goal is reached
    %      GoalBias                 - Probability of choosing goal state during state sampling
    %
    %   plannerRRTStar methods:
    %      plan    - Plan a path between two states
    %      copy    - Create deep copy of the planner object
    %
    %   Example:
    %      % Create a state space
    %      ss = stateSpaceSE2;
    %
    %      % Create a occupancyMap-based state validator using the state space just created
    %      sv = validatorOccupancyMap(ss);
    %
    %      % Update the map for state validator, set map resolution 10 cells/meter
    %      load exampleMaps
    %      map = occupancyMap(simpleMap, 10);
    %      sv.Map = map;
    %
    %      % Set validation distance for the validator
    %      sv.ValidationDistance = 0.01;
    %
    %      % Update state space bounds to be the same as map limits
    %      ss.StateBounds = [map.XWorldLimits; map.YWorldLimits; [-pi pi]];
    %
    %      % Create RRT* path planner and configure
    %      planner = plannerRRTStar(ss, sv);
    %
    %      % Allow further optimization
    %      planner.ContinueAfterGoalReached = true;
    %
    %      % Reduce max iterations
    %      planner.MaxIterations = 2500;
    %
    %      % Increase max connection distance
    %      planner.MaxConnectionDistance = 0.3;
    %
    %      % Set the start and goal states
    %      start = [0.5, 0.5 0];
    %      goal = [2.5, 0.2, 0];
    %
    %      % Plan a path with default settings, set rng for repetitive result
    %      rng(100, 'twister')
    %      [pthObj, solnInfo] = plan(planner, start, goal)
    %
    %      % Show the results
    %      map.show;
    %      hold on;
    %      plot(solnInfo.TreeData(:,1), solnInfo.TreeData(:,2), '.-'); % tree expansion
    %      plot(pthObj.States(:,1), pthObj.States(:,2), 'r-', 'LineWidth', 2) % draw path
    %     
    %
    %   References: 
    %   [1] S. Karaman, E. Frazzoli, "Sampling-based algorithms for optimal motion planning",
    %       International Journal of Robotics Research, vol. 30, no. 7,
    %       pp. 846-894, Jun 2011
    %
    %   See also plannerRRT
    
    %   Copyright 2019 The MathWorks, Inc.

    properties (Constant, Access = {?nav.algs.internal.InternalAccess})
        %ClassName
        ClassName = 'plannerRRTStar'
    end
    
    properties
        %BallRadiusConstant Constant used to estimate the near neighbors search radius
        %   The radius is estimated as following:
        %   
        %      r =  min( ((gamma/Vd)*(log(n)/n))^(1/d), ita)
        %
        %   where
        %      d is the dimension of the state,
        %      n is the number of nodes in the search tree,
        %      ita is the MaxConnectionDistance,
        %      Vd is the volume of unit ball in d dimensions,
        %      gamma is a constant.
        %      This property, BallRadiusConstant, is equivalent to gamma/Vd
        %      in the formula. Larger BallRadiusConstant means the search
        %      radius shrinks slower as the number of nodes in the tree
        %      increases.
        %
        %   Default: 100
        BallRadiusConstant
        
        %ContinueAfterGoalReached Continue to optimize path after goal is reached
        %   Planning will stop after the max number of iterations or max
        %   number of tree nodes is reached.
        %
        %   Default: false
        ContinueAfterGoalReached
    end
    
    methods
        function obj = plannerRRTStar(ss, sv)
            %PLANNERRRTSTAR Constructor
            obj@plannerRRT(ss, sv);
            
            obj.BallRadiusConstant = 100;
            obj.ContinueAfterGoalReached = false;
        end
        
        function objCopied = copy(obj)
            %COPY Create a deep copy of the plannerRRTStar object
            %   PLANNERCOPIED = COPY(PLANNER) creates a deep copy of the
            %   existing plannerRRTStar object, PLANNER, and returns
            %   the new object in PLANNERCOPIED.
            
            validator = obj.StateValidator.copy;
            
            objCopied = plannerRRTStar(validator.StateSpace, validator);
            obj.copyProperties(objCopied);
        end
    end
    
    methods (Access = {?nav.algs.internal.InternalAccess})
        
        function preLoopSetup(obj)
            %preLoopSetup
            obj.TreeInternal.setBallRadiusConstant(obj.BallRadiusConstant);
            obj.TreeInternal.setMaxConnectionDistance(obj.MaxConnectionDistance);
            
        end
        
        function [newNodeId, statusCode] = extend(obj, randState)
            %extend The optimal RRT "Extend" routine

            statusCode = obj.InProgress;
            newNodeId = nan;
            
            idNN = obj.TreeInternal.nearestNeighbor(randState);
            stateNN = obj.TreeInternal.getNodeState(idNN);
            costNN = obj.TreeInternal.getNodeCostFromRoot(idNN);
            
            d = obj.StateSpace.distance(stateNN, randState);    %Distanz zum neuen Knoten festlegen
            if d < 1e-10 % avoid adding the same state multiple times
                statusCode = obj.ExistingState;
                return;
            end
            stateNew = randState;  %Zufälliger Punkt wird zum neuen Knoten
            
            % steer
            if d > obj.MaxConnectionDistance
                stateNew = obj.StateSpace.interpolate(stateNN, randState, obj.MaxConnectionDistance/d);  % L/d*(randState - nnState) + nnState;
                d = obj.MaxConnectionDistance;
            end
            costNew = costNN + d;

            % check motion validity
            if ~obj.StateValidator.isMotionValid(stateNN, stateNew)
                statusCode = obj.MotionInCollision;
                return;
            else
                nearIndices = obj.TreeInternal.near(stateNew);
                
                % look around at the near neighbors and insert stateNew
                % under the one that has lowest cost
                costMin = costNew;
                idMin = -1;
                    
                for idNear = nearIndices
                    stateNear = obj.TreeInternal.getNodeState(idNear);
                    costNear = obj.TreeInternal.getNodeCostFromRoot(idNear);

                    costNewTenative = costNear + obj.StateSpace.distance(stateNear, stateNew);
                    
                    if costMin > costNewTenative ...
                        && obj.StateValidator.isMotionValid(stateNear, stateNew)
                        
                        costMin = costNewTenative;
                        idMin = idNear;
                    end
                end
                
                if idMin >= 0
                    idNew = obj.TreeInternal.insertNode(stateNew, idMin);
                else
                    idNew = obj.TreeInternal.insertNode(stateNew, idNN);
                end
                newNodeId = idNew;
                
                % now see if it's possible to rewire any of the near
                % neighbors under the newly added node
                if idMin >= 0
                    nearIndices = nearIndices(nearIndices~=idMin);
                end


                for idNear = nearIndices
                    stateNear = obj.TreeInternal.getNodeState(idNear);
                    costNear = obj.TreeInternal.getNodeCostFromRoot(idNear);
                    if costNear > costNew + obj.StateSpace.distance(stateNear, stateNew) && ...
                        obj.StateValidator.isMotionValid(stateNear, stateNew)
                        rewireStatus = obj.TreeInternal.rewire(idNear, idNew); %#ok<NASGU>
                        %fprintf('attempted to rewire node %d under node %d, result: [%d]\n', idNear, idNew, rewireStatus);
                    end
                end
                
            end
            
            if feval(obj.GoalReachedFcn, obj, obj.CurrentGoalState, stateNew)
                if obj.ContinueAfterGoalReached
                    statusCode = obj.GoalReachedButContinue;
                else
                    statusCode = obj.GoalReached;
                end
                return;
            end
            
            if newNodeId == obj.MaxNumTreeNodes
                statusCode = obj.MaxNumTreeNodesReached;
                return
            end
        end

    end
    
    methods(Access = protected)
        function cname = getClassName(obj) %#ok<MANU>
            %getClassName
            cname = 'plannerRRTStar';
        end
        
        function copyProperties(obj, copyObj)
            %copyProperties Copy property data from this object to a new object

            % Copy all properties of the base RRT class
            copyProperties@plannerRRT(obj, copyObj);

            % Copy plannerRRTStar specific properties
            copyObj.BallRadiusConstant = obj.BallRadiusConstant;
            copyObj.ContinueAfterGoalReached = obj.ContinueAfterGoalReached;
        end
    end
    
    % setters
    methods
        function set.BallRadiusConstant(obj, radiusConstant)
            %set.BallRadiusConstant
            robotics.internal.validation.validatePositiveNumericScalar(radiusConstant, getClassName(obj), 'BallRadiusConstant');
            obj.BallRadiusConstant = radiusConstant;
        end
        
        function set.ContinueAfterGoalReached(obj, contFlag)
            %set.ContinueAfterGoalReached
            robotics.internal.validation.validateLogical(contFlag, getClassName(obj), 'ContinueAfterGoalReached');
            obj.ContinueAfterGoalReached = logical(contFlag);
        end
    end
end

